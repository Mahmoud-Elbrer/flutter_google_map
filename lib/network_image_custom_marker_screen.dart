import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetworkImageCustomMarkerScreen extends StatefulWidget {
  const NetworkImageCustomMarkerScreen({Key? key}) : super(key: key);

  @override
  State<NetworkImageCustomMarkerScreen> createState() =>
      _NetworkImageCustomMarkerScreenState();
}

class _NetworkImageCustomMarkerScreenState
    extends State<NetworkImageCustomMarkerScreen> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Completer<GoogleMapController> _controller = Completer();

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
    for (int i = 0; i < _latLng.length; i++) {
      final Uint8List markerImage = await geNetworkImage(
          'https://cdn-icons-png.flaticon.com/512/5526/5526465.png', 50);

      final ui.Codec markerImageCodec = await instantiateImageCodec(
        markerImage.buffer.asUint8List(),
        targetHeight: 200,
        targetWidth: 200,
      );
      final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ImageByteFormat.png,
      );

      final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();

      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: _latLng[i],
            infoWindow: InfoWindow(title: 'index : '.toString() + i.toString()),
            icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
            anchor: Offset(.1, .1),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: 200,
                    width: 200,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Column(
                      children: [
                        Text('Hello'),
                      ],
                    ),
                  ),
                  _latLng[i]);
            }),
      );
      setState(() {});
    }
  }

  Future<Uint8List> geNetworkImage(String url, int width) async {
    final completer = Completer<ImageInfo>();
    var img = NetworkImage(url);
    img
        .resolve(const ImageConfiguration(size: Size.fromHeight(10)))
        .addListener(
            ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            mapType: MapType.normal,
            // mapType  : MapType.satellite ,
            markers: Set<Marker>.of(_markers),
            compassEnabled: true,
            myLocationEnabled: true,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              // _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 100,
            offset: 35,
          ),
        ],
      ),
    );
  }
}
