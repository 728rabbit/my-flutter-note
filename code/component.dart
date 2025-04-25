import 'package:flutter/material.dart';

// label
class LableTxt extends StatelessWidget {
  final String message;
  final TextStyle defaultStyle;

  const LableTxt({
    super.key,
    required this.message,
    this.defaultStyle = const TextStyle(
      fontWeight: FontWeight.normal
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(message, style: defaultStyle)
    );
  }
}

/*
input text & password

InputBox(
  outlineLabel: 'Username',
  inlineLabel: 'Enter your name',
  hintTxt: 'e.g. John Doe',
  borderRadius: 8,
  controller: TextEditingController(),
)

InputBox(
  outlineLabel: 'Password',
  inlineLabel: 'Enter password',
  isPassword: true,
  borderRadius: 8,
  controller: TextEditingController(),
)
*/
class InputBox extends StatefulWidget {
  final String? outlineLabel;
  final String? inlineLabel;
  final String? hintTxt;
  final String? errorText;
  final int? borderRadius;
  final int? maxLines;
  final bool? isPassword;
  final TextEditingController? controller;
  final TextStyle textStyle;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  final bool? readOnly;
  final bool? enabled;

  const InputBox({
    super.key,
    this.outlineLabel,
    this.inlineLabel,
    this.hintTxt,
    this.errorText,
    this.borderRadius,
    this.maxLines,
    this.isPassword,
    this.controller,
    this.textStyle = const TextStyle(),
    this.keyboardType,
    this.prefixIcon,
    this.readOnly = false,
    this.enabled = true
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.isPassword ?? false;
    final double horizontalPadding = (widget.borderRadius != null
        ? widget.borderRadius! / 2 + 12
        : 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.outlineLabel != null) ...[
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Text(
              widget.outlineLabel!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: widget.controller,
          maxLines: isPasswordField ? 1 : (widget.maxLines ?? 1),
          obscureText: isPasswordField ? obscureText : false,
          style: widget.textStyle,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly ?? false,
          enabled: widget.enabled ?? true,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: (widget.inlineLabel?.isNotEmpty ?? false)
                ? widget.inlineLabel
                : null,
            hintText: (widget.hintTxt?.isNotEmpty ?? false)
                ? widget.hintTxt
                : null,
            errorText: widget.errorText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: horizontalPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (widget.borderRadius ?? 0).toDouble()),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (widget.borderRadius ?? 0).toDouble()),
              borderSide: const BorderSide(color: Color(0xFF999999), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (widget.borderRadius ?? 0).toDouble()),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 2),
            ),
            suffixIcon: isPasswordField
                ? IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}