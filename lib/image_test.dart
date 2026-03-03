import 'package:flutter/material.dart';

class ImageTest extends StatelessWidget {
  const ImageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Test')),
      body: Center(
        child: Image.asset('assets/images/oil_and_gas/img1.jpg', width: 250),
      ),
    );
  }
}
