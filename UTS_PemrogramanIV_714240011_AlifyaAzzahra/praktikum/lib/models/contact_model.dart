import 'package:flutter/material.dart';

class ContactModel {
  String name;
  String phoneNumber;
  DateTime date;
  Color color;
  String fileName;
  String? filePath;
  String? fileExtension;

  ContactModel({
    required this.name,
    required this.phoneNumber,
    required this.date,
    required this.color,
    required this.fileName,
    this.filePath,
    this.fileExtension,
  });

  bool get isImage {
    if (fileExtension == null) return false;
    final ext = fileExtension!.toLowerCase();
    return ext == 'jpg' || ext == 'jpeg' || ext == 'png';
  }
}