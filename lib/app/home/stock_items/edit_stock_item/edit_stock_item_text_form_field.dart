import 'package:flutter/material.dart';

import '../../../../common_widgets/custom_text_form_field.dart';

class EditStockItemTextFormField extends CustomTextFormField {
  EditStockItemTextFormField({
    required TextInputAction textInputAction,
    required String labelText,
    required String initialValue,
    int? maxLines: 1,
    TextInputType? keyboardType,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
  }) : super(
          initialValue: initialValue,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onSaved: onSaved,
          labelText: labelText,
          textInputAction: textInputAction,
          validator: validator,
        );
}
