import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Imagepick extends StatefulWidget {
  @override
  State<Imagepick> createState() => _ImagepickState();
}

class _ImagepickState extends State<Imagepick> {
  File? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(_imageFile!)
                : Container(
                    margin: EdgeInsets.only(bottom: 450),
                    height: 100,
                    width: 100,
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      requestPermissions();
                      captureImage();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(150, 60)),
                    ),
                    child: Text('Capture Image'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    requestPermissions();
                    pickImage();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16)),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(150, 60))),
                  child: Text('Pick Image from Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermissions() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      // Handle denied camera permissions
      return;
    }

    status = await Permission.photos.request();
    if (!status.isGranted) {
      // Handle denied photo library permissions
      return;
    }
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Do something with the picked image
      File imageFile = File(pickedFile.path);
      // You can display the image, upload it, etc.
    } else {
      // User canceled the picker
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Do something with the picked image
      File imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      // User canceled the picker
    }
  }
}
