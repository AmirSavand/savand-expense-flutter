import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppTileShimmer extends StatelessWidget {
  const AppTileShimmer({super.key});

  static Widget list(int count, {EdgeInsetsGeometry? padding}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: count,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: Future.delayed(Duration(milliseconds: index * 100)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            return const AppTileShimmer();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: theme.colorScheme.surfaceBright,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: appBorderRadius,
        ),
        child: const AppTile(
          leading: Icon(Icons.circle_outlined),
          title: '',
          subtitle: '',
          trailing: '',
        ),
      ),
    );
  }
}
