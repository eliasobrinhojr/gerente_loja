import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/tabs/orders_tab.dart';
import 'package:gerente_loja/tabs/products_tab.dart';
import 'package:gerente_loja/tabs/users_tab.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
    setUpNotification();
  }

  void setUpNotification() {
    _firebaseMessaging = FirebaseMessaging();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Clientes")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Produtos")),
            ]),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[UsersTab(), OrdersTab(), ProductsTab()],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
        break;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluidos Abaixo",
                labelStyle: TextStyle(fontSize: 14.0),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluidos Acima",
                labelStyle: TextStyle(fontSize: 14.0),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
        break;
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
                context: context, builder: (context) => EditCategoryDialog());
          },
        );
        break;
      default:
        return null;
    }
  }

  updateToken(token) async {
    DocumentSnapshot docUser = await Firestore.instance
        .collection("users")
        .document("hNthpVRUHGVKD7Z4Jap4rcMhFB73")
        .get();
    docUser.data["token"] = token;
    await docUser.reference.updateData(docUser.data);
  }


  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) {
     // if (isLoggedIn()) updateToken(token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);

    });
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.Max, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
