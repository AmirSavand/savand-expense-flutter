import 'package:expense/features/update/presentation/providers/update_provider.dart';
import 'package:expense/shared/widgets/app_sheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateSheet extends StatelessWidget {
  final UpdateState state;

  const UpdateSheet({super.key, required this.state});

  static Future<void> show(BuildContext context, UpdateState state) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => UpdateSheet(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 32);
    final theme = Theme.of(context);

    return switch (state) {
      UpdateAvailable(:final version, :final url) => AppSheet(
        title: 'Update Available',
        children: [
          Padding(
            padding: padding,
            child: Text(
              'Version $version is available. '
              'Please update the app to get the latest features and fixes.',
              style: TextStyle(color: theme.hintColor),
            ),
          ),
          const SizedBox(),
          Padding(
            padding: padding,
            child: FilledButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Download'),
              ),
            ),
          ),
        ],
      ),
      UpdateLatest() => AppSheet(
        title: 'No Updates',
        children: [
          Padding(
            padding: padding,
            child: Text(
              'You are already using the latest version.',
              style: TextStyle(color: theme.hintColor),
            ),
          ),
          const SizedBox(),
        ],
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
