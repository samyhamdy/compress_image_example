// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class CompressImageExample extends StatefulWidget {
  const CompressImageExample({super.key});

  @override
  _CompressImageExampleState createState() => _CompressImageExampleState();
}

class _CompressImageExampleState extends State<CompressImageExample> {
  File? _fileBeforeCompression;
  File? _fileAfterCompression;
  int _sizeAfterCompression = 0;
  int _sizeBeforeCompression = 0;
  bool isPicked = false;
  bool isLoaded = false;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _fileBeforeCompression = File(pickedFile.path);
      _sizeBeforeCompression = await _fileBeforeCompression!.length();
      _fileAfterCompression = compressAndResizeImage(_fileBeforeCompression!);

      setState(() {
        isPicked = true;
      });
      log(_fileBeforeCompression!.path.toString());
    }
  }

  File compressAndResizeImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    // ----- Lossless compression ----
    img.Image resizedImage = img.copyResize(image!, width: 100, height: 100);
    // ----- Lossy compression -----
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 10);
    String extension = file.path.split('.').last;
    File compressedFile = File(
        file.path.replaceAll(RegExp(r'\.[^\.]+$'), '_compressed.$extension'));
    compressedFile.writeAsBytesSync(compressedBytes);
    _sizeAfterCompression = compressedFile.lengthSync().toInt();
    setState(() {});
    return compressedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Compression Example'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // specify the background color
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select Image To Reduce Size',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 20),
            _fileBeforeCompression != null &&
                    _fileAfterCompression != null &&
                    isPicked
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(
                        _fileBeforeCompression!,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.4,
                        // fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Before conversion size : ${_sizeBeforeCompression.toString()} bytes',
                          style: const TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.file(
                        _fileAfterCompression!,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.4,
                        // fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'After conversion size :  ${_sizeAfterCompression.toString()} bytes',
                          style: const TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  )
                : !isPicked && !isLoaded
                    ? const SizedBox.shrink()
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.amber,
                      )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
