import 'package:crop_your_image/crop_your_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ImageCropperScreen extends StatelessWidget {
  final XFile imageFile;
  late final Future<Uint8List> imageDataFuture;
  final double aspectRatio;
  final _controller = CropController();

  ImageCropperScreen({
    Key? key,
    required this.imageFile,
    this.aspectRatio = 16 / 9,
  }) : super(key: key) {
    imageDataFuture = imageFile.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuery.size.width - 24;
    final height = width / aspectRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Move and Crop Image'),
        centerTitle: true,
      ),
      body: FutureBuilder<Uint8List>(
        future: imageDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Crop(
                        image: snapshot.data!,
                        controller: _controller,
                        onCropped: (value) {
                          Navigator.of(context).pop(value);
                        },
                        initialAreaBuilder: (rect) => Rect.fromLTRB(
                          rect.left + 16,
                          rect.top + 12,
                          rect.right - 16,
                          rect.bottom - 12,
                        ), //null,
                        maskColor: Colors.white.withOpacity(0.5),
                        cornerDotBuilder: (size, edgeAlignment) =>
                            const SizedBox.shrink(),
                        aspectRatio: aspectRatio,
                        interactive: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: () {
                            _controller.crop();
                          },
                          icon: const Icon(Icons.crop_outlined),
                          label: const Text('Crop'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
