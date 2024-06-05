import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Completer<GoogleMapController> _controller = Completer();
  late LatLng _currentLocation;
  File? _image;
  // BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _currentLocation =
        LatLng(-6.200000, 106.816666); // Contoh koordinat Jakarta
    _loadDefaultMarker();
  }

  Future<void> _loadDefaultMarker() async {
    // _customMarker = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(size: Size(48, 48)),
    //   'assets/gambar.jpeg', // path to default marker image in assets
    // );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = File(pickedFile.path);
        // _customMarker = BitmapDescriptor.fromBytes(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Tempat Tinggal'),
      ),
      body: Stack(
        children: [
          // GoogleMap(
          //   initialCameraPosition: CameraPosition(
          //     target: _currentLocation,
          //     zoom: 14.0,
          //   ),
          //   markers: _createMarkers(),
          //   onMapCreated: (GoogleMapController controller) {
          //     _controller.complete(controller);
          //   },
          // ),
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(-7.854121, 110.4266),
              initialZoom: 9.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(-7.807547, 110.383591),
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(image: AssetImage('assets/rohmat.jpg')),
                    ),
                  ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _pickImage,
              child: Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }

  // Set<Marker> _createMarkers() {
  //   return {
  //     Marker(
  //       markerId: MarkerId("home"),
  //       position: _currentLocation,
  //       icon: _customMarker ?? BitmapDescriptor.defaultMarker,
  //       infoWindow: InfoWindow(title: "Lokasi Tempat Tinggal"),
  //     ),
  //   };
  // }
}
