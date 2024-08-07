import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:skopski_vremeplov/modules/monument.dart';
import 'package:skopski_vremeplov/services/notification_service.dart';

class GoogleMaps extends StatefulWidget {
  static const String id = "googleMaps";
  final List<Monument> _list;
  static String API_KEY = "AIzaSyA2HqPUM-GfVvfYE46hFfPL_KoNPa2wMxA";
  const GoogleMaps(this._list, {super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMaps> {
  final NotificationService service = NotificationService();
  final List<Marker> markers = <Marker>[];
  List<Monument> _list = [];
  Polyline _route = const Polyline(polylineId: PolylineId("route"));

  @override
  void initState() {
    super.initState();
    _list = widget._list;
    _createMarkers(_list);
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(41.9973, 21.4280),
    zoom: 14,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  void _createMarkers(List<Monument> list) {
    for (var i = 0; i < list.length; i++) {
      markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(list[i].location.latitude, list[i].location.longitude),
        infoWindow: InfoWindow(
          title: list[i].name,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
  }

  Future<void> _createRoute(LatLng destination) async {
    final position = await getUserCurrentLocation();
    final origin = LatLng(position.latitude, position.longitude);

    final directions = await _getDirections(origin, destination);
    setState(() {
      _route = Polyline(
        polylineId: const PolylineId("route"),
        visible: true,
        points: directions,
        color: Colors.blue,
        width: 4,
      );
    });
  }

  Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${GoogleMaps.API_KEY}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final steps = data['routes'][0]['legs'][0]['steps'] as List;

      return steps
          .map((step) => LatLng(step['start_location']['lat'], step['start_location']['lng']))
          .toList()
        ..add(destination);
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Мапа со локации',  style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(markers),
            polylines: {_route},
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});

            await _createRoute(markers.first.position);
          });
        },
        child: const Icon(Icons.pin_drop_outlined),
      ),
    );
  }
}