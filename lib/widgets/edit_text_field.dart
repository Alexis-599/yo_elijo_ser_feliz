import 'package:flutter/material.dart';

class EditTextField extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const EditTextField({
    super.key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  });

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            isDense: true,
            // contentPadding: EdgeInsets.all(10),
          ),
        )
      ],
    );
  }
}
