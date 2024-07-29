import 'dart:io';

import 'package:film_log/model/thumbnail.dart';
import 'package:film_log/service/thumbnail_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditThumbnailDialog extends StatefulWidget {
  const EditThumbnailDialog({
    super.key,
    required this.label,
    required this.value,
    required this.repo,
  });

  final String label;
  final Thumbnail? value;
  final ThumbnailRepo repo;

  @override
  State<StatefulWidget> createState() => _EditThumbnailDialogState();
}

class _EditThumbnailDialogState extends State<EditThumbnailDialog> {
  final ImagePicker _picker = ImagePicker();

  File? _replacement;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onClear(BuildContext context) async {
    _cleanup();

    Navigator.of(context).pop(EditThumbnailResult(value: null));
  }

  Future<void> _onCancel(BuildContext context) async {
    _cleanup();
    Navigator.of(context).pop();
  }

  Future<void> _onOk(BuildContext context) async {
    if (_replacement == null) {
      Navigator.of(context).pop();
      return;
    }

    final result = await widget.repo.store(_replacement!.path);
    if (!mounted || !context.mounted) return;

    Navigator.of(context).pop(EditThumbnailResult(value: result));
  }

  Future<void> _pick(BuildContext context,
      {required ImageSource source}) async {
    final result = await _picker.pickImage(
      source: source,
      requestFullMetadata: false,
      preferredCameraDevice: CameraDevice.front,
    );
    if (result == null || !mounted || !context.mounted) return;

    await _cleanup();

    setState(() {
      _replacement = File(result.path);
    });
  }

  Future<void> _cleanup() async {
    if (_replacement == null) return;
    await _replacement!.delete();
    _replacement = null;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.label),
        actions: [
          TextButton(
            onPressed: () => _onClear(context),
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => _onCancel(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _onOk(context),
            child: const Text('OK'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _image(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _pick(context, source: ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
                TextButton(
                  onPressed: () => _pick(context, source: ImageSource.camera),
                  child: const Text('Camera'),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _image(BuildContext context) {
    final image = _imagePath();
    if (image == null) return const Icon(Icons.image_not_supported);

    return Image(
      image: ResizeImage(
        FileImage(image),
        width: 200,
      ),
    );
  }

  File? _imagePath() {
    if (_replacement != null) return _replacement!;
    if (widget.value != null) return widget.repo.file(widget.value!);
    return null;
  }
}

class EditThumbnailResult {
  final Thumbnail? value;

  EditThumbnailResult({this.value});
}
