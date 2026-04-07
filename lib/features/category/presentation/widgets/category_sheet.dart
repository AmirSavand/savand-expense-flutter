import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/domain/models/category_form.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/widgets/app_sheet.dart';
import 'package:expense/shared/widgets/input/input_bool.dart';
import 'package:expense/shared/widgets/input/input_color.dart';
import 'package:expense/shared/widgets/input/input_expense_kind.dart';
import 'package:expense/shared/widgets/input/input_icon.dart';
import 'package:expense/shared/widgets/input/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySheet extends ConsumerStatefulWidget {
  final Category? category;

  const CategorySheet({super.key, this.category});

  @override
  ConsumerState<CategorySheet> createState() => _CategorySheetState();

  static Future<void> show(BuildContext context, {Category? category}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => CategorySheet(category: category),
    );
  }
}

class _CategorySheetState extends ConsumerState<CategorySheet> {
  final nameController = TextEditingController();
  ExpenseKind kind = ExpenseKind.expense;
  String icon = 'dollar';
  String color = '#f44336';
  bool archived = false;

  bool loading = false;
  String? error;

  bool get isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final category = widget.category!;
      nameController.text = category.name;
      icon = category.icon;
      color = category.color;
      archived = category.archive;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
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
      final form = CategoryForm(
        profile: isEditing
            ? widget.category!.profile
            : ref.read(currentProfileProvider)!.id,
        kind: kind,
        name: name,
        color: color,
        icon: icon,
        archived: archived,
        note: null,
      );
      if (isEditing) {
        await ref
            .read(categoryProvider.notifier)
            .update(widget.category!.id, form);
      } else {
        await ref.read(categoryProvider.notifier).create(form);
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
    const padding = EdgeInsets.symmetric(horizontal: 32);
    return AppSheet(
      title: isEditing ? 'Update Category' : 'Create Category',
      children: [
        Padding(
          padding: padding,
          child: InputKind(
            selected: kind,
            onSelect: (value) => setState(() => kind = value),
            excludeTransfer: true,
          ),
        ),
        Padding(
          padding: padding,
          child: InputText(label: 'Name*', controller: nameController),
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
