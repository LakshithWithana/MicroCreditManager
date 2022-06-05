import 'package:flutter/material.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    this.initValue,
    this.textField,
    this.onChanged,
  }) : super(key: key);

  final String? textField;
  final bool? initValue;
  final Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextBox(
          textValue: textField!,
          textSize: 5,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        Checkbox(
          value: initValue,
          onChanged: (bool? value) {
            onChanged!(value!);
          },
        ),
      ],
    );
  }
}
