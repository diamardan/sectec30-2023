import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String name;
  final String? errorMessage;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.hint,
    required this.name,
    this.errorMessage,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      onSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      name: name,
      maxLength: maxLength,
      textInputAction: textInputAction,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: validator,
    );
  }
}
