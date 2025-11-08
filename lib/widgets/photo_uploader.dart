import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploader extends StatefulWidget {
  final int maxCount;
  final List<String> paths;
  final ValueChanged<List<String>> onChanged;
  const PhotoUploader({super.key, required this.maxCount, required this.paths, required this.onChanged});

  @override
  State<PhotoUploader> createState() => _PhotoUploaderState();
}

class _PhotoUploaderState extends State<PhotoUploader> {
  final picker = ImagePicker();

  Future<void> _pick() async {
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image == null) return;
    final updated = [...widget.paths, image.path];
    if (updated.length <= widget.maxCount) widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in widget.paths)
              Stack(
                children: [
                  Image.file(File(p), width: 90, height: 90, fit: BoxFit.cover),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => widget.onChanged(widget.paths..remove(p)),
                    ),
                  )
                ],
              ),
            if (widget.paths.length < widget.maxCount)
              OutlinedButton.icon(
                onPressed: _pick,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Добавить фото'),
              ),
          ],
        ),
        Text('Макс: ${widget.maxCount} фото'),
      ],
    );
  }
}
