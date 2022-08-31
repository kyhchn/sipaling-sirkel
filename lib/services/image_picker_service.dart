import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final picker = ImagePicker();
  Future<File?> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return null;
      } else {
        return File(pickedFile.path);
      }
    } catch (e) {
      return null;
    }
  }
}
