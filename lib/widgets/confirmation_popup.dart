import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final int id;
  final Future<void> Function(int id) deleteExistingHabit;
  const ConfirmationPopup({
    super.key,
    required this.id,
    required this.deleteExistingHabit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure'),
      content: const Text('You are about to delete this habit'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            deleteExistingHabit(id);
            Navigator.pop(context, 'Delete');
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
