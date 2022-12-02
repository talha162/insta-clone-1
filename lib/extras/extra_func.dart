import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

navigateToWithBack({required BuildContext context, required new_route}) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => new_route));
}

navigateToWithNoBack({required BuildContext context, required new_route}) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => new_route));
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}
