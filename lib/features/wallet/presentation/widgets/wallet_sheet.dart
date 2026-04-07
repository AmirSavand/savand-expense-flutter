import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/domain/models/wallet_form.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/widgets/app_sheet.dart';
import 'package:expense/shared/widgets/input/input_bool.dart';
import 'package:expense/shared/widgets/input/input_color.dart';
import 'package:expense/shared/widgets/input/input_icon.dart';
import 'package:expense/shared/widgets/input/input_number.dart';
import 'package:expense/shared/widgets/input/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletSheet extends ConsumerStatefulWidget {
  final Wallet? wallet;

  const WalletSheet({super.key, this.wallet});

  @override
  ConsumerState<WalletSheet> createState() => _WalletSheetState();

  static Future<void> show(BuildContext context, {Wallet? wallet}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => WalletSheet(wallet: wallet),
    );
  }
}

class _WalletSheetState extends ConsumerState<WalletSheet> {
  final nameController = TextEditingController();
  final initialBalanceController = TextEditingController();
  String icon = 'wallet';
  String color = '#4caf50';
  bool archived = false;

  bool loading = false;
  String? error;

  bool get isEditing => widget.wallet != null;

  @override
  void initState() {
    super.initState();
    initialBalanceController.text = '0';
    if (isEditing) {
      final wallet = widget.wallet!;
      nameController.text = wallet.name;
      icon = wallet.icon;
      color = wallet.color;
      archived = wallet.archive;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    initialBalanceController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (loading) return;
    final name = nameController.text.trim();
    if (name.length < 2) {
      setState(() => error = 'Name is required');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final form = WalletForm(
        profile: isEditing
            ? widget.wallet!.profile
            : ref.read(currentProfileProvider)!.id,
        name: name,
        initialBalance: double.tryParse(initialBalanceController.text) ?? 0,
        color: color,
        icon: icon,
        archived: archived,
        note: null,
      );
      if (isEditing) {
        await ref.read(walletProvider.notifier).update(widget.wallet!.id, form);
      } else {
        await ref.read(walletProvider.notifier).create(form);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          error = displayError(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const padding = EdgeInsets.symmetric(horizontal: 32);
    return AppSheet(
      title: isEditing ? 'Update Wallet' : 'Create Wallet',
      children: [
        Padding(
          padding: padding,
          child: InputText(label: 'Name*', controller: nameController),
        ),
        if (!isEditing)
          Padding(
            padding: padding,
            child: InputNumber(
              label: 'Initial balance',
              controller: initialBalanceController,
            ),
          ),
        InputIcon(selected: icon, onSelect: (value) => icon = value),
        InputColor(selected: color, onSelect: (value) => color = value),
        Padding(
          padding: padding,
          child: InputBool(
            selected: archived,
            onSelect: (value) => archived = value,
            label: 'Archived',
          ),
        ),
        if (error != null)
          Padding(
            padding: padding,
            child: Text(
              error!,
              style: TextStyle(color: theme.colorScheme.error),
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
