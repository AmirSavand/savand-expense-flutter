import 'package:expense/shared/providers/package_info_provider.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider).value;

    return Scaffold(
      appBar: AppAppBar(title: 'About'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16).copyWith(top: 0),
          children: [
            AppTile(leading: const Icon(Icons.info), title: 'Savand Expense'),
            AppTile(
              leading: const Icon(Icons.numbers),
              title: 'v${packageInfo?.version ?? '1.0.0'}',
            ),
            AppTile(
              leading: const Icon(Icons.home),
              title: 'Home Page',
              onTap: () => _launch('https://savandbros.com/apps/expense'),
            ),
            AppTile(
              leading: const Icon(Icons.mail),
              title: 'Contact Us',
              onTap: () => _launch('https://savandbros.com/contact-us/'),
            ),
            AppTile(subtitle: 'Savand Bros © 2022-present'),
          ],
        ),
      ),
    );
  }
}
