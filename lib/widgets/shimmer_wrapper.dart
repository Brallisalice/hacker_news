import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  const ShimmerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerBlock({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 4.0,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ArticleListSkeleton extends StatelessWidget {
  const ArticleListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: ListView.builder(
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBlock(height: 16.0),
              SizedBox(height: 8.0),
              ShimmerBlock(height: 12.0, width: 150.0),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentSkeleton extends StatelessWidget {
  const CommentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          double leftPadding = (index % 2 == 0) ? 16.0 : 36.0;
          return Padding(
            padding: EdgeInsets.only(top: 16.0, right: 16.0, left: leftPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBlock(height: 12, width: 80.0),
                SizedBox(height: 6.0),
                ShimmerBlock(height: 14.0),
                SizedBox(height: 4.0),
                ShimmerBlock(height: 14.0, width: 180.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
