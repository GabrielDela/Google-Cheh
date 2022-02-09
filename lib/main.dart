import 'dart:async';
import 'dart:io';
import 'package:cheh/GlobalVars.dart';
import 'package:cheh/PointInfo.dart';
import 'package:cheh/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() async {
  LocationData? locationData;
  Location location = Location();

  WidgetsFlutterBinding.ensureInitialized();
  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  PermissionStatus _permissionGranted = await location.hasPermission();

  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  LocationData _locationData = await location.getLocation();
  print("Location = ${_locationData.latitude},${_locationData.longitude}");
  locationData = _locationData;

  // #######################################

  WidgetsFlutterBinding.ensureInitialized();
  Directory appPath = await getApplicationDocumentsDirectory();
  GlobalVars.store = await openStore(directory: "${appPath.path}/database/");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Cheh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<double>? _userAccelerometerValues;
  List<double>? _userAccelerometerValuesBefore = <double>[0, 0, 0];
  List<double>? _gyroscopeValues;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool show = false;

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
            (UserAccelerometerEvent event) {// AB = racine de  (x2)^2 - (x1)^2 + (y2)^2 - (y1)^2 + (z2)^2 - (z1)^2
          setState(() {
            double fallspeed = (((_userAccelerometerValuesBefore![0] * _userAccelerometerValuesBefore![0]) - (event.x * event.x)) + ((_userAccelerometerValuesBefore![1] * _userAccelerometerValuesBefore![1]) - (event.y * event.y)) + ((_userAccelerometerValuesBefore![2] * _userAccelerometerValuesBefore![2]) - (event.z * event.z)));
            print(fallspeed);
            if ((fallspeed >= 90 || fallspeed <= -90) && !show) {
              getLocation().then((value) {
                print("tomber");
                print("Location = ${value.latitude},${value.longitude}");
                show = false;
                // ENVOYER UN POINT
                DateTime now = DateTime.now();
                DateTime date = DateTime(now.year, now.month, now.day);
                DateTime hour = DateTime(now.hour, now.minute);
                var point = PointInfo(pX: value.latitude, pY: value.longitude, pDate: date.toString(), pHour: hour.toString());
                addMarker(point);
              });

              show = true;
            }
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
            _userAccelerometerValuesBefore = _userAccelerometerValues;
          });
        },
      ),
    );
  }

  Future<LocationData> getLocation() {
    return Location().getLocation();
  }

  // ##########################

  late GoogleMapController mapController;
  double x = 37.773972;
  double y = -122.431297;

  late List<PointInfo> markList = [];
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getAllPointInfo();
  }

  void getAllPointInfo() {
    List<PointInfo> pMarkList = [];
    if (GlobalVars.store != null) {
      Box box = GlobalVars.store!.box<PointInfo>();
      box.getAll().forEach((dynamic point) {
        pMarkList.add(point);
      });
      setState(() {
        markList = pMarkList;
      });
    }

    markList.forEach((element) {
      putMarker(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Cheh"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(x, y),
          zoom: 0,
        ),
        mapType: MapType.normal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        tooltip: "Historique des chutes",
        child: const Icon(Icons.history_outlined),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text("Historique des chutes"),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: markList.length == null ? 0 : markList.length,
                    itemBuilder: (BuildContext context, int index) {
                      PointInfo point = markList[index];
                      return ListTile(
                        title: Text("Coordonnées"),
                        subtitle: Text(point.x.toString() + " - " + point.y.toString()),
                        trailing: IconButton(
                          icon: const Icon(Icons.gps_fixed_outlined),
                          onPressed: () {
                            Navigator.pop(context);
                            moveTo(point.x, point.y);
                          },
                        ),
                        // leading: const IconButton(
                        //   icon: Icon(Icons.edit),
                        //   onPressed: null,
                        // ),
                      );
                    }
                  ),
              )
            ],
          );
        });
  }

  void addMarker(PointInfo pointInfo) async {
    Box box = GlobalVars.store!.box<PointInfo>();
    var point = PointInfo(
        pX: pointInfo.x,
        pY: pointInfo.y,
        pDate: pointInfo.date,
        pHour: pointInfo.hour);
    box.put(point);

    markList.add(point);

    putMarker(point);
  }

  void putMarker(PointInfo pointInfo) async {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(pointInfo.const_id!),
        position: LatLng(pointInfo.x!, pointInfo.y!),
      ));
    });
  }

  void moveTo(double? x, double? y){
    setState(() {
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(x!, y!), zoom: 17)
            //17 is new zoom level
          )
      );
    });
  }
}
