import 'dart:typed_data';

import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/features/identity_card/providers/identity_card_provider.dart';
import 'package:sectec30/features/identity_card/screens/render_crendetial_screen.dart';
import 'package:sectec30/features/profile/data/models/register.dart';
import 'package:sectec30/features/profile/providers/profile_provider.dart';
import 'package:sectec30/utils/cache_image_network.dart';
import 'package:sectec30/utils/widget_to_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart';

class IdentityCardScreen extends ConsumerStatefulWidget {
  const IdentityCardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      IdentityCardScreenState();
}

class IdentityCardScreenState extends ConsumerState<IdentityCardScreen> {
  late GlobalKey key1;
  late GlobalKey key2;
  late Uint8List bytes1;
  late Uint8List bytes2;
  late String savePDFFolderName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final register = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Credencial inteligente"),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: ref.watch(visibleButtonProvider),
        child: FloatingActionButton.extended(
          label: const Text("Descargar"),
          icon: const Icon(Icons.download),
          onPressed: () async {
            /*  makePdf(register); */
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _anversoCredencial(register),
              WidgetToImage(builder: (key) {
                key2 = key;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Container(
                    height: 215,
                    width: 350,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          image: AssetImage(
                              'assets/images/credencial/reverso2023.jpg')),
                    ),
                    child: Column(
                      children: <Widget>[
                        _cintillaTurno(register),
                        _midReverso(register),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _midReverso(Registration register) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  margin: const EdgeInsets.fromLTRB(92, 15, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.transparent, width: 1),
                  ),
                  child: Text(
                    register.grade!.name!, // TODO - pendiente grado
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  width: 25,
                  margin: const EdgeInsets.fromLTRB(92, 12, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.transparent, width: 1),
                  ),
                  child: Text(
                    register.group!.name!, // TODO  - PENDIENTE
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 20, 0, 0),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 1),
              ),
              child: Container(
                child: buildCacheNetworkImage(
                  width: 110,
                  height: 110,
                  url:
                      "https://drive.google.com/uc?id=${register.studentQrPath}",
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 30,
          width: 125,
          margin: const EdgeInsets.fromLTRB(15, 5, 0, 0),
          child: Container(
            child: buildCacheNetworkImage(
              width: 110,
              height: 110,
              url:
                  "https://drive.google.com/uc?id=${register.studentSignaturePath}",
            ),
          ),
        ),
      ],
    );
  }

  Widget _anversoCredencial(Registration register) {
    return WidgetToImage(builder: (key) {
      this.key1 = key;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 10,
        child: Container(
          height: 220,
          width: 360,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            image: const DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/credencial/anverso2023.jpg'),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 42),
                  _espacioFoto(register),
                  _espacioFooter(register),
                ],
              ),
              Container(
                height: 210,
                width: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 1),
                ),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    '${register.career!.name}', // TODO - FALTA CAMBIAR LA CARRERA
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 8,
                      fontFamily: 'montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _espacioFooter(Registration register) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      width: 145,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            width: 102,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 35,
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: buildCacheNetworkImage(
                    url:
                        "https://drive.google.com/uc?id=${register.studentQrPath}",
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Text(
                        '${register.idbio}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                )
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 130,
                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                      child: FittedBox(
                        child: Text(
                          register.registrationNumber ?? '',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    // TODO - VALIDAR FORMATO CODIGO DE BARRAS
                  ],
                ), */
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _espacioFoto(Registration register) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 2,
          width: 5,
        ),
        Container(
          width: 110,
          height: 110,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(10), // Opcional: para bordes redondeados
            child: buildCacheNetworkImage(
              width: 110,
              height: 110,
              url:
                  "https://drive.google.com/uc?id=${register.studentPhotoPath}",
            ),
          ),
          decoration: BoxDecoration(
            // Configura el BoxFit aquí
            image: DecorationImage(
              image: NetworkImage(
                  "https://drive.google.com/uc?id=${register.studentPhotoPath}"),
              fit: BoxFit
                  .cover, // Ajusta el modo de ajuste según tus necesidades
            ),
          ),
        ),
        Container(
          height: 95,
          width: 170,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          margin: const EdgeInsets.fromLTRB(5, 19, 0, 0),
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                child: Text(
                  '${register.surnames}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  '${register.names}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              FittedBox(
                child: Text(
                  '${register.curp}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _cintillaTurno(Registration register) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.fromLTRB(70, 14, 0, 0),
          height: 30,
          width: 200,
          child: Text(
            register.turn!.name!, // TODO - TURNO
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          height: 30,
          width: 130,
          child: Text(
            register.fecha!,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _espacioQR(Registration register) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          //color: Colors.amber,
        ),
        Container(
          width: 150,
          height: 150,
          //color: Colors.redAccent,
          child: const Column(
            children: [
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _firmaAlumno(Registration register) {
    //var fecha_emision = fecha.split(" ")[0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          //color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                register.fecha!,
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fotoReverso() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Container()],
    );
  }

  Widget buildImage(Uint8List bytes) =>
      bytes != null ? Image.memory(bytes) : Container();

  void _showSnackbar(String content) {
    final snackBar = SnackBar(content: (Text(content)));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> makePdf(Registration register) async {
    final pdf = pw.Document();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: <pw.Widget>[
            pw.Image(
              pw.MemoryImage(
                bytes1,
              ),
              height: 300,
            ),
            pw.SizedBox(width: 10),
            pw.Image(
              pw.MemoryImage(
                bytes2,
              ),
              height: 300,
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
    print("hola");
    _showSnackbar("El PDF está en su carpeta de Descargas");
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
