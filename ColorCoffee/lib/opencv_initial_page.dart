import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'openCV/native_opencv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Directory tempDir;
  String tempPath = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  bool _isProcessed = false;
  bool _isWorking = false;

  void showVersion() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final snackbar = SnackBar(
      content: Text('OpenCV version: ${opencvVersion()}'),
    );

    scaffoldMessenger
      ..removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss)
      ..showSnackBar(snackbar);
  }

  Future<XFile?> pickAnImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image!;
  }

  Future<void> takeImageAndProcess() async {
    final image = await pickAnImage();

    if (image == null) {
      return;
    }

    setState(() {
      _isWorking = true;
    });
    tempDir = await getTemporaryDirectory();

    // Creating a port for communication with isolate and arguments for entry point
    tempPath = '${tempDir.path}/${image.name}.jpg';
    final port = ReceivePort();
    final args =
        ProcessImageArguments(image.path, '${tempDir.path}/${image.name}.jpg');

    // Spawning an isolate
    Isolate.spawn<ProcessImageArguments>(
      processImage,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    // Making a variable to store a subscription in
    late StreamSubscription sub;

    // Listening for messages on port
    sub = port.listen((_) async {
      // Cancel a subscription after message received called
      await sub.cancel();
      

      setState(() {
        _isProcessed = true;
        _isWorking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('title')),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                if (_isProcessed && !_isWorking)
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 3000, maxHeight: 300),
                    child: Image.file(
                      File(tempPath),
                      alignment: Alignment.center,
                    ),
                  ),
                Column(
                  children: [
                    ElevatedButton(
                      child: const Text('Show version'),
                      onPressed: showVersion,
                    ),
                    ElevatedButton(
                      child: const Text('Process photo'),
                      onPressed: takeImageAndProcess,
                    ),
                  ],
                )
              ],
            ),
          ),
          if (_isWorking)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
