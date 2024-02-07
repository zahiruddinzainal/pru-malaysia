import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class FullMapPage extends ExamplePage {
  FullMapPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class StateCoordinate {
  final double latitude;
  final double longitude;

  StateCoordinate(this.latitude, this.longitude);
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  var isLight = true;
  final ScrollController _scrollController = ScrollController();

  List<StateCoordinate> malaysiaStateCoordinates = [
    StateCoordinate(6.492368076708255, 100.24446942388748), // Perlis
    StateCoordinate(5.92689347153252, 100.51924296592466), // Kedah
    StateCoordinate(5.343551053918363, 100.2488865879807), // Penang
    StateCoordinate(4.469098953433944, 101.10285256201672), // Perak
    StateCoordinate(6.1011678526507565, 102.27227067964363), // Kelantan
    StateCoordinate(4.8850142299461625, 103.16105924934261), // Terengganu
    StateCoordinate(3.647948108138217, 102.68495875805738), // Pahang
    StateCoordinate(3.034302994527381, 101.49112172847904), // Selangor
    StateCoordinate(2.812027336183091, 102.27126108211849), // Negeri Sembilan
    StateCoordinate(2.2851833491551425, 102.32079338607151), // Melaka
    StateCoordinate(2.002860615591771, 103.4646710204857), // Johor
    StateCoordinate(2.716980757195149, 112.82974618957734), // Sarawak
    StateCoordinate(5.767418023387823, 116.959038563929), // Sabah
    StateCoordinate(3.1757995884491126, 101.68222189313977), // Kuala Lumpur
    StateCoordinate(5.367923820008349, 115.22974131064973), // Labuan
    StateCoordinate(2.9194747991342758, 101.68947221559338), // Putrajaya
  ];

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.subscribe(_eventObserver, [
      MapEvents.STYLE_LOADED,
      MapEvents.MAP_LOADED,
      MapEvents.MAP_IDLE,
    ]);
  }

  _eventObserver(Event event) {
    print("Receive event, type: ${event.type}, data: ${event.data}");
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), begin: ${data.begin}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    print("MapIdleEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    print("MapLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    print("MapLoadingErrorEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    print(
        "RenderFrameStartedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    print(
        "RenderFrameFinishedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    print("SourceAddedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    print("SourceDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    print("SourceRemovedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    print("StyleDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    print("StyleImageMissingEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    print("StyleImageUnusedEventData: begin: ${data.begin}, end: ${data.end}");
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
              zoom: 8,
              bearing: 0,
              pitch: 10),
          MapAnimationOptions(duration: 2000, startDelay: 0));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapWidget(
              key: ValueKey("mapWidget"),
              resourceOptions:
                  ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: Position(13.926462948599607, 90.4460035041674),
                ).toJson(),
                zoom: 3.0,
              ),
              styleUri: MapboxStyles.MINERAL,
              textureView: true,
              onMapCreated: _onMapCreated,
              // ... (other listeners)
            ),
          ),
          Container(
            height: 150,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 16,
              itemBuilder: (context, index) {
                int imageIndex = index + 1;
                String imagePath = 'assets/Flags/my$imageIndex.png';

                return Container(
                  width: 300, // Adjust the width as needed
                  margin: EdgeInsets.all(8),

                  child: InkWell(
                    onTap: () {
                      print('Button $imageIndex pressed');
                      _flyToStateCenter(index);
                    },
                    child: Card(
                      elevation: 0,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Image.asset(
                              imagePath,
                              width: 70, // Adjust the width as needed
                            ),
                          ),
                          SizedBox(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('PN: 33 Kerusi'),
                                  Text('PH-BN: 0 Kerusi'),
                                  Text('Percentage Vote: 90%'),
                                  Text('Majority: 183902'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: double.infinity * 0.2,
                            width: 0.5,
                            child: Container(
                              color: Colors
                                  .grey, // Set the color of the vertical line
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
