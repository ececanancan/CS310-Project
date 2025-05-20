import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapSelectorPage extends StatefulWidget {
  const MapSelectorPage({Key? key}) : super(key: key);

  @override
  _MapSelectorPageState createState() => _MapSelectorPageState();
}

class _MapSelectorPageState extends State<MapSelectorPage> {
  LatLng? markerPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(41.0082, 28.9784),
              maxZoom: 18.0,
              initialZoom: 13.0,
              onTap: (_, point) {
                setState(() {
                  markerPosition = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              if (markerPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: markerPosition!,
                      width: 40.0,
                      height: 40.0,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (markerPosition != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, markerPosition);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67C933),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Submit Location", style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
