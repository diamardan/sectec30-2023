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
          width: 342,
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
          ]));
    });
  }

  Widget credentialBack(Registration registration) {
    return WidgetToImage(builder: (key) {
      this.key2 = key;

      return Container(
        width: 342,
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
          _stripeBack(registration),
          _contentBack(registration),
        ]),
      );
    });
  }

  Widget _frontDataCredentialContainer(Registration registration) {
    return Container(
      width: 340,
      height: 218,
      color: const Color.fromARGB(43, 255, 205, 210),
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          _studentPersonalData(registration),
          /* _frontCredentialFooter(registration), */
        ],
      ),
    );
  }

  Widget _studentPersonalData(Registration registration) {
    return Container(
      color: const Color.fromARGB(0, 76, 175, 79),
      width: 342,
      height: 160,
      child: Row(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 10, 8, 4),
              child: buildCacheNetworkImage(
                  width: 70,
                  height: 80,
                  url:
                      "https://drive.google.com/uc?id=${registration.studentPhotoPath}"),
            ),
            FittedBox(
                child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                registration.idbio!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            )),
            SizedBox(
              height: 33,
              child: buildCacheNetworkImage(
                  width: 30,
                  height: 30,
                  url:
                      "https://drive.google.com/uc?id=${registration.studentQrPath}"),
            ),
            Container(
              width: 80,
              child: FittedBox(
                  child: Text(
                registration.curp!,
                style: const TextStyle(fontWeight: FontWeight.w900),
              )),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          color: Colors.transparent,
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 90,
              ),
              FittedBox(
                child: Text(
                  '${registration.names!} ${registration.surnames!}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, top: 10),
                child: SizedBox(
                  height: 33,
                  width: 180,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: buildCacheNetworkImage(
                            width: 70,
                            height: 30,
                            url:
                                "https://drive.google.com/uc?id=${registration.studentSignaturePath}"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _stripeBack(Registration registration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 80,
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
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      '${registration.fecha!}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
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
          width: 110,
          height: 130,
          color: Color.fromARGB(0, 48, 255, 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 90,
                child: Column(children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Container(
                    width: 50,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 9.0, left: 10, bottom: 4),
                      child: FittedBox(
                        child: Text(
                          registration.turn!.name!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    registration.grade!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
        const SizedBox(
          width: 80,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(2, 60, 2, 10),
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
