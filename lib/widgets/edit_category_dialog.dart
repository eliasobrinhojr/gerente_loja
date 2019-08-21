import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/category_bloc.dart';

class EditCategoryDialog extends StatelessWidget {
  final CategoryBloc _categoryBloc;

  EditCategoryDialog({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category: category);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                child: CircleAvatar(),
              ),
              title: TextField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.data) return Container();

                      return FlatButton(
                        child: Text("Excluir"),
                        textColor: Colors.red,
                        onPressed: snapshot.data ? () {} : null,
                      );
                    }),
                FlatButton(
                  child: Text("Salvar"),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
