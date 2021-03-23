
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final Function(File) onImagemSelecionada;

  ImageSourceSheet({this.onImagemSelecionada});

  void imagemSelecionada(File imagem) async{

    if(imagem != null){
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: imagem.path,
        //ratioX: 1.0,
        //ratioY: 1.0
        aspectRatioPresets: [CropAspectRatioPreset.square]
      );
      onImagemSelecionada(croppedImage);
    }

  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: (){},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
                onPressed: () async{
                  File imagem = await ImagePicker.pickImage(source: ImageSource.camera);
                  imagemSelecionada(imagem);
                },
                child: Text("Câmera"),
            ),
            FlatButton(
              onPressed: () async{
                File imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
                imagemSelecionada(imagem);
              },
              child: Text("Galeria"),
            )
          ],
        )
    );
  }
}
