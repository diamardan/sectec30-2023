// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/utils/alert_dialog.dart';

class WhatsappHelpBtn extends StatefulWidget {
  const WhatsappHelpBtn({
    Key? key,
    required this.context,
  }) : super(key: key);
  final BuildContext context;
  _WhatsappHelpBtnState createState() => _WhatsappHelpBtnState();
}

class _WhatsappHelpBtnState extends State<WhatsappHelpBtn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.6,
      child: ElevatedButton(
        onPressed: () {
          enviarWhatsapp(context);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: softGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Ayuda',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            )
          ],
        ),
      ),
    );
  }

  enviarWhatsapp(BuildContext context) async {
    final Uri url =
        Uri.parse("whatsapp://send?phone=$whatsappNumber&text=$whatsappText, ");
    try {
      launchUrl(url);
    } catch (e) {
      await NotifyUI.showBasic(context, 'Aviso', 'WhatsApp no instalado');
    }
  }
}
