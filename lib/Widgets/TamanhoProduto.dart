import 'package:flutter/material.dart';

import 'AddTamanhoDialog.dart';

class TamanhoProduto extends FormField<List> {

  TamanhoProduto(
  {
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (state){
      return SizedBox(
        height: 34,
        child: GridView(
          padding: EdgeInsets.symmetric(vertical: 4),
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            childAspectRatio: 0.5
          ),
          children: state.value.map(
              (tam){
                return GestureDetector(
                  onLongPress: (){
                    state.didChange(state.value..remove(tam));
                    //state.value.remove(tam);
                    //state.didChange(state.value);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        color: Colors.pinkAccent,
                        width: 3
                      )
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tam,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
          ).toList()..add(
              GestureDetector(
                onTap: () async{
                  //adicionar novo item
                  String tamanho = await showDialog(
                    context: context, builder: (context) => AddTamanhoDialog()
                  );
                  if(tamanho != null){
                    state.didChange(state.value..add(tamanho));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                          color: state.hasError ? Colors.red : Colors.pinkAccent,
                          width: 3
                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "+",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ),
        ),
      );
    }

  );

}