import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonDisplayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Display App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JsonDisplayPage(),
    );
  }
}

class JsonDisplayPage extends StatefulWidget {
  @override
  _JsonDisplayPageState createState() => _JsonDisplayPageState();
}

class _JsonDisplayPageState extends State<JsonDisplayPage> {
  List<dynamic> features = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String jsonContent =
        await rootBundle.loadString('assets/daerah.json');
    final jsonBody = json.decode(jsonContent);
    final List<dynamic> parsedFeatures = jsonBody['features'];
    setState(() {
      features = parsedFeatures;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter features by f_code
    List filteredFeatures = features
        .where((feature) => feature['properties']['nam'] == 'SELANGOR')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Display'),
      ),
      body: ListView.builder(
        itemCount: filteredFeatures.length,
        itemBuilder: (context, index) {
          final feature = filteredFeatures[index];
          final properties = feature['properties'];
          final coordinatesList = feature['geometry']['coordinates'][0];

          String featureInfo = '';
          for (var i = 0; i < coordinatesList.length; i++) {
            final coordinates = coordinatesList[i];
            featureInfo += 'Name: ${properties['nam']}\n' +
                'Laa: ${properties['laa']}\n' +
                'Coordinate ${i + 1}:\n' +
                '  Longitude: ${coordinates[0].toString()}\n' +
                '  Latitude: ${coordinates[1].toString()}\n\n';
          }

          return Container(
            padding: EdgeInsets.all(16),
            color: Colors
                .grey[200], // Add a background color for better visibility
            child: Text(
              featureInfo,
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
