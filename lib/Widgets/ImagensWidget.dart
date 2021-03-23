import 'package:flutter/material.dart';

import 'ImageSourceSheet.dart';

class ImagensWidget extends FormField<List> {

  ImagensWidget({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List initialValue,
    bool autoValidate = false,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autoValidate,
    builder: (state){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 124,
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
              state.value.map<Widget>( (imagem) {
                //retornar imagem
                return Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    child: imagem is String
                        ? Image.network(imagem, fit: BoxFit.cover,)
                        : Image.file(imagem, fit: BoxFit.cover,),
                    onLongPress: (){
                      //remover imagem da lista
                      if(imagem != null){
                        state.value.remove(imagem);
                        state.didChange(state.value);
                      }
                      //verificar se tem erro no  minuto 9:50 aula 248
                    },
                  ),
                );
              }).toList()..add(
                GestureDetector(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(Icons.camera_enhance, color: Colors.white,),
                    color: Colors.white.withAlpha(50),
                  ),
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ImageSourceSheet(
                          onImagemSelecionada: (imagem){
                            if(imagem != null){
                              state.value.add(imagem);
                              state.didChange(state.value);
                            }
                            Navigator.of(context).pop();
                          },
                        )
                    );

                  },
                )
              ),
            ),
          ),
          state.hasError ? Text(
            state.errorText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12
            ),
          )
              : Container()
        ],
      );
    }
  );

}