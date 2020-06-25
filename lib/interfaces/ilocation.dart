import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tt/interfaces/detail.dart';
import 'package:tt/interfaces/information.dart';
import 'package:tt/main.dart';
import 'package:tt/todo.dart';
import 'qlocation.dart';

class LocationInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LocationInfoState();
}

class LocationInfoState extends State<LocationInfo> {
  double lat = 0.0;
  double lng = 0.0;
  void initPlatformS() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });

    if (lat != null && lng != null) {
      Todo todo = new Todo("Konumunuz", "", lat, lng);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(),
              // Pass the arguments as part of the RouteSettings. The
              // DetailScreen reads the arguments from these settings.
              settings: RouteSettings(
                arguments: todo,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    initPlatformS();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Konumunuzu Bulun",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'poppinsLight',
                    color: Colors.white))
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 185, 15, 0.9),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 150.0, 0.0),
            child: Image.asset("assets/images/smokeUpset.jpg"),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 20, 20),
              child: Text('Üzgününüz',
              style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'poppins',
                  color: Color.fromRGBO(234, 171, 118, 0.9),
                  fontWeight: FontWeight.w900,
                ),)),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 20.0, 20),
            child: Text("Konumunuzu bulamadık",
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'poppins',
                  color: Color.fromRGBO(71, 72, 76, 0.9),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
            child: new GestureDetector(
              child: new OutlineButton(
                  disabledBorderColor: Color.fromRGBO(234, 171, 118, 0.9),
                  child: Text("Konum Seç",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'poppins',
                          color: Color.fromRGBO(234, 171, 118, 0.9))),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/queryLocation"),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            ),
          )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
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
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Anasayfa'),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_emoticon),
              title: Text('Bilgilendirme'),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Information()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
