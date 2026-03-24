import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImovelShimmer extends StatelessWidget {
  const ImovelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (_, __) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 180, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 160, color: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(height: 12, width: 80, color: Colors.white),
                      const SizedBox(width: 8),
                      Container(height: 12, width: 60, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
