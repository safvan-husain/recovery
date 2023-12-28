import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';

class MyCamera extends StatefulWidget {
  const MyCamera({super.key});

  @override
  State<MyCamera> createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras; // Define cameras here

  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras(); // Initialize cameras here
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        cameras[0],
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

      // Next, you need to initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: [
                CameraPreview(_controller),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () async {
                          File file = await takePicture();
                          context.read<HomeCubit>().searchWithCamera(file, (s) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(s)));
                          });
                          log(file.path);
                        },
                        child: Text("Click")))
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<File> takePicture() async {
    try {
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      // If the picture was taken, display it on a new screen.
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPictureScreen(
      //       // Pass the automatically generated path to
      //       // the DisplayPictureScreen widget.
      //       imagePath: image.path,
      //     ),
      //   ),
      // );
      return File(image.path);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
      rethrow;
    }
  }
}
