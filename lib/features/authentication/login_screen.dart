import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/features/authentication/providers/auth_provider.dart';
import 'package:sectec30/utils/alert_dialog.dart';
import 'package:sectec30/utils/custom_text_form_field.dart';
import 'package:sectec30/utils/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan/scan.dart';
import 'package:sectec30/features/notification/providers/firebase_push_notification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  final _loginFormKey = GlobalKey<FormBuilderState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  Future<String> scanQR() async {
    var barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    return barcodeScanRes;
  }

  Future<String> decodeImage(String imagePath) async {
    String? str = await Scan.parse(imagePath);
    return str ?? '';
  }

  void _loginQrFromFile(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? _file = await picker.pickImage(source: ImageSource.gallery);
      if (_file == null) {
        return;
      }

      String qr = await decodeImage(_file.path);

      if (qr.isEmpty) {
        NotifyUI.showBasic(
            context, 'Aviso', 'No se encontró código qr o es inválido');
        return;
      }

      ref.read(authProvider.notifier).loginWithQr(qr);
    } catch (error) {
      await NotifyUI.showBasic(context, 'Aviso', error.toString());
    }
  }

  void _logOut(BuildContext context) async {
    ref.read(authProvider.notifier).logout();
  }

  _loginWithCamera(BuildContext context) async {
    var request = await Permission.camera.request();
    print(request);

    if (request.isGranted) {
      // Permiso concedido, puedes usar la cámara
      String qr = await scanQR();
      if (qr != "-1") {
        final container = ProviderContainer();
        final firebasePushNotification =
            container.read(firebasePushNotificationProvider);

        await firebasePushNotification.getFCMToken();

        container.dispose();
        //Map<String, dynamic> response = await signInController.authenticate(qr);
        ref.read(authProvider.notifier).loginWithQr(qr);
      } else {
        NotifyUI.showBasic(
            context, 'Aviso', 'Escaneo de QR cancelado o inválido');
      }
      return;
    } else {
      // Permiso denegado, mostrar diálogo de solicitud de permisos
      showDialogPermissions();
    }
  }

  _loginWithEmail() async {
    if (_loginFormKey.currentState?.saveAndValidate() ?? false) {
      Map<String, dynamic>? _data = _loginFormKey.currentState?.value;
      ref
          .read(authProvider.notifier)
          .loginWithCredentials(_data?['email'], _data?['password']);
    } else {
      debugPrint(_loginFormKey.currentState?.value.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      NotifyUI.showBasic(context, 'Aviso', next.errorMessage);
    });
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            resizeToAvoidBottomInset: true,
            body: ModalProgressHUD(
              inAsyncCall: ref.watch(isLoadingSingInProvider),
              child: SingleChildScrollView(child: loginOptions(context)),
            )));
  }

  Widget loginOptions(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .12),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/images/logo-3.png',
                width: 120,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Iniciar sesión con',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              _button(Icons.qr_code, "Escanear el QR de tu credencial",
                  "camera", context),
              _button(Icons.upload_file_sharp, "Buscar el QR en mis archivos",
                  "qr", context),
              const SizedBox(
                height: 10,
              ),
              /* _button(Icons.app_registration, "Preregistro", "preregistration",
                  context), */
              /* const Text(
                "o",
              ),
              _emailOption(),
              const SizedBox(
                height: 10,
              ), */
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                      //width: 150,
                      height: 45,
                      child: WhatsappHelpBtn(context: context)),
                  const SizedBox(
                    height: 20,
                  )
                ],
              )
            ]));
  }

  _emailOption() {
    return FormBuilder(
        key: _loginFormKey,
        child: Column(children: <Widget>[
          CustomTextFormField(
            label: 'Correo',
            name: 'email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'password',
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                  icon: Icon(_iconVisible, color: Colors.grey[400], size: 20),
                  onPressed: () {
                    _toggleObscureText();
                  }),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
            ),
            obscureText: _obscureText,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6)
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          /*Align(
              alignment: Alignment.centerRight,
              child: Material(
                child: InkWell(
                    onTap: () {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestPasswordScreen()));*/
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: primaryColor, fontSize: 14),
                    )),
              )),
          const SizedBox(
            height: 15,
          ),*/
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: ElevatedButton(
              onPressed: _loginWithEmail,
              child: const Text("Entrar"),
            ),
          ),
        ]));
  }

  _button(icon, title, key, context) => Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
          icon: Icon(
            icon,
          ),
          label: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              "  " + title,
            ),
          ),
          onPressed: () {
            switch (key) {
              case "camera":
                _loginWithCamera(context);
                break;
              case "qr":
                _loginQrFromFile(context);
                break;
            }
          }));

  showDialogPermissions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sin acceso a Cámara'),
            content: const Text(
                'Permitir el acceso de la Cámara para poder escanear'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () async {
                  await openAppSettings();
                },
              )
            ],
          );
        });
  }
}
