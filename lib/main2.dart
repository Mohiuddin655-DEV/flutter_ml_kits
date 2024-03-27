import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text Recognizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  String text = '';
  File? _imageFile;

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  void _process() async {
    final inputImage = InputImage.fromFile(_imageFile!);
    final recognizer = await textRecognizer.processImage(inputImage);
    text = recognizer.text;
    // for (TextBlock block in recognizer.blocks) {
    //   final Rect rect = block.boundingBox;
    //   final List<Point<int>> cornerPoints = block.cornerPoints;
    //   final String text = block.text;
    //   final List<String> languages = block.recognizedLanguages;
    //
    //   for (TextLine line in block.lines) {
    //     // Same getters as TextBlock
    //     for (TextElement element in line.elements) {
    //       // Same getters as TextBlock
    //     }
    //   }
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to Text Conversion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _getImageFromGallery();
              },
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20.0),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : Container(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _process();
              },
              child: const Text('Convert to Text'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
