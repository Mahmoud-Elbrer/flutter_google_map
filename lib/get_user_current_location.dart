import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocation extends StatefulWidget {
  const GetUserCurrentLocation({Key? key}) : super(key: key);

  @override
  State<GetUserCurrentLocation> createState() => _GetUserCurrentLocationState();
}

class _GetUserCurrentLocationState extends State<GetUserCurrentLocation> {
  var currentLocation = ' -- ';

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(24.228348, 55.778224),
    zoom: 14.4746,
  );

  final List<Marker> _marker = [];
  final List<Marker> _list = [
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(24.228348, 55.778224),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
  ];
  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
    //loadData() ;
  }

  loadData() {
    getCurrentLocation().then((value) async {
      currentLocation = "latitude : " +
          value.latitude.toString() +
          " longitude : " +
          value.longitude.toString();

      _marker.add(
        Marker(
          markerId: MarkerId("2"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: 'My current location'),
        ),
      );

      CameraPosition _cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14.4746,
      );

      GoogleMapController googleMapController = await _controller.future;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14,
        ),
      ));
      setState(() {});
    });
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error : " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            // mapType  : MapType.satellite ,
            markers: Set<Marker>.of(_marker),
            //compassEnabled: true,
            // myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Text(currentLocation, style: TextStyle(fontSize: 30)),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text('Get My Current Location'),
                onPressed: loadData(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
