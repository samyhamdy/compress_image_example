import 'package:flutter/material.dart';
import 'compress_image_example.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: CompressImageExample());
  }
}
