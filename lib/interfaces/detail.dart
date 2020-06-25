import 'package:flutter/material.dart';
import 'package:tt/interfaces/ilocation.dart';
import 'package:tt/interfaces/information.dart';
import 'package:tt/main.dart';
import 'package:tt/stationdata.dart';
import 'package:tt/todo.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class DetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DetailState();
}

class DetailState extends State<DetailScreen> {
  String result = "";
  int selectedIndx = 2;
  List<Todo> todos = [
    new Todo("Ankara-Sincan", "AS", 39.952967, 32.581857),
    new Todo("Ankara-Demetevler", "AD", 39.967569, 32.795430),
    new Todo("Ankara-Kecioren", "AK", 39.999230, 32.855519),
    new Todo("Ankara-Bahcelievler", "AB", 39.918165, 32.823097),
    //new Todo("Ankara-Sıhhiye", 39.927382, 32.859432),
    //new Todo("Ankara-Siteler", 39.964679, 32.906961),
    //new Todo("Ankara-Kayas", 39.925687, 32.926045)
  ];

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void loadAsset(String path) async {
    final myData = await rootBundle.loadString(path);
    //List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    List<StationData> csvTable = myData
        .split(';')
        .map((line) => StationData.fromLine(line))
        .where((element) => element.date == getNowDate())
        .toList();

    csvTable.forEach((element) {
      result = element.value;
    });
    setState(() {
      result = (double.parse(result) / 22.0).toStringAsFixed(2);
    });
  }

  String getNowDate() {
    String year = DateTime.now().year.toString();
    int monthS = DateTime.now().month.toInt();
    String month = "";
    int dayS = DateTime.now().day.toInt();
    String day = "";
    if (monthS < 10) {
      month = "0" + monthS.toString();
    } else {
      month = monthS.toString();
    }
    if (dayS < 10) {
      day = "0" + dayS.toString();
    } else {
      day = dayS.toString();
    }
    return day + "." + month + "." + year;
  }

  Todo _severalBetweenTwoPointsr(Todo chooseL) {
    double min = 99999;
    Todo enyakin;
    for (var i = 0; i < todos.length; i++) {
      var dx = todos[i].lat - chooseL.lat;
      var dy = todos[i].lot - chooseL.lot;
      if (math.sqrt(dx * dx + dy * dy) < min) {
        enyakin = todos[i];
        min = math.sqrt(dx * dx + dy * dy);
      }
    }
    return enyakin;
  }

  @override
  Widget build(BuildContext context) {
    final Todo chooseL = ModalRoute.of(context).settings.arguments;
    Todo enyakin = _severalBetweenTwoPointsr(chooseL);
    loadAsset("assets/res/" + enyakin.shortTitle + ".csv");

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop())
            : null,
        title: Text(chooseL.title,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'poppinsLight',
                color: Colors.white)),
        backgroundColor: Color.fromRGBO(255, 185, 15, 0.9),
      ),
      body: ListView(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
                  child: FlatButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/queryLocation"),
                    padding: EdgeInsets.all(0.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/images/changelocation.png',
                          width: 70,
                        )),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
                  child: SizedBox(
                    width: 272,
                    height: 80.0,
                    child: FlatButton(
                      color: Colors.grey,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        /*...*/
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.pin_drop),
                          Text('Size en yakın istasyon: ' + enyakin.title + '')
                        ],
                      ),
                    ),
                  ))
            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 0.0),
                  child:
                      Align(alignment: Alignment.topLeft, child: Text(result,
                      style:TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily:'poppinsLight',
                      ),
                      ))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 60.0, 0.0, 0.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("adet sigara içiyorsun!",
                    style: TextStyle(
                      fontSize: 26.0,
                       color: Colors.orangeAccent,
                      fontFamily: 'poppinsLight',
                    ),
                    textAlign: TextAlign.left))),
            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
                child:      Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: Image.asset('assets/images/banner2.png'),
        )
              )
            ]),
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
        selectedIndex: selectedIndx,
        onSelectTab: (index) {
          setState(() {
            selectedIndx = index;
            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
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
