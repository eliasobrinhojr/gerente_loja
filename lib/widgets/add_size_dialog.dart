import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _controllerSize = TextEditingController();
  final _controllerPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controllerSize,
            ),
            SizedBox(height: 16.0,),
            TextField(
              controller: _controllerPrice,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("Add"),
                textColor: Colors.pinkAccent,
                onPressed: () {
                  Navigator.of(context).pop({"size": _controllerSize.text, "price": _controllerPrice.text});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
