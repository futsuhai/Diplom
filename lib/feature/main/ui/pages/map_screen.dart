import 'package:flutter/material.dart';

import '../components/image_from_url.dart';

class MapScreen extends StatelessWidget{
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Colors.grey[600],
      ),
      body: const Center(
        child: ImageFromUrl(imageUrl: "https://drive.google.com/uc?id=1hfux4-4zjPpKmqMJNJ4uNFAN8IpZAQLN"),
      ),
    );
  }
}