import 'package:sectec30/config/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  String _version = '1.0.0';

  Future<void> _getSystemDevice() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void initState() {
    _getSystemDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Acerca'),
        ),
        body: Stack(children: [
          const Positioned.fill(
            //
            child: Image(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                appName,
                style: TextStyle(
                    fontSize: 30,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Versión $_version',
                style: TextStyle(fontSize: 14, color: black21),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(child: Image.asset('assets/images/icon.png', height: 80)),
              const SizedBox(
                height: 30,
              ),
              const Text(
                '©2022-2023 Datamex',
                style: TextStyle(fontSize: 14, color: black21),
              ),
            ],
          )
        ]));
  }
}
