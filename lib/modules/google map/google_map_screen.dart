import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  LatLng? currTapedLocation;
  Set<Circle> circles = <Circle>{};
  RangeValues? currValue;
  double circleRadius = 300.0;
  LocationData? currentLocation;
  double zoom = 15;
  late Location location;
  late StreamSubscription<LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    location = Location();
    _getcurruntlocation();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      currTapedLocation = location;
      _updateCircles(location);
    });
  }

  void _updateCircles([LatLng? location]) {
    circles.clear();
    if (location != null) {
      circles.add(
        Circle(
          circleId: CircleId(location.toString()),
          center: location,
          radius: circleRadius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.blue,
        ),
      );
    }
  }

  Future<String?> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> sendNotification() async {
    String? fcmToken = await getFcmToken();
    const String serverKey =
        'AAAA9J7thMw:APA91bEDeTfQwAIUR23KZ91xFc8Nk_JgPsYq3QosIybqK6a1yUmYBy1iY424JiU9a2MA28GyoX_yi_KmEQmzfbJ6Q_NYXVIEREXfQ1xK-dEpxcTvsACNqOC_bTIIk0Vf-mhqBu4rwDSW';
    // Firebase Cloud Messaging endpoint
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
    // Create the notification payload
    final Map<String, dynamic> notification = {
      'to': fcmToken,
      'notification': {
        'title': 'Test Notification',
        'body': 'You Are Inside Selected Circle Bound',
        'sound': 'default',
      },
    };
    // Create and send the HTTP request
    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: json.encode(notification),
    );
    // Check the response status
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Notification sent successfully');
      }
    } else {
      if (kDebugMode) {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
    }
  }

  Future<void> _getcurruntlocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle service not enabled
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle permission not granted
        return;
      }
    }

    currentLocation = await location.getLocation();
    setState(() {});
    _moveToCurrentLocation();
    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      double distance = Geolocator.distanceBetween(
        newLocation.latitude ?? 0,
        newLocation.longitude ?? 0,
        circles.first.center.latitude,
        circles.first.center.longitude,
      );

      if (distance <= circles.first.radius) {
        print("Inside the circle!");
        sendNotification();
      } else {
        print("Outside the circle");
      }
      _moveToCurrentLocation();
      setState(() {});
    });
  }

  void _moveToCurrentLocation() {
    LatLng currentLatLng = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    if (_controller.isCompleted) {
      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, zoom),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(4).copyWith(top: 12),
          child: FloatingActionButton(
            onPressed: () async {
              _moveToCurrentLocation();
            },
            child: const Icon(Icons.my_location),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              circles: circles,
              markers: {
                Marker(
                    markerId: const MarkerId('currLocation'),
                    infoWindow: const InfoWindow(title: 'Current Location'),
                    position: LatLng(currentLocation?.latitude ?? 0,
                        currentLocation?.longitude ?? 0))
              },
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMove: (position) {
                setState(() {
                  zoom = position.zoom;
                });
              },
              onTap: _onMapTapped,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 50,
                  child: RangeSlider(
                    values: currValue ?? const RangeValues(10, 200),
                    min: 10,
                    max: 300,
                    onChanged: (RangeValues values) {
                      setState(() {
                        currValue = values;
                        circleRadius = (values.start + values.end);
                        _updateCircles(currTapedLocation);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
