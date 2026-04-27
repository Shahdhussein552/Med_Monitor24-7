import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb; // ✅ ضروري لدعم الويب

class ReportSection {
  final String title;
  final List<File> uploadedImages;
  bool isExpanded;

  ReportSection({
    required this.title,
    this.isExpanded = false,
  }) : uploadedImages = [];
}

class PatientReportsScreen extends StatefulWidget {
  const PatientReportsScreen({super.key});
  @override
  State<PatientReportsScreen> createState() => _PatientReportsScreenState();
}

class _PatientReportsScreenState extends State<PatientReportsScreen> {
  static const Color _primaryBlue = Color(0xFF719EFF);
  static const Color _mainBgColor = Color(0xFFEEF0FB);
  static const Color _customTextColor = Color(0xFF626262);

  final ImagePicker _picker = ImagePicker();

  final List<ReportSection> _sections = [
    ReportSection(title: 'Radiology', isExpanded: true),
    ReportSection(title: 'Laboratory'),
    ReportSection(title: 'Daily Reports'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUploadedImages();
  }

  Future<void> _loadUploadedImages() async {
    final prefs = await SharedPreferences.getInstance();
    for (final section in _sections) {
      final String? jsonStr = prefs.getString('uploads_${section.title}');
      if (jsonStr != null) {
        final List<dynamic> paths = jsonDecode(jsonStr);
        setState(() {
          for (final path in paths) {
            // في الويب لا نتحقق من exisitence للملف بنفس طريقة الموبايل
            section.uploadedImages.add(File(path));
          }
        });
      }
    }
  }

  Future<void> _saveUploadedImages(ReportSection section) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> paths = section.uploadedImages.map((f) => f.path).toList();
    await prefs.setString('uploads_${section.title}', jsonEncode(paths));
  }

  Future<void> _pickImage(ReportSection section) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(Icons.camera_alt, "Camera", () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) _handleImageSelection(section, image);
                }),
                _buildPickerOption(Icons.photo_library, "Gallery", () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) _handleImageSelection(section, image);
                }),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _handleImageSelection(ReportSection section, XFile image) async {
    Navigator.pop(context);
    setState(() => section.uploadedImages.add(File(image.path)));
    await _saveUploadedImages(section);
  }

  Widget _buildPickerOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryBlue, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBgColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _sections.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildDropdown(_sections[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _primaryBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const Expanded(
                child: Text(
                  'Patient Reports',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(ReportSection section) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => section.isExpanded = !section.isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        section.title,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: _customTextColor),
                      ),
                    ),
                    Icon(
                      section.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: _customTextColor,
                    ),
                  ],
                ),
              ),
            ),
            if (section.isExpanded) ...[
              const Divider(height: 1),
              ...section.uploadedImages.map((file) => _buildUploadedFileItem(file, section)),
              _buildAddPhotoButton(section),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedFileItem(File file, ReportSection section) {
    // استخراج اسم الملف بشكل نظيف
    String fileName = file.path.split('/').last;
    if (fileName.contains('blob:')) fileName = "Uploaded_Image.png";

    return InkWell(
      onTap: () => _viewImage(file),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.image_outlined, size: 18, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fileName,
                style: const TextStyle(color: _customTextColor, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() => section.uploadedImages.remove(file));
                await _saveUploadedImages(section);
              },
              child: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton(ReportSection section) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => _pickImage(section),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text("Add Photo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _viewImage(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                // ✅ التعديل الجوهري هنا لدعم الويب والموبايل
                child: kIsWeb
                    ? Image.network(imageFile.path, fit: BoxFit.contain)
                    : Image.file(imageFile, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}