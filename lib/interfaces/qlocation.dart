import 'dart:async';

import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tt/main.dart';
import 'detail.dart';
import 'package:tt/todo.dart';

const kGoogleApiKey = "own api key";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

main() {
  runApp(RoutesWidget());
}

final customTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  accentColor: Colors.redAccent,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.00)),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 12.50,
      horizontal: 10.00,
    ),
  ),
);

class RoutesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "My App",
        theme: customTheme,
        routes: {
          "/": (_) => MyApp(),
          "/search": (_) => CustomSearchScaffold(),
        },
      );
}

class QueryLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QueryState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class QueryState extends State<QueryLocation> {
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop())
            : null,
        title: Text("Geri",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
                fontFamily: 'poppinsLight',
                color: Color.fromRGBO(255, 255, 255, 0.9))),
        backgroundColor: Color.fromRGBO(255, 185, 15, 0.9),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDropdownMenu(),
          SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                  child: FlatButton(
                      onPressed: _handlePressButton,
                      color: Color.fromRGBO(234, 171, 118, 0.9),
                      child: Text("Arama Yap",
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)))))
                          ,
          /*
          RaisedButton(
            child: Text("Custom"),
            onPressed: () {
              Navigator.of(context).pushNamed("/search");
            },
          ),*/
        ],
      )),
    );
  }

  Widget _buildDropdownMenu() => Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.7)),
      child: new DropdownButton(
        style: TextStyle(color: Color.fromRGBO(248, 166, 93, 0.9)),
        iconEnabledColor: Color.fromRGBO(248, 166, 93, 0.9),
        value: _mode,
        items: <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            child: Text("Bu pencere üzerinden ara"),
            value: Mode.overlay,
          ),
          DropdownMenuItem<Mode>(
            child: Text("Tam ekran üzerinden ara"),
            value: Mode.fullscreen,
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m;
          });
        },
      ));

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "tr",
      components: [Component(Component.country, "tr")],
    );

    displayPrediction(p, homeScaffoldKey.currentState,context);
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold, context) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    //scaffold.showSnackBar(
    //  SnackBar(content: Text("${p.description} - Yönlendiriliyorsunuz")),
    // );
     Todo todo = new Todo(p.description,"", lat,lng);

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

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "tr",
          components: [Component(Component.country, "tr")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState,context);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
