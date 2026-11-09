import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/contact_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  Color _currentColor = const Color(0xFFB56576); 
  String? _selectedFileName;
  String? _selectedFilePath;
  String? _selectedFileExtension;

  String? _fileErrorText;
  int? _editingIndex;
  final List<ContactModel> _contacts = [];

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama wajib diisi';
    final trimmed = value.trim();
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) return 'Nama hanya boleh mengandung huruf dan spasi';
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length < 2) return 'Nama harus terdiri dari minimal 2 kata';
    for (final word in words) {
      if (word.isEmpty || !RegExp(r'^[A-Z]').hasMatch(word[0])) return 'Setiap kata pada nama harus diawali huruf kapital';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor telepon wajib diisi';
    final phone = value.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) return 'Hanya boleh berisi angka 0-9';
    if (!phone.startsWith('62')) return 'Harus diawali dengan 62';
    if (phone.length < 8 || phone.length > 13) return 'Panjang harus antara 8 hingga 13 digit';
    return null;
  }

  String? _validateDate(String? value) {
    if (_selectedDate == null || value == null || value.trim().isEmpty) return 'Tanggal wajib dipilih';
    return null;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _pickColor() {
    Color tempColor = _currentColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Your Color', style: const TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (color) => tempColor = color,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB56576), foregroundColor: Colors.white),
              onPressed: () {
                setState(() => _currentColor = tempColor);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFile() async {
    try {
      final files = await FilePicker.pickFiles();
      if (files.isNotEmpty) {
        final pickedFile = files.first;
        setState(() {
          _selectedFileName = pickedFile.name;
          _selectedFilePath = pickedFile.path;
          _selectedFileExtension = pickedFile.extension;
          _fileErrorText = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memilih berkas: $e')));
    }
  }

  void _submitForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final isFileValid = _selectedFileName != null && _selectedFileName!.isNotEmpty;

    setState(() => _fileErrorText = isFileValid ? null : 'Berkas wajib dipilih terlebih dahulu');

    if (!isFormValid || !isFileValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon periksa kembali isian formulir!', style: const TextStyle()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newContact = ContactModel(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      date: _selectedDate!,
      color: _currentColor,
      fileName: _selectedFileName!,
      filePath: _selectedFilePath,
      fileExtension: _selectedFileExtension,
    );

    setState(() {
      if (_editingIndex == null) {
        _contacts.add(newContact);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kontak ditambahkan!', style: const TextStyle()), backgroundColor: Colors.green));
      } else {
        _contacts[_editingIndex!] = newContact;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perubahan disimpan!', style: const TextStyle()), backgroundColor: const Color(0xFFB56576)));
      }
      _resetForm();
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _phoneController.clear();
    _nameController.clear();
    _dateController.clear();
    _selectedDate = null;
    _currentColor = const Color(0xFFB56576);
    _selectedFileName = null;
    _selectedFilePath = null;
    _selectedFileExtension = null;
    _fileErrorText = null;
    _editingIndex = null;
  }

  void _editContact(int index) {
    final contact = _contacts[index];
    setState(() {
      _editingIndex = index;
      _nameController.text = contact.name;
      _phoneController.text = contact.phoneNumber;
      _selectedDate = contact.date;
      _dateController.text = DateFormat('dd-MM-yyyy').format(contact.date);
      _currentColor = contact.color;
      _selectedFileName = contact.fileName;
      _selectedFilePath = contact.filePath;
      _selectedFileExtension = contact.fileExtension;
      _fileErrorText = null;
    });
  }

  void _confirmDeleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus', style: const TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin ingin menghapus kontak "${_contacts[index].name}"?', style: const TextStyle()),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _contacts.removeAt(index);
                  if (_editingIndex == index) {
                    _resetForm();
                  } else if (_editingIndex != null && _editingIndex! > index) {
                    _editingIndex = _editingIndex! - 1;
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 14),
                
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 14),
                
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  validator: _validateDate,
                ),
                const SizedBox(height: 16),
                Text('Color', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(color: _currentColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade400)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: _currentColor, foregroundColor: Colors.white),
                    onPressed: _pickColor,
                    icon: const Icon(Icons.color_lens_outlined),
                    label: Text('Pick Color', style: const TextStyle()),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Pick Files', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF28482), foregroundColor: Colors.white),
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file_rounded),
                    label: Text('Pick and Open File', style: const TextStyle()),
                  ),
                ),
                if (_selectedFileName != null)
                  Padding(padding: const EdgeInsets.only(top: 8.0), child: Center(child: Text('Berkas: $_selectedFileName', style: const TextStyle(fontSize: 12, color: Color(0xFF6D597A))))),
                if (_fileErrorText != null)
                  Padding(padding: const EdgeInsets.only(top: 6.0), child: Center(child: Text(_fileErrorText!, style: TextStyle(fontSize: 12, color: Colors.red[700])))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_editingIndex != null) ...[
                      OutlinedButton(onPressed: () => setState(() => _resetForm()), child: const Text('Batal Edit', style: TextStyle())),
                      const SizedBox(width: 10),
                    ],
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB56576), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                      onPressed: _submitForm,
                      child: Text(_editingIndex == null ? 'Submit' : 'Update', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('List Contact', style: const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF22223B))),
          ),
          const SizedBox(height: 12),
          _contacts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: Text('Belum ada data kontak yang tersimpan.', style: TextStyle(color: Colors.grey[600]))),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildLeadingPreview(contact),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contact.name, style: const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(contact.phoneNumber, style: const TextStyle(fontSize: 13)),
                                  Text(DateFormat('dd-MM-yyyy').format(contact.date), style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                  Text('Berkas: ${contact.fileName}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 6),
                                  Container(height: 10, width: double.infinity, decoration: BoxDecoration(color: contact.color, borderRadius: BorderRadius.circular(6))),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, color: Color(0xFF6D597A)),
                              onPressed: () => _editContact(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                              onPressed: () => _confirmDeleteContact(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildLeadingPreview(ContactModel contact) {
    if (contact.isImage && contact.filePath != null && File(contact.filePath!).existsSync()) {
      return ClipOval(child: Image.file(File(contact.filePath!), width: 52, height: 52, fit: BoxFit.cover));
    }
    return CircleAvatar(radius: 26, backgroundColor: contact.color.withOpacity(0.2), child: Icon(Icons.insert_drive_file_rounded, color: contact.color));
  }
}