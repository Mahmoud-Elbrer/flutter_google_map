import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerScreen extends StatefulWidget {
  const CustomMarkerScreen({Key? key}) : super(key: key);

  @override
  State<CustomMarkerScreen> createState() => _CustomMarkerScreenState();
}

class _CustomMarkerScreenState extends State<CustomMarkerScreen> {
  Completer<GoogleMapController> _controller = Completer();

  List<String> images = [
    'assets/baby.png',
    'assets/car.png',
    'assets/car_service.png',
    'assets/healthcare.png'
  ];

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(24.197178, 55.659672),
    zoom: 16.4746,
  );

  final List<Marker> _markers = [];
  final List<LatLng> _latLng = const [
    LatLng(24.197178, 55.659672),
    LatLng(24.197892, 55.661228),
    LatLng(24.198411, 55.659082),
    LatLng(24.228267, 55.783213)
  ];

 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAsset(images[i], 50);
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latLng[i],
          infoWindow: InfoWindow(title: 'index : '.toString() + i.toString()),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
      setState(() {});
    }
    
  }

   Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        mapType: MapType.normal,
        // mapType  : MapType.satellite ,
        markers: Set<Marker>.of(_markers),
        compassEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
