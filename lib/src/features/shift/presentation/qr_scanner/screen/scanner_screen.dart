import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/router/router.dart';
import 'scanner_error_widget.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({
    super.key,
  });
  @override
  ScannerScreenState createState() => ScannerScreenState();
}

class ScannerScreenState extends ConsumerState<ScannerScreen> {
  BarcodeCapture? barcode;
  MobileScannerArguments? arguments;

  final MobileScannerController controller = MobileScannerController(
      // torchEnabled: true,
      // formats: [BarcodeFormat.qrCode]
      // facing: CameraFacing.front,
      // detectionSpeed: DetectionSpeed.normal
      // detectionTimeoutMs: 1000,
      // returnImage: true,
      );

  bool isStarted = true;


  void validateQR() {
    if (barcode?.barcodes.first.rawValue == null) return;
    final String value = barcode!.barcodes.first.rawValue!;
    String shiftId;
    String checkInOut;
    if (value.startsWith('the-helper-ci')) {
      shiftId = value.split(' ').last;
      checkInOut = 'check-in';
    } else if (value.startsWith('the-helper-co')) {
      shiftId = value.split(' ').last;
      checkInOut = 'check-out';
    } else {
      return;
    }
    context.pushNamed(
      AppRoute.shiftAttendance.name,
      pathParameters: {
        'shiftId': shiftId,
        'checkInOut': checkInOut,
      },
    );
  }

  void _startOrStop() {
    try {
      if (isStarted) {
        controller.stop();
      } else {
        controller.start();
      }
      setState(() {
        isStarted = !isStarted;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong! $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Attendance')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.primary,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _startOrStop,
                      child: MobileScanner(
                        controller: controller,
                        errorBuilder: (context, error, child) {
                          return ScannerErrorWidget(error: error);
                        },
                        fit: BoxFit.cover,
                        onDetect: (barcode) {
                          setState(() {
                            this.barcode = barcode;
                          });
                          _startOrStop();
                          validateQR();
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        color: Theme.of(context).colorScheme.background,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              color: Colors.white,
                              icon: ValueListenableBuilder(
                                valueListenable: controller.torchState,
                                builder: (context, state, child) {
                                  switch (state) {
                                    case TorchState.off:
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.grey,
                                      );
                                    case TorchState.on:
                                      return const Icon(
                                        Icons.flash_on,
                                        color: Colors.yellow,
                                      );
                                  }
                                },
                              ),
                              iconSize: 32.0,
                              onPressed: () => controller.toggleTorch(),
                            ),
                            IconButton(
                              color: Colors.black,
                              icon: isStarted
                                  ? const Icon(Icons.stop)
                                  : const Icon(Icons.play_arrow),
                              iconSize: 32.0,
                              onPressed: _startOrStop,
                            ),
                            // Center(
                            //   child: SizedBox(
                            //     width: MediaQuery.of(context).size.width - 200,
                            //     height: 50,
                            //     child: FittedBox(
                            //         child: attendanceWidget(
                            //             barcode?.barcodes.first.rawValue)),
                            //   ),
                            // ),
                            IconButton(
                              color: Colors.black,
                              icon: ValueListenableBuilder(
                                valueListenable: controller.cameraFacingState,
                                builder: (context, state, child) {
                                  switch (state) {
                                    case CameraFacing.front:
                                      return const Icon(Icons.camera_front);
                                    case CameraFacing.back:
                                      return const Icon(Icons.camera_rear);
                                  }
                                },
                              ),
                              iconSize: 32.0,
                              onPressed: () => controller.switchCamera(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: Center(
            //     child: (barcode != null && barcode!.barcodes.isNotEmpty)
            //         ? attendanceWidget(barcode!.barcodes.first.rawValue ?? '')
            //         : Text('hihi'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcode,
    required this.arguments,
    required this.boxFit,
    required this.capture,
  });

  final BarcodeCapture capture;
  final Barcode barcode;
  final MobileScannerArguments arguments;
  final BoxFit boxFit;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcode.corners == null) return;
    final adjustedSize = applyBoxFit(boxFit, arguments.size, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final ratioWidth =
        (Platform.isIOS ? capture.width! : arguments.size.width) /
            adjustedSize.destination.width;
    final ratioHeight =
        (Platform.isIOS ? capture.height! : arguments.size.height) /
            adjustedSize.destination.height;

    final List<Offset> adjustedOffset = [];
    for (final offset in barcode.corners!) {
      adjustedOffset.add(
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
      );
    }
    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
