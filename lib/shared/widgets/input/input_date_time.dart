import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:expense/shared/utils/display_date.dart';
import 'package:flutter/material.dart';

class InputDateTime extends StatelessWidget {
  final String label;
  final DateTime value;
  final void Function(DateTime) onSelect;
  final bool includeTime;

  const InputDateTime({
    super.key,
    required this.value,
    required this.onSelect,
    this.label = 'Date',
    this.includeTime = true,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (pickedDate == null || !context.mounted) {
      return;
    }
    if (!includeTime) {
      onSelect(pickedDate);
      return;
    }
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
    );
    if (pickedTime == null) {
      return;
    }
    onSelect(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDateTime(context),
      borderRadius: appBorderRadius,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: appBorderRadius),
          label: Text(label),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(includeTime ? displayDateTime(value) : displayDate(value)),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }
}
