import 'package:flutter/material.dart';

class MyOrganizationScreen extends StatelessWidget {
  const MyOrganizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Organizations'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('My Organization'),
      ),
    );
  }
}
