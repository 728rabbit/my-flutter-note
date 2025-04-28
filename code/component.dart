import 'package:devapp/base.dart';
import 'package:devapp/config.dart';
import 'package:devapp/helper.dart';
import 'package:flutter/material.dart';

/* Form submission example

  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'password': TextEditingController(),
    'email': TextEditingController(),
    'number': TextEditingController(),
    'numberGe0': TextEditingController(),
    'numberGt0': TextEditingController(),
  };

  Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputBox()
        ...
      ]
  )

  ElevatedButton(
    onPressed: () {
      if (_formKey.currentState?.validate() ?? false) {
          // Collect all form values
          final formData = _controllers.map((key, controller) {
            return MapEntry(key, controller.text);
          });

          formData['key_name'] = your_value;

          print(formData);
      }
    }
  )

  * SingleChildScrollView: This widget allows its child to scroll when the content exceeds the available space.
  body: SingleChildScrollView(
    child: Column(
      children: [
        // Your widgets here
      ],
    ),
  )
*/

// Label
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
Input text, password, textarea etc:

InputBox(
  outlineLabel: 'Username',
  inlineLabel: 'Enter your name',
  controller: TextEditingController(),
  hintTxt: 'e.g. John Doe',
  validationRule: 'required',
)

InputBox(
  outlineLabel: 'Password',
  inlineLabel: 'Enter password',
  isPassword: true,
  controller: TextEditingController()
  validationRule: 'required|password',
)
*/
class InputBox extends StatefulWidget {
  final String? outlineLabel;
  final String? inlineLabel;
  final TextEditingController? controller;
  final bool? isPassword;
  final String? hintTxt;
  final String? errorText;

  final int? borderRadius;
  final int? maxLines;
  final TextStyle textStyle;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  final bool? readOnly;
  final bool? enabled;
  final String? validationRule;
  final bool? showErrorTips;

