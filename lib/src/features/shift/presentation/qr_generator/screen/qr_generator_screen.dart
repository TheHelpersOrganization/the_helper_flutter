import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QRGeneratorScreen extends ConsumerWidget {
  final int shiftId;
  final int activityId;
  const QRGeneratorScreen({
    required this.shiftId,
    required this.activityId,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shift $shiftId QR Code'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Check in',
                icon: Icon(Icons.login),
              ),
              Tab(
                text: 'Check out',
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: 
                  QrImageView(
                    data: 'the-helper-ci ${shiftId.toString()}',
                    version: QrVersions.auto,
                  ),
                  // OutlinedButton(onPressed: saveCheckIn, child: const Text('Save QR'))
            ),
            Center(
              child: QrImageView(
                data: 'the-helper-co ${shiftId.toString()}',
                version: QrVersions.auto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
