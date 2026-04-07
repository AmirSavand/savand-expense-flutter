// lib/features/profile/presentation/widgets/profile_sheet.dart
import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/domain/models/profile_form.dart';
import 'package:expense/features/profile/presentation/providers/profile_provider.dart';
import 'package:expense/shared/widgets/app_sheet.dart';
import 'package:expense/shared/widgets/input/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileSheet extends ConsumerStatefulWidget {
  final Profile? profile;

  const ProfileSheet({super.key, this.profile});

  @override
  ConsumerState<ProfileSheet> createState() => _ProfileSheetState();

  static Future<void> show(BuildContext context, {Profile? profile}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => ProfileSheet(profile: profile),
    );
  }
}

class _ProfileSheetState extends ConsumerState<ProfileSheet> {
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final currencyController = TextEditingController();

  bool loading = false;
  String? error;

  bool get isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final profile = widget.profile!;
      nameController.text = profile.name;
      noteController.text = profile.note ?? '';
      currencyController.text = profile.currency;
    } else {
      currencyController.text = 'USD';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    currencyController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (loading) {
      return;
    }
    final name = nameController.text.trim();
    if (name.isEmpty) {
      setState(() => error = 'Name is required');
      return;
    }
    final currency = currencyController.text.trim().toUpperCase();
    if (currency.length != 3) {
      setState(() => error = 'Currency is invalid');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final form = ProfileForm(
        name: name,
        currency: currency,
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
      );
      if (isEditing) {
        await ref
            .read(profileProvider.notifier)
            .update(widget.profile!.id, form);
      } else {
        final profileState = ref.read(profileProvider);
        await ref.read(profileProvider.notifier).create(form);
        if (mounted && profileState is ProfileEmpty) {
          context.goNamed('dash');
        }
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 32);
    return AppSheet(
      title: isEditing ? 'Update Profile' : 'Create Profile',
      children: [
        Padding(
          padding: padding,
          child: InputText(label: 'Name*', controller: nameController),
        ),
        Padding(
          padding: padding,
          child: InputText(
            label: 'Currency* (e.g., USD, EUR, GBP)',
            controller: currencyController,
          ),
        ),
        Padding(
          padding: padding,
          child: InputText(
            label: 'Note',
            controller: noteController,
            multiLine: true,
          ),
        ),
        if (error != null)
          Padding(
            padding: padding,
            child: Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(),
        Padding(
          padding: padding,
          child: FilledButton(
            onPressed: submit,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ),
        ),
      ],
    );
  }
}
