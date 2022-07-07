import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final double lat;
  final double long;
  MapSample(this.lat, this.long);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> marker = {};

  void _onMapCreate(GoogleMapController controller){
    setState(() {
      marker.add(Marker(
          markerId: MarkerId('id_1'),
          position: LatLng(widget.lat, widget.long),
          infoWindow: InfoWindow(
              snippet: 'MindRiser',
              title: 'MindRiser'
          )
      ));
    });

  }

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: marker,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 17.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _onMapCreate(controller);
          _controller.complete(controller);
        },
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}