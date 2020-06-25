import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt/interfaces/ilocation.dart';
import 'package:tt/main.dart';

class Information extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InformationState();
}

class InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bunları biliyor musunuz?",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'poppinsLight',
                    color: Colors.white))
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 185, 15, 0.9),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
          child: Image.asset('assets/images/banner3.png'),
        )]),
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
              title: Text('Alan Kontrolü'),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => LocationInfo()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
