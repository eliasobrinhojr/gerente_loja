import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/notification_bloc.dart';
import 'package:gerente_loja/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final NotificationBloc _notificationBloc = NotificationBloc();

  MyApp() {
    _notificationBloc.initOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Flutter demo",
        theme: ThemeData(primaryColor: Colors.pinkAccent),
        debugShowCheckedModeBanner: false,
        home: LoginScreen()
    );
  }
}
