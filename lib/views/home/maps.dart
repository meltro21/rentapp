import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsSample extends StatefulWidget {
  double lat;
  double lng;
  String address;
  MapsSample({required this.lat, required this.lng, required this.address});
  @override
  State<MapsSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapsSample> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late CameraPosition _kGooglePlex;
  late CameraPosition _kLake;
  // final MarkerId markerId = MarkerId('1');
  //      Marker marker = Marker(
  //     markerId: markerId,

  //   );

  void _onMapCreated(GoogleMapController controller) {
    //mapController = controller;

    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(widget.lat, widget.lng),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kGooglePlex = CameraPosition(
        target: LatLng(widget.lat, widget.lng), zoom: 15.151926040649414);
  }

  @override
  Widget build(BuildContext context) {
    print('lat is ${widget.lat}');
    print('lng is ${widget.lng}');
    return new Scaffold(
      appBar: AppBar(
        title: Text('${widget.address}'),
      ),
      body: GoogleMap(
        markers: markers.values.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the location!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
