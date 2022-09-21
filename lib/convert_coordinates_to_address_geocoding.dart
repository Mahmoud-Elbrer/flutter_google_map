import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertCoordinatesToAddressGeocoding extends StatefulWidget {
  const ConvertCoordinatesToAddressGeocoding({Key? key}) : super(key: key);

  @override
  State<ConvertCoordinatesToAddressGeocoding> createState() =>
      _ConvertCoordinatesToAddressGeocodingState();
}

// it support all newer versions sdk.

class _ConvertCoordinatesToAddressGeocodingState
    extends State<ConvertCoordinatesToAddressGeocoding> {
  var textAdrees = 'no address';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Convert ..."),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(textAdrees),
              ElevatedButton(
                onPressed: () async {
                  List<Location> locations =
                      await locationFromAddress("Gronausestraat 710, Enschede");

                  setState(() {
                    textAdrees = locations.last.longitude.toString() +
                        locations.last.latitude.toString();
                  });

                  /// this is address
                  /// 'Address' - 14-D Street 24 - Al Murabaa - Abu Dhabi - United Arab Emirates
                },
                child: const Text('From a coordinates to query'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Placemark> placemarks =
                      await placemarkFromCoordinates(52.2165157, 6.9437819);

                  setState(() {
                    textAdrees = "Country :" +
                        placemarks.last.country.toString() +
                        " locality : " +
                        placemarks.reversed.last.locality.toString() +
                         " subAdministrativeArea : " +
                        placemarks.reversed.last.subAdministrativeArea.toString();
                  });
                },
                child: const Text('From a query to coordinates'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
