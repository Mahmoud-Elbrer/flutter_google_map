import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';

class ConvertCoordinatesToAddress extends StatefulWidget {
  const ConvertCoordinatesToAddress({Key? key}) : super(key: key);

  @override
  State<ConvertCoordinatesToAddress> createState() =>
      _ConvertCoordinatesToAddressState();
}

class _ConvertCoordinatesToAddressState
    extends State<ConvertCoordinatesToAddress> {
  var textAdrees = 'no address';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(textAdrees),
              ElevatedButton(
                onPressed: () async {
                  final coordinates = Coordinates(24.228218, 55.7803784);
                  var address = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);

                  var result = address.first;

                  setState(() {
                    textAdrees = result.featureName.toString() +
                        result.addressLine.toString();
                  });

                  /// this is address
                  /// 'Address' - 14-D Street 24 - Al Murabaa - Abu Dhabi - United Arab Emirates
                },
                child: const Text('From a coordinates to query'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // From a query
                  final query = "1600 Amphiteatre Parkway, Mountain View";
                  var addresses =
                      await Geocoder.local.findAddressesFromQuery(query);
                  var first = addresses.first;

                  setState(() {
                    textAdrees = first.featureName.toString() +
                        first.addressLine.toString();
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
