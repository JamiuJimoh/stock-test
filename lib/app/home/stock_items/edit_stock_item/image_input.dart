import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  ImageInput({required this.onSelectImage, required this.initialImage});

  final void Function(File file) onSelectImage;
  final File? initialImage;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  File? _image;

  final imgPicker = ImagePicker();

  void setImage() {
    setState(() {
      if (widget.initialImage == null && _storedImage != null) {
        _image = _storedImage;
      } else if (widget.initialImage != null && _storedImage == null) {
        _image = widget.initialImage;
      } else if (widget.initialImage != null && _storedImage != null) {
        _image = _storedImage;
      } else {
        _image = null;
      }
    });
  }

  Future<void> _takePicture(ImageSource imageSource) async {
    final imageFile = await imgPicker.getImage(
      source: imageSource,
    );
    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path);
      });
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await _storedImage?.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage!);
    }
    Navigator.of(context).pop();
  }

  Future<void> _chooseImageSource() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _bottomSheetOption(
                icon: Icons.camera,
                text: 'Take a picture',
                select: () {
                  _takePicture(ImageSource.camera);
                },
              ),
              _bottomSheetOption(
                icon: Icons.photo,
                text: 'Choose from gallery',
                select: () {
                  _takePicture(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    setImage();
    return GestureDetector(
      child: Container(
        height: 200.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: _image == null
              ? null
              : DecorationImage(
                  image: FileImage(_image!),
                  fit: BoxFit.cover,
                ),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 40.0,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Capture / Upload',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : null,
      ),
      onTap: _chooseImageSource,
    );
  }

  Widget _bottomSheetOption({
    required IconData icon,
    required String text,
    required void Function() select,
  }) {
    return GestureDetector(
      onTap: select,
      child: SizedBox(
        height: 150.0,
        child: Column(
          children: [
            Icon(
              icon,
              size: 35.0,
              color: Theme.of(context).accentColor,
            ),
            const SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
