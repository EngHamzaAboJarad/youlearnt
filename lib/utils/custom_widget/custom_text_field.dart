import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Color? color;
  final double? height;
  final double? fontSize;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onTap;

  const CustomTextField(
      {this.controller,
      this.hintText,
      this.height,
      this.fontSize,
      this.maxLength,
      this.focusNode,
      this.color,
      this.prefixIcon,
      this.textInputAction,
      this.keyboardType,
      this.validator,
      this.onChanged,
      this.maxLines = 1,
      this.onTap,
      this.onFieldSubmitted,
      this.obscureText = false,
      this.enableSuggestions = true,
      this.autocorrect = true,
      Key? key})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300)),
      child: TextFormField(
        controller: widget.controller,
        onTap: widget.onTap,
        maxLines: widget.maxLines,
        readOnly: widget.onTap != null,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: !widget.obscureText ? false : !_obscureText,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        textInputAction: widget.textInputAction,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength),
        ],
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: !widget.obscureText
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
            hintStyle: TextStyle(fontSize: widget.fontSize?.sp , color: Colors.grey.shade400),
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.prefixIcon == null
                ? widget.obscureText
                    ? const EdgeInsets.only(top: 12, left: 10, right: 10)
                    : const EdgeInsets.symmetric(horizontal: 10)
                : null,
            border: InputBorder.none),
      ),
    );
  }
}
