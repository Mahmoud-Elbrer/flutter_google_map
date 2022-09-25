// todo : first enable place api in google play console

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http ; 

class GooglePlaceApi extends StatefulWidget {
  const GooglePlaceApi({Key? key}) : super(key: key);

  @override
  State<GooglePlaceApi> createState() => _GooglePlaceApiState();
}

class _GooglePlaceApiState extends State<GooglePlaceApi> {
  TextEditingController _textContainer = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '1234';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textContainer.addListener(() {
      onChange();
    });
  }

  onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }
    getSuggestions(_textContainer.text);
  }

  getSuggestions(String place) async {
    String kPLACES_API_KEY = "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow";
    String type = '(regions)';

    try{
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$place&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
      print("request");
      print(request);
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      print('mydata');
      print(data);
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    }catch(e){
     // toastMessage('success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Place Api')),
      body: Column(
        children: [
          TextFormField(
            controller: _textContainer,
            decoration: const InputDecoration(hintText: 'Search Place '),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {

                  },
                  child: ListTile(
                    title: Text(_placeList[index]["description"]),
                  ),
                );
              },
            ),
          ) , 
        ],
      ),
    );
  }
}
