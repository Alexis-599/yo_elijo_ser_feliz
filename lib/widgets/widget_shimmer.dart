import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget{
  final double height;
  final double width;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    this.width = double.infinity,
    required this.height
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.amberAccent.shade100, // grey.shade400
    highlightColor: Colors.amberAccent, // grey.shade300
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.grey[400],
        shape: shapeBorder,
      ),
    ),
  );
}

class ShimmerPlaylist extends StatelessWidget {
  const ShimmerPlaylist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ShimmerWidget.circular(
            height: 100,
            width: 75,
            shapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ShimmerWidget.rectangular(height: 16, width: 180),
                SizedBox(height: 8),
                ShimmerWidget.rectangular(height: 14, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerVideo extends StatelessWidget {
  const ShimmerVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 150,
        maxHeight: 150,
      ),
      child: Column(
        children: [
          ShimmerWidget.circular(
            height: 150,
            width: 150,
            shapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 10, width: 130),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 10, width: 100),
        ],
      ),
    );
  }
}
