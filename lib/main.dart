import 'package:flutter/material.dart';
import 'package:tt/interfaces/ilocation.dart';
import 'package:tt/interfaces/information.dart';
import 'interfaces/qlocation.dart';
import 'package:flutter/services.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(255, 185, 15, 0.9),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your applicatiowrn.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/queryLocation": (context) => QueryLocation()},
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedIndex = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop())
            : null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text("Temiz Hava",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'poppinsLight',
                        color: Colors.white)))
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 185, 15, 0.9),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
          child: Image.asset('assets/images/banner.png'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
          child: Image.asset('assets/images/banner2.png'),
        )
      ]),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.transparent,
          selectedItemBackgroundColor: Colors.green,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
          showSelectedItemShadow: false,
          barHeight: 70,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyApp()));
            }
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Information()));
            }
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LocationInfo()));
            }
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Anasayfa',
            selectedBackgroundColor: Colors.orange,
          ),
          FFNavigationBarItem(
            iconData: Icons.import_contacts,
            label: 'Bilgilendirme',
            selectedBackgroundColor: Colors.brown,
          ),
          FFNavigationBarItem(
              iconData: Icons.insert_emoticon,
              label: 'Alan kontrolü',
              selectedBackgroundColor: Colors.orangeAccent),
        ],
      ),
    );
  }
}
