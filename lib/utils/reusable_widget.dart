import 'package:flutter/material.dart';

class ReusableWidget {
  PreferredSizeWidget bottomAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[100],
          height: 1.0,
        ));
  }

  Widget customNotifIcon(
      {int count = 0,
      Color notifColor = Colors.grey,
      Color labelColor = Colors.pinkAccent,
      double notifSize = 24,
      double labelSize = 14,
      String position = 'right'}) {
    double? posLeft;
    double? posRight = 0;
    if (position == 'left') {
      posLeft = 0;
      posRight = null;
    }
    return Stack(
      children: <Widget>[
        Icon(Icons.notifications, color: notifColor, size: notifSize),
        Positioned(
          left: posLeft,
          right: posRight,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(labelSize),
            ),
            constraints: BoxConstraints(
              minWidth: labelSize,
              minHeight: labelSize,
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget divider1() {
    return Divider(height: 0, color: Colors.grey[400]);
  }

  // end dummy loading
}
