import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Parking App'),
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
  double lat = 27.96144122859129;
  double lng = 76.40153791225701;

  double newLatitude = 0.0;
  double newLongitude = 0.0;

  MapController controller = MapController();

  List<Marker> listOfMarkers = [
    Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(27.96144122859129, 76.40153791225701),
        builder: (context) => Container(
              child: IconButton(
                  icon: Icon(Icons.accessibility),
                  onPressed: () {
                    print('Marker tapped!');
                  }),
            )),
  ];
  Widget myInputWidget(String input) {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        initialValue: input == "Latitude" ? lat.toString() : lng.toString(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: input,
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
        onChanged: (value) {
          if (input == "Latitude") {
            newLatitude = double.tryParse(value);
            print(lat);
          } else {
            newLongitude = double.tryParse(value);
            print(lng);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                child: FlutterMap(
                    mapController: controller,
                    options:
                        MapOptions(minZoom: 10.0, center: LatLng(lat, lng)),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(markers: listOfMarkers)
                    ]),
              ),
            ),
            myInputWidget("Latitude"),
            myInputWidget("Longitude"),
            ElevatedButton(
                onPressed: () {
                  listOfMarkers.add(
                    Marker(
                        width: 45.0,
                        height: 45.0,
                        point: LatLng(newLatitude, newLongitude),
                        builder: (context) => Container(
                              child: IconButton(
                                  icon: Icon(Icons.accessibility),
                                  onPressed: () {
                                    print('Marker tapped!');
                                  }),
                            )),
                  );
                  controller.move(LatLng(newLatitude, newLongitude), 2.0);
                },
                child: Text("Move To Position"))
          ],
        ));
  }
}
