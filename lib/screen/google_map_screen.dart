import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 0.5,
  );

  final Set<Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(const Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(37.773972, -122.431297),
      ));

      _markers.add(const Marker(
        markerId: MarkerId('id-2'),
        position: LatLng(37.773972, -120.431295),
      ));

      _markers.add(const Marker(
        markerId: MarkerId('id-3'),
        position: LatLng(37.773972, -102.431294),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Cheh'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: _initialCameraPosition,
          mapType: MapType.normal,
        ));
  }

// void setPermissions() async{
//   await Permission.locationWhenInUse.status;
// }
}
