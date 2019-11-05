import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/model.dart';
import 'package:taxi_app/network.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Network network = Network();
  Model model;
  Set<Marker> markers = Set();
  Set<Marker> selectedMarkers;
  Set<Marker> taxiMarkers = Set();
  Set<Marker> poolMarkers = Set();
  List<PoiList> taxiList = List();
  List<PoiList> poolList = List();
  var location = new Location();
  LocationData currentLocation;
  int selected;
  @override
  void initState() {
    super.initState();

    getData();
    selected = 0;
  }

  getData() async {
    model = await network.getData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    model != null ? putMarkersAndLists() : markers = Set();
    return Scaffold(
      body: model != null
          ? Stack(
              children: <Widget>[
                _googleMap(context),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setStat) {
                              return Container(
                                height: 200,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Radio(
                                          value: 0,
                                          groupValue: selected,
                                          onChanged: (val) {
                                            setStat(() {
                                              selected = val;
                                            });
                                            setState(() {
                                              selectedMarkers = markers;
                                            });
                                          },
                                        ),
                                        Text('All'),
                                        Radio(
                                          value: 1,
                                          groupValue: selected,
                                          onChanged: (val) {
                                            setStat(() {
                                              selected = val;
                                            });
                                            setState(() {
                                              selectedMarkers = poolMarkers;
                                            });
                                          },
                                        ),
                                        Text('Pooling'),
                                        Radio(
                                          value: 2,
                                          groupValue: selected,
                                          onChanged: (val) {
                                            setStat(() {
                                              selected = val;
                                            });
                                            setState(() {
                                              selectedMarkers = taxiMarkers;
                                            });
                                          },
                                        ),
                                        Text('Taxi'),
                                      ],
                                    ),
                                    _myListCars()
                                  ],
                                ),
                              );
                            });
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.0),
                      height: 50,
                      color: Colors.white,
                      child: Text(
                        'Avaliable Cars',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          currentLocation = await location.getLocation();
          print(currentLocation.latitude);
          print(currentLocation.longitude);
          _goToLocation(
              LatLng(currentLocation.latitude, currentLocation.longitude));
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }

  _myListCars() {
    print(selected);
    if (selected == 0) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.poiList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _goToLocation(LatLng(
                                model.poiList[index].coordinate.latitude,
                                model.poiList[index].coordinate.longitude));
                          },
                          child: Container(
                            child: model.poiList[index].fleetType == "POOLING"
                                ? Image.asset(
                                    'assets/map_carB.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/map_taxiB.png',
                                    fit: BoxFit.fill,
                                  ),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Text('${model.poiList[index].id}'),
                        Text(
                          '${model.poiList[index].fleetType}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              );
            },
          ),
        ),
      );
    } else if (selected == 1) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: poolList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.yellow[600],
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _goToLocation(LatLng(
                                poolList[index].coordinate.latitude,
                                poolList[index].coordinate.longitude));
                          },
                          child: Container(
                            child: Image.asset(
                              'assets/map_carB.png',
                              fit: BoxFit.fill,
                            ),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Text('${poolList[index].id}'),
                        Text('${poolList[index].fleetType}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )),
              );
            },
          ),
        ),
      );
    } else if (selected == 2) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: taxiList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _goToLocation(LatLng(
                                taxiList[index].coordinate.latitude,
                                taxiList[index].coordinate.longitude));
                          },
                          child: Container(
                            child: Image.asset(
                              'assets/map_taxiB.png',
                              fit: BoxFit.fill,
                            ),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Text('${taxiList[index].id}'),
                        Text('${taxiList[index].fleetType}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )),
              );
            },
          ),
        ),
      );
    }
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition:
              CameraPosition(target: LatLng(30.129610, 30.864947), zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: selectedMarkers ?? markers),
    );
  }

  Future<void> _goToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 18),
      ),
    );
  }

  putMarkersAndLists() {
    for (int i = 0; i < model.poiList.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('${model.poiList[i].id}'),
          rotation: model.poiList[i].heading,
          flat: true,
          position: LatLng(model.poiList[i].coordinate.latitude,
              model.poiList[i].coordinate.longitude),
          infoWindow: InfoWindow(title: 'Car$i'),
          icon: model.poiList[i].fleetType == 'POOLING'
              ? BitmapDescriptor.fromAsset('assets/map_car.png')
              : BitmapDescriptor.fromAsset('assets/map_taxi.png'),
        ),
      );
      if (model.poiList[i].fleetType == "POOLING" && model != null) {
        poolList.add(model.poiList[i]);
        poolMarkers.add(
          Marker(
              markerId: MarkerId('${model.poiList[i].id}'),
              rotation: model.poiList[i].heading,
              flat: true,
              position: LatLng(model.poiList[i].coordinate.latitude,
                  model.poiList[i].coordinate.longitude),
              infoWindow: InfoWindow(title: 'Car$i'),
              icon: BitmapDescriptor.fromAsset('assets/map_car.png')),
        );
      } else if (model.poiList[i].fleetType == "TAXI" && model != null) {
        taxiList.add(model.poiList[i]);
        taxiMarkers.add(
          Marker(
              markerId: MarkerId('${model.poiList[i].id}'),
              flat: true,
              rotation: model.poiList[i].heading,
              position: LatLng(model.poiList[i].coordinate.latitude,
                  model.poiList[i].coordinate.longitude),
              infoWindow: InfoWindow(title: 'Car$i'),
              icon: BitmapDescriptor.fromAsset('assets/map_taxi.png')),
        );
      }
    }
    if (mounted) {
      setState(() {});
    }
  }
}
