import 'dart:io';
import 'dart:typed_data';

import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/features/identity_card/screens/render_crendetial_screen.dart';
import 'package:sectec30/features/profile/data/models/register.dart';
import 'package:sectec30/features/profile/providers/profile_provider.dart';
import 'package:sectec30/utils/cache_image_network.dart';
import 'package:sectec30/utils/imageUtil.dart';
import 'package:sectec30/utils/widget_to_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import '../providers/identity_card_provider.dart';

class NewIdentityCardScreen extends ConsumerStatefulWidget {
  const NewIdentityCardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NewIdentityCardScreenState();
}

class NewIdentityCardScreenState extends ConsumerState<NewIdentityCardScreen> {
  late GlobalKey key1;
  late GlobalKey key2;
  late Uint8List bytes1;
  late Uint8List bytes2;
  late String savePDFFolderName;

  bool active = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getCardExpiration() async {}

  void _showSnackbar(String content) {
    final snackBar = SnackBar(content: (Text(content)));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final register = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Credencial Digital')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: credentialWrapper(register),
      ),
      floatingActionButton: Visibility(
        visible: ref.watch(visibleButtonProvider),
        child: FloatingActionButton.extended(
            backgroundColor: active ? primaryColor : Colors.grey,
            label: const Text("Descargar"),
            icon: const Icon(Icons.download),
            onPressed: active
                ? () async {
                    setState(() {
                      active = false;
                    });
                    _showSnackbar("Su descarga comenzará en breve");
                    final bytes1 = await ImageUtils.capture(key1);
                    final bytes2 = await ImageUtils.capture(key2);

                    setState(() {
                      this.bytes1 = bytes1;
                      this.bytes2 = bytes2;
                    });
                    makePdf(register);
                  }
                : () {}),
      ),
    );
  }

  Widget credentialWrapper(Registration registration) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        credentialFront(registration),
        const SizedBox(
          height: 20,
        ),
        credentialBack(registration),
      ],
    );
  }

  Widget credentialFront(Registration registration) {
    return WidgetToImage(builder: (key) {
      this.key1 = key;
      return Container(
          width: 340,
          height: 218,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
            image: const DecorationImage(
                image: AssetImage('assets/images/credencial/anverso.png'),
                fit: BoxFit.contain),
          ),
          child: Row(children: [
            _frontDataCredentialContainer(registration),
            _frontCareerContainer(registration),
          ]));
    });
  }

  Widget credentialBack(Registration registration) {
    return WidgetToImage(builder: (key) {
      this.key2 = key;

      return Container(
        width: 360,
        height: 218,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          image: const DecorationImage(
              image: AssetImage('assets/images/credencial/reverso.png'),
              fit: BoxFit.contain),
        ),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          _stripeBack(registration),
          _contentBack(registration),
        ]),
      );
    });
  }

  Widget _frontDataCredentialContainer(Registration registration) {
    return Container(
      width: 302,
      height: 218,
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          _studentPersonalData(registration),
          _frontCredentialFooter(registration),
        ],
      ),
    );
  }

  Widget _studentPersonalData(Registration registration) {
    return Container(
      color: const Color.fromARGB(0, 76, 175, 79),
      width: 302,
      height: 120,
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: buildCacheNetworkImage(
              width: 90,
              height: 100,
              url:
                  "https://drive.google.com/uc?id=${registration.studentPhotoPath}"),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 45,
              ),
              FittedBox(
                child: Text(
                  registration.names!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FittedBox(
                child: Text(registration.surnames!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    registration.curp!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _frontCredentialFooter(Registration registration) {
    return Container(
      width: 302,
      height: 55,
      color: Color.fromARGB(0, 244, 67, 54),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const SizedBox(
          width: 35,
        ),
        buildCacheNetworkImage(
            height: 50,
            width: 50,
            url:
                "https://drive.google.com/uc?id=${registration.studentQrPath}"),
        const SizedBox(
          width: 5,
        ),
        Text(
          registration.idbio!,
          style: const TextStyle(color: primaryColor),
        ),
        /* const SizedBox(
          width: 30,
        ), */
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 49,
                width: 170,
                child: registration.registrationNumber != ""
                    ? BarcodeWidget(
                        data: registration.registrationNumber!,
                        barcode: Barcode.code128())
                    : const SizedBox(),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _frontCareerContainer(Registration registration) {
    return Container(
      width: 30,
      height: 218,
      color: Colors.transparent,
      child: RotatedBox(
        quarterTurns: 1,
        child: FittedBox(
            child: Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Text(
            registration.career!.name!,
            style: TextStyle(color: Colors.white),
          ),
        )),
      ),
    );
  }

  Widget _stripeBack(Registration registration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: Color.fromARGB(0, 4, 85, 226)),
          height: 15,
          width: 200,
          child: Column(children: [
            SizedBox(
              width: 180,
              height: 15,
              child: Text(
                '               ${registration.turn!.name!}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        const SizedBox(
          width: 30,
        ),
        Column(
          children: [
            Container(
              width: 90,
              height: 45,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(0, 255, 68, 93)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  FittedBox(
                    child: Text(
                      '${registration.fecha!}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FittedBox(
                    child: Text(
                      int.parse(registration.grade!.name!) > 1
                          ? cardValidityOld
                          : cardValidityNew,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            /*  Container(
              width: 90,
              height: 20,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(0, 68, 137, 255)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ],
              ),
            ), */
          ],
        )
      ],
    );
  }

  Widget _contentBack(Registration registration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 120,
          color: Color.fromARGB(0, 48, 255, 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 90,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      registration.grade!.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    registration.group!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ]),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  buildCacheNetworkImage(
                      width: 40,
                      height: 50,
                      url:
                          "https://drive.google.com/uc?id=${registration.studentPhotoPath}"),
                  registration.studentSignaturePath != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildCacheNetworkImage(
                              height: 24,
                              url:
                                  "https://drive.google.com/uc?id=${registration.studentSignaturePath}"),
                        )
                      : const Placeholder(
                          color: Colors.black,
                          child: SizedBox(
                            width: 100,
                            height: 30,
                          ),
                        )
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(2, 15, 2, 10),
          width: 60,
          height: 60,
          color: Color.fromARGB(0, 255, 7, 193),
          child: buildCacheNetworkImage(
              url:
                  "https://drive.google.com/uc?id=${registration.studentQrPath}"),
        ),
      ],
    );
  }

  Future<void> makePdf(Registration register) async {
    final pdf = pw.Document();

    var status = await Permission.storage.status;
    if (status.isDenied) {
      print("sin permiso");
      await Permission.storage.request();
      setState(() {
        active = true;
      });
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: <pw.Widget>[
            pw.Image(
              pw.MemoryImage(
                bytes1,
              ),
              height: 150,
            ),
            pw.SizedBox(width: 10),
            pw.Image(
              pw.MemoryImage(
                bytes2,
              ),
              height: 150,
            ),
          ],
        ),
      ),
    );

    String tempPath = await getPublicExternalStorageDirectoryPath();

    String apellidos = register.surnames ?? "SIN APELLIDOS";
    String nombre = register.names ?? "SIN NOMBRE";
    var pdfName = "$apellidos $nombre.pdf";
    var filePath = '$tempPath/${pdfName.replaceAll(" ", "_")}';
    final file = File(filePath);

    print(filePath);
    await file.writeAsBytes(await pdf.save());
    _showSnackbar("El PDF está en su carpeta de Descargas");
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RenderCredentialScreen(
          pdfPath: filePath,
          pdfName: pdfName,
        ),
      ),
    );
  }

  Future<String> getPublicExternalStorageDirectoryPath() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      savePDFFolderName = 'Documentos';
    } else if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      savePDFFolderName = 'Descargas';
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
        savePDFFolderName = directory!.path;
      }
    }
    return directory!.path;
  }
}
