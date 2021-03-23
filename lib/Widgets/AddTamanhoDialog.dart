import 'package:flutter/material.dart';

class AddTamanhoDialog extends StatelessWidget {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
            ),
            Container(

              //alignment: Alignment.centerRight,
              child: FlatButton(

                child: Text("Add"),
                textColor: Colors.pinkAccent,
                onPressed: (){
                  if(_controller.text.isNotEmpty)
                    Navigator.of(context).pop(_controller.text);
                  else
                    Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
