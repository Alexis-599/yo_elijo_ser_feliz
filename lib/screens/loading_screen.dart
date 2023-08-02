import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.amber.shade300.withOpacity(0.8),
                  Colors.amber.shade100.withOpacity(0.8),
                ]
            )
        ),
        child: const Center(
          child: SpinKitChasingDots(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}