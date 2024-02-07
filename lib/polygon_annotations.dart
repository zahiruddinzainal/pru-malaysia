import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class DrawPolygronByDistrictScreen extends ExamplePage {
  DrawPolygronByDistrictScreen()
      : super(const Icon(Icons.map), 'Polygon Annotations');

  @override
  Widget build(BuildContext context) {
    return const PolygonAnnotationPageBody();
  }
}

class PolygonAnnotationPageBody extends StatefulWidget {
  const PolygonAnnotationPageBody();

  @override
  State<StatefulWidget> createState() => PolygonAnnotationPageBodyState();
}

class AnnotationClickListener extends OnPolygonAnnotationClickListener {
  @override
  void onPolygonAnnotationClick(PolygonAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class StateCoordinate {
  final double latitude;
  final double longitude;
  final double zoom;
  final double pitch;
  final String name;

  StateCoordinate(
      this.latitude, this.longitude, this.zoom, this.pitch, this.name);
}

class PolygonAnnotationPageBodyState extends State<PolygonAnnotationPageBody> {
  MapboxMap? mapboxMap;
  PolygonAnnotation? polygonAnnotation;
  PolygonAnnotationManager? polygonAnnotationManager;
  int styleIndex = 1;
  Set<String> renderedStates = {}; // Keep track of rendered states
  PolygonAnnotationPageBodyState();
  final ScrollController _scrollController = ScrollController();

  List<StateCoordinate> malaysiaStateCoordinates = [
    StateCoordinate(6.492368076708255, 100.24446942388748, 8, 50, 'PERLIS'),
    StateCoordinate(5.92689347153252, 100.51924296592466, 7, 20, 'KEDAH'),
    StateCoordinate(
        5.343551053918363, 100.2488865879807, 8, 50, 'PULAU PINANG'),
    StateCoordinate(4.469098953433944, 101.10285256201672, 7, 10, 'PERAK'),
    StateCoordinate(6.1011678526507565, 102.27227067964363, 7, 10, 'KELANTAN'),
    StateCoordinate(
        4.8850142299461625, 103.16105924934261, 7, 20, 'TERENGGANU'),
    StateCoordinate(3.647948108138217, 102.68495875805738, 6, 10, 'PAHANG'),
    StateCoordinate(3.034302994527381, 101.49112172847904, 7, 0, 'SELANGOR'),
    StateCoordinate(
        2.812027336183091, 102.27126108211849, 8, 50, 'NEGERI SEMBILAN'),
    StateCoordinate(2.2851833491551425, 102.32079338607151, 8, 50, 'MELAKA'),
    StateCoordinate(2.002860615591771, 103.4646710204857, 8, 50, 'JOHOR'),
    StateCoordinate(2.716980757195149, 112.82974618957734, 5, 20, 'SARAWAK'),
    StateCoordinate(5.767418023387823, 116.959038563929, 4, 00, 'SABAH'),
    StateCoordinate(
        3.1757995884491126, 101.68222189313977, 8, 0, 'KUALA LUMPUR'),
    StateCoordinate(5.367923820008349, 115.22974131064973, 8, 0, 'LABUAN'),
    StateCoordinate(2.9194747991342758, 101.68947221559338, 8, 0, 'PUTRAJAYA'),
  ];

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createPolygonAnnotationManager().then((value) {
      polygonAnnotationManager = value;
    });
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.logo.updateSettings(LogoSettings(marginLeft: -900));
    mapboxMap.attribution.updateSettings(AttributionSettings(marginLeft: -900));
    mapboxMap.style.setProjection('globe');
  }

  _flyToStateCenter(int stateIndex) {
    if (mapboxMap != null &&
        stateIndex >= 0 &&
        stateIndex < malaysiaStateCoordinates.length) {
      StateCoordinate stateCoordinate = malaysiaStateCoordinates[stateIndex];
      mapboxMap?.easeTo(
          CameraOptions(
              center: Point(
                  coordinates: Position(
                stateCoordinate.longitude,
                stateCoordinate.latitude,
              )).toJson(),
              zoom: stateCoordinate.zoom,
              bearing: 0,
              pitch: stateCoordinate.pitch),
          MapAnimationOptions(duration: 4000, startDelay: 0));
      if (!renderedStates.contains(stateCoordinate.name)) {
        createPolygonFromGeoJSON(stateCoordinate.name);
        renderedStates.add(stateCoordinate.name);
      }
    }
  }

  Future<void> createPolygonFromGeoJSON(state) async {
    final String jsonContent =
        await rootBundle.loadString('assets/daerah.json');
    final jsonBody = json.decode(jsonContent);
    final List<dynamic> features = jsonBody['features'];

    for (int index = 0; index < features.length; index++) {
      final feature = features[index];
      final properties = feature['properties'];
      if (properties['nam'] == state) {
        final coordinatesList = feature['geometry']['coordinates'][0][0];

        final List<Position> districtCoordinates = [];

        for (var coordinate in coordinatesList) {
          districtCoordinates.add(Position(coordinate[0], coordinate[1]));
        }

        int fillColor;
        if (index % 2 == 0) {
          // Even indices: Blue color
          fillColor = const Color.fromARGB(255, 33, 150, 243).value;
        } else {
          // Odd indices: Red color
          fillColor = const Color.fromARGB(255, 244, 67, 54).value;
        }

        polygonAnnotationManager
            ?.create(PolygonAnnotationOptions(
              geometry: Polygon(coordinates: [districtCoordinates]).toJson(),
              fillColor: fillColor,
              fillOutlineColor: const Color.fromARGB(255, 0, 0, 0).value,
              fillSortKey: 0,
              fillOpacity: 0.2,
            ))
            .then((value) => polygonAnnotation = value);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
        key: ValueKey("mapWidget"),
        resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(3.5776782352456378, 103.87938132304197),
          ).toJson(),
          zoom: 3.0,
        ),
        styleUri: MapboxStyles.PILIHANRAYA,
        onMapCreated: _onMapCreated);

    return Scaffold(
      body: Stack(
        children: [
          mapWidget,
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 16,
                itemBuilder: (context, index) {
                  int imageIndex = index + 1;
                  String imagePath = 'assets/Flags/my$imageIndex.png';

                  return Container(
                    color: const Color.fromARGB(0, 244, 67, 54),
                    width: 310, // Adjust the width as needed
                    margin: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () {
                        _flyToStateCenter(index);
                      },
                      child: Card(
                        elevation: 0,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Image.asset(
                                imagePath,
                                width: 70,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Winner - PN',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('PN: 33 Kerusi'),
                                    Text('PH-BN: 0 Kerusi'),
                                    Text('Percentage Vote: 90%'),
                                    Text('Majority: 183902'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
