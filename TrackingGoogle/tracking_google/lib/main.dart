import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google tracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //http
  Dio dio = new Dio();
  final Completer<GoogleMapController> _controller = Completer();
  String travelDuration = "";
  double travelDurationRest = 0;
  double travelDistance = 0;
  double travelDistanceRest = 0;
  BitmapDescriptor originIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  static const LatLng originLocation = LatLng(37.42253, -122.0847233);
  static const LatLng destinationLocation =
      LatLng(37.412345615560405, -122.07228697405654);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      setState(() {});
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      print(newLoc);
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 13.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      setState(() {});
      //setea distancia faltante
      setState(() {
        travelDistanceRest = calculateDistance(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
            destinationLocation.latitude,
            destinationLocation.longitude);
      });
      //setea tiempo restante
      setState(() {
        travelDurationRest =
            (int.tryParse(travelDuration.replaceAll(" mins", ""))! *
                travelDistanceRest /
                travelDistance);
      });
    });
  }

  void setCustomMarketIcon() {
    //origin icon
    BitmapDescriptor.asset(ImageConfiguration.empty, "assets/icons/origin.png")
        .then((icon) {
      originIcon = icon;
    });
    //destination icon
    BitmapDescriptor.asset(
            ImageConfiguration.empty, "assets/icons/destination.png")
        .then((icon) {
      destinationIcon = icon;
    });

    //current
    BitmapDescriptor.asset(ImageConfiguration.empty, "assets/icons/person.png")
        .then((icon) {
      currentIcon = icon;
    });
  }

  PolylineRequest request = PolylineRequest(
      origin: PointLatLng(originLocation.latitude, originLocation.longitude),
      destination: PointLatLng(
          destinationLocation.latitude, destinationLocation.longitude),
      mode: TravelMode.driving);

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: request,
        googleApiKey: "AIzaSyAMhTfdnMECt8PaeFTzqdeysKVPeWrgMdA");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

//duraci[on total]
  void getDurationAndDistance() async {
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${originLocation.latitude},${originLocation.longitude}&destinations=${destinationLocation.latitude},${destinationLocation.longitude}&key=AIzaSyAMhTfdnMECt8PaeFTzqdeysKVPeWrgMdA");
    print(response.data["rows"][0]["elements"][0]["duration"]["text"]);
    setState(() {
      travelDuration =
          response.data["rows"][0]["elements"][0]["duration"]["text"];
    });
    setState(() {
      travelDistance = calculateDistance(
          originLocation.latitude,
          originLocation.longitude,
          destinationLocation.latitude,
          destinationLocation.longitude);
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarketIcon();
    getPolyPoints();
    getDurationAndDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            currentLocation == null
                ? Center(child: Text("Loading"))
                : GoogleMap(
                    mapType: MapType.terrain,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 13.4),
                    polylines: {
                      Polyline(
                          polylineId: PolylineId("Route"),
                          points: polylineCoordinates,
                          color: Colors.red,
                          width: 6),
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("currrentLocation"),
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        icon: currentIcon,
                      ),
                      Marker(
                        markerId: MarkerId("originLocation"),
                        position: originLocation,
                        icon: originIcon,
                      ),
                      Marker(
                        markerId: MarkerId("destinationLocation"),
                        position: destinationLocation,
                        icon: destinationIcon,
                      )
                    },
                    onMapCreated: (mapController) {
                      _controller.complete((mapController));
                    },
                  ),
            Container(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              AssetImage("assets/icons/avatar.jpg"),
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Jose Luis Sequeira Góngora",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Distancia: " +
                            travelDistance.toStringAsFixed(2) +
                            " km"),
                        Text("   Distancia Rest: " +
                            travelDistanceRest.toStringAsFixed(2) +
                            " km"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Duración: " + travelDuration!),
                        Text("   Duración Rest: " +
                            travelDurationRest.toStringAsFixed(0) +
                            " mins")
                      ],
                    ),
                  ],
                ),
                height: 150,
                width: double.infinity,
                color: const Color.fromARGB(255, 224, 224, 224),
              ),
            )
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    double dLat = _degreesToRadians(endLatitude - startLatitude);
    double dLon = _degreesToRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLatitude)) *
            cos(_degreesToRadians(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
