import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/color_values.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
        this.controller,
        this.hintText,
        this.labelText,
        this.isPassword = false,
        this.textInputType,
        this.validator,
        this.prefixIcon,
        this.suffixIcon,
        this.isRequired = false,
        this.verticalPadding = 12.0,
        this.horizontalPadding = 18.0,
        this.fontSize,
        this.minLines = 1,
        this.maxLines = 1,
        this.maxLength,
        this.onChanged
      })
      : super(key: key);
  final TextEditingController? controller;
  final double verticalPadding, horizontalPadding;
  final double? fontSize;
  final String? hintText, labelText;
  final bool isPassword, isRequired;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon, suffixIcon;
  final int minLines, maxLines;
  final int? maxLength;
  final void Function(String?)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
        borderSide: const BorderSide(color: ColorValues.lightGrey)
    );

    return TextFormField(
      obscureText: widget.isPassword && !_isShowPassword,
      keyboardType: widget.textInputType,
      controller: widget.controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      style: GoogleFonts.poppins(fontSize: widget.fontSize ?? 16, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: widget.labelText != null ? widget.isRequired ? '${widget.labelText}*' : widget.labelText : null,
        labelStyle: GoogleFonts.poppins(fontSize: widget.fontSize ?? 16, fontWeight: FontWeight.w500, color: ColorValues.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hintText,
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(widget.prefixIcon == null ? widget.horizontalPadding : 0.0, widget.verticalPadding, widget.horizontalPadding, widget.verticalPadding),
        border: border,
        hintStyle: GoogleFonts.poppins(fontSize: widget.fontSize ?? 14, fontWeight: FontWeight.w400, color: Colors.grey.shade400),
        enabledBorder: border,
        focusedBorder: border,
        prefixIconConstraints: const BoxConstraints(),
        suffixIconConstraints: const BoxConstraints(),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: widget.horizontalPadding, right: 8.0),
          child: widget.prefixIcon,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: widget.horizontalPadding),
          child: widget.suffixIcon ?? (widget.isPassword
              ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isShowPassword = !_isShowPassword;
                  });
                },
                child: Icon(
                  _isShowPassword ? Icons.visibility_off : Icons.visibility,
                  size: 20.0,
                ),
              )
              : null),
        ),
      ),
    );
  }
}