  const InputBox({
    super.key,
    this.outlineLabel,
    this.inlineLabel,
    this.isPassword,
    this.controller,
    this.hintTxt,
    this.errorText,
    this.borderRadius,
    this.maxLines,
    this.textStyle = const TextStyle(),
    this.keyboardType,
    this.prefixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.validationRule,
    this.showErrorTips = true
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends BaseState<InputBox> {
  bool obscureText = true;

  String? validateInput(String? value) {
    if (widget.validationRule == null) return null;

    final rules = widget.validationRule!.split('|');
    for (final rule in rules) {
      switch (rule) {
        case 'required':
          if (!isValidValue(value)) {
            return defaultLang.getVal('required_error');
          }
          break;
        case 'email':
          if (!isValidEmail(value)) {
            return defaultLang.getVal('email_error');
          }
          break;
        case 'password':
          if (!isValidPassword(value)) {
            return defaultLang.getVal('password_error');
          }
          break;
        case 'number':
          if (!isValidNumber(value)) {
            return defaultLang.getVal('number_error');
          }
          break;
        case 'ge0':
          if (!isValidNumber(value)) {
            return defaultLang.getVal('number_error');
          }
          else if (double.tryParse(value.toString().trim())! < 0) {
            return defaultLang.getVal('ge0_error');
          }
          break;
        case 'gt0':
          if (!isValidNumber(value)) {
            return defaultLang.getVal('number_error');
          } 
          else if(double.tryParse(value.toString().trim())! <= 0) {
            return defaultLang.getVal('gt0_error');
          }
          break;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.isPassword ?? false;
    final double horizontalPadding = (widget.borderRadius != null
        ? widget.borderRadius! / 2 + 12
        : 12);

    return SizedBox(
      width: double.infinity,
      child:
        Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.outlineLabel != null)...[
              Padding(
                padding: EdgeInsets.only(left: horizontalPadding),
                child: Text(
                  widget.outlineLabel!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
            ],
            TextFormField(
              controller: widget.controller,
              maxLines: isPasswordField ? 1 : (widget.maxLines ?? 1),
              obscureText: isPasswordField ? obscureText : false,
              style: widget.textStyle,
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly ?? false,
              enabled: widget.enabled ?? true,
              validator: validateInput,
              decoration: InputDecoration(
                prefixIcon: widget.prefixIcon,
                labelText: (widget.inlineLabel?.isNotEmpty ?? false)
                    ? widget.inlineLabel
                    : null,
                hintText: (widget.hintTxt?.isNotEmpty ?? false)
                    ? widget.hintTxt
                    : null,
                errorText: widget.errorText,
                errorStyle: ((widget.showErrorTips == false)?TextStyle(fontSize: 0, height: 0): TextStyle(color: AppConfig.hexCode('red'))),
                filled: true,
                fillColor: AppConfig.hexCode('white'),
                hoverColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: horizontalPadding,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      (widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('gray'), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      (widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color:AppConfig.hexCode('gray'), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      (widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('gray'), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      (widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('darkred'), width: 2),
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
          ]
        )
    );
  }
}

/* 
CheckBox Options:

bool? _agreeValue = false;

FormField<bool>(
  validator: (value) {
    if (value != true) {
      return 'Please Select This Option';
    }
    return null;
  },
  builder: (field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckBox(
          inlineLabel: 'Keep me login',
          value: _agreeValue ?? false,
          onChanged: (value) {
            setState(() {
              _agreeValue = value;
              field.didChange(value);
            });
          },
        ),
        if (field.hasError)...[
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Text(
                field.errorText!,
                style: TextStyle(color: AppConfig.hexCode('red'), fontSize: 12),
              ),
            )
        ]
      ]
    );
  }
)
*/
class CheckBox extends StatefulWidget {
  final String? inlineLabel;
  final bool? value; //The value of the radio button
  final ValueChanged<bool?> onChanged; // The callback for value change

  const CheckBox({
    super.key,
    this.inlineLabel,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
        CheckboxListTile(
          title: Text(widget.inlineLabel ?? 'Default Label'),
          value: widget.value,
          onChanged: widget.onChanged,
          activeColor: AppConfig.hexCode('primary'),
          hoverColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0)
        )
    );
  }
}

/* 
Raido Options:

String? _selectedValue = 'A';

FormField<String>(
  validator: (value) {
    if (_selectedValue == null || _selectedValue.toString().isEmpty) {
      return 'Please Select One Option';
    }
    return null;
  },
  builder: (field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioBox<String>(
          inlineLabel: "Option A",
          value: "A",
          groupValue: _selectedValue, // Bind to group value
          onChanged: (value) {
            setState(() {
              _selectedValue = value; // Update selected value when option changes
              field.didChange(value);
            });
          },
        ),

        RadioBox<String>(
          inlineLabel: "Option B",
          value: "B",
          groupValue: _selectedValue, // Bind to group value
          onChanged: (value) {
            setState(() {
              _selectedValue = value; // Update selected value when option changes
              field.didChange(value);
            });
          },
        ), 

        if (field.hasError)...[
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Text(
                field.errorText!,
                style: TextStyle(color: AppConfig.hexCode('red'), fontSize: 12),
              ),
            )
        ]
      ]
    );
})
*/
class RadioBox<T> extends StatefulWidget {
  final String? inlineLabel;
  final T value; // The value of the radio button
  final T? groupValue; // The current group value, which can be any type
  final ValueChanged<T?> onChanged; // The callback for value change

  const RadioBox({
    super.key,
    this.inlineLabel,
    required this.value,
    this.groupValue,
    required this.onChanged,
  });

  @override
  State<RadioBox> createState() => _RadioBoxState<T>();
}

class _RadioBoxState<T> extends State<RadioBox<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
        RadioListTile<T>(
          title: Text(widget.inlineLabel ?? 'Default Label'),
          value: widget.value,
          groupValue: widget.groupValue, 
          onChanged: widget.onChanged,
          activeColor: AppConfig.hexCode('primary'),
          hoverColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.symmetric(horizontal: 0)
        ) 
    );
  }
}