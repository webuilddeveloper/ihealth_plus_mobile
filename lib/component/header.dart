import 'package:flutter/material.dart';

header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonLeft = true,
  bool isButtonRight = false,
  String imageRightButton = 'assets/images/task_list.png',
  required Function? rightButton,
  String menu = '',
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      titleSpacing: 5,
      automaticallyImplyLeading: false,
      title: Text(
        title != null ? title : '',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sarabun',
            color: Colors.white),
      ),
      leading: isButtonLeft
          ? InkWell(
              onTap: () => functionGoBack(),
              child: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 24,
                  )),
            )
          : null,
      actions: <Widget>[
        isButtonRight
            ? Container(
                child: Container(
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => rightButton!(),
                      child: Image.asset(
                        imageRightButton,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}
