import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/services/notification_service.dart';
import 'package:gerente_loja/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  NotificationService _notificationService;

  UserBloc _userBloc = new UserBloc();

  OrderTile(this.order);

  final states = [
    "Fila",
    "Em preparação",
    "Em transporte",
    "Aguardando Entrega",
    "Entregue"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] != 4,
          title: Text(
            "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - "
            "${states[order.data["status"]]}",
            style: TextStyle(
                color: order.data["status"] != 4
                    ? Colors.grey[850]
                    : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 0.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data["products"].map<Widget>((p) {
                      return ListTile(
                        title:
                            Text(p["product"]["title"] + " " + "${p["size"]}"),
                        subtitle: Text(p["category"] + "/" + p["pid"]),
                        trailing: Text(
                          "x${p["quantity"].toString()}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: order.data["status"] == 0
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("Confirmar"),
                                      content: new Text(
                                          "Realmente excluir pedido ?"),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text("Cancelar"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text("Sim"),
                                          onPressed: () async {
                                            Firestore.instance
                                                .collection("users")
                                                .document(order["clientId"])
                                                .collection("orders")
                                                .document(order.documentID)
                                                .delete();
                                            Navigator.of(context).pop();
                                            await order.reference.delete();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null,
                        textColor: Colors.red,
                        child: Text("Excluir"),
                      ),
                      FlatButton(
                        onPressed: order.data["status"] > 0
                            ? () {
                                order.reference.updateData(
                                    {"status": order.data["status"] - 1});
                              }
                            : null,
                        textColor: Colors.grey[850],
                        child: Text("Regredir"),
                      ),
                      FlatButton(
                        onPressed: order.data["status"] < 4
                            ? () {
                                order.reference.updateData(
                                    {"status": order.data["status"] + 1});

                                _notificationService = new NotificationService(_userBloc.getUser(this.order.data['clientId'])["token"]);
                                print(order.data["status"]);
                                if(order.data["status"] == 2) _notificationService.sendRequest("Seu pedido saiu para entrega !", "Opa :D");
                              }
                            : null,
                        textColor: Colors.green,
                        child: Text("Avançar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
