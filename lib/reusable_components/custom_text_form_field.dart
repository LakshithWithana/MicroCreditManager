import 'package:flutter/material.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    Key? key,
    this.controller,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
    this.secure,
    this.readOnly,
    @required this.label,
    this.enabled,
    this.prefix,
  }) : super(key: key);
  TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Function(String)? onChanged;
  final inputFormatters;
  final keyboardType;
  final bool? secure;
  final bool? readOnly;
  final String? label;
  final bool? enabled;
  final Widget? prefix;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    if (widget.initialValue != null) {
      setState(() {
        widget.controller = null;
      });
    }

    return Column(
      children: [
        CustomTextBox(
          textValue: widget.label!,
          textSize: 4,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: mainFontColor,
        ),
        SizedBox(height: height * 0.5),
        SizedBox(
          height: height * 8.5,
          child: TextFormField(
            enabled: widget.enabled,
            style: TextStyle(
              color: black,
              fontSize: 5 * width,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: width * 3, vertical: height * 2),
              fillColor: backgroundColor,
              filled: true,
              // hintStyle: TextStyle(color: Color(0xff8D99AE)),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(width * 3),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(width * 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(width * 3),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD00000), width: 2.0),
                borderRadius: BorderRadius.circular(width * 3),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD00000), width: 2.0),
                borderRadius: BorderRadius.circular(width * 3),
              ),
            ),
            validator: widget.validator,
            controller: widget.controller,
            initialValue: widget.initialValue,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            obscureText: widget.secure == null ? false : widget.secure!,
            readOnly: widget.readOnly == null ? false : widget.readOnly!,
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }
}
