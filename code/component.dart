import 'dart:io';
import 'package:devapp/base.dart';
import 'package:devapp/config.dart';
import 'package:devapp/helper.dart';
import 'package:file_picker/file_picker.dart';
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
  List<File> selectedFiles = [];

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
          doSubmit();
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

  Future<void> doSubmit() async {
    // Collect all form values
    final formData = _controllers.map((key, controller) {
      return MapEntry(key, controller.text);
    });

    formData['key_name'] = your_value;

    Map<String, File> formFiles = {};
    if (selectedFiles.isNotEmpty) {
      for (int i = 0; i < selectedFiles.length; i++) {
        formFiles['file$i'] = selectedFiles[i]; // Change 'file$i' if needed
      }
    }

    var response = await requestAPI(uploadUrl, body: body, files: formFiles);
  }
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
  final String? hintTxt;
  final TextEditingController? controller;

  final bool? isPassword;
  final bool? isDate;
  final bool? isTime;

  final int? borderRadius;
  final int? maxLines;
  final TextStyle textStyle;

  final Icon? prefixIcon;
  final bool? readOnly;
  final bool? enabled;
  final String? validationRule;
  final bool? showErrorTips;

  const InputBox({
    super.key,
    this.outlineLabel,
    this.inlineLabel,
    this.hintTxt,
    this.controller,

    this.isPassword,
    this.isDate,
    this.isTime,
  
    this.borderRadius,
    this.maxLines,
    this.textStyle = const TextStyle(),

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
  bool _obscureText = true;

  String? _validateInput(String? value) {
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

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller?.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Form.of(context).validate();
      });
    }
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year, now.month, now.day, picked.hour, picked.minute,
      );

      setState(() {
        widget.controller?.text = "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Form.of(context).validate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.isPassword ?? false;
    final bool isDateField = widget.isDate ?? false;
    final bool isTimeField = widget.isTime ?? false;
    final double horizontalPadding = (widget.borderRadius != null ? (widget.borderRadius! / 2 + 12): 12);

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
                )
              ),
              const SizedBox(height: 8),
            ],
            TextFormField(
              controller: widget.controller,
              maxLines: (isPasswordField ? 1 : (widget.maxLines ?? 1)),
              obscureText: (isPasswordField ? _obscureText : false),
              style: widget.textStyle,
              readOnly: ((isDateField || isTimeField) ? true : (widget.readOnly ?? false)),
              enabled: widget.enabled ?? true,
              validator: _validateInput,
              onTap: (isDateField ? _showDatePicker : (isTimeField ? _showTimePicker : null)),
              onChanged: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    Form.of(context).validate();
                });
              },
              decoration: InputDecoration(
                labelText: ((widget.inlineLabel?.isNotEmpty ?? false) ? widget.inlineLabel : null),
                hintText: ((widget.hintTxt?.isNotEmpty ?? false) ? widget.hintTxt: null),
                
                errorStyle: ((widget.showErrorTips == false)?TextStyle(fontSize: 0, height: 0): TextStyle(color: AppConfig.hexCode('red'))),
                
                filled: true,
                fillColor: AppConfig.hexCode('white'),
                hoverColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('gray'), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color:AppConfig.hexCode('gray'), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('gray'), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('darkred'), width: 2),
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: (
                  isPasswordField ? 
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : 
                    (isDateField ?
                      (widget.controller!.text.isNotEmpty ? 
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          widget.controller?.clear();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Form.of(context).validate();
                          });
                        }
                      )
                      :
                      Icon(Icons.calendar_today)) : (
                      isTimeField ? 
                      (
                        widget.controller!.text.isNotEmpty ? 
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            widget.controller?.clear();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Form.of(context).validate();
                            });
                          }
                        )
                        :
                        Icon(Icons.access_time)
                      ): null))
                  )
              ),
            ),
            const SizedBox(height: 15)
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
  final bool? value; //The value of the checkbox button
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
          title: Text(widget.inlineLabel ?? ''),
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
          title: Text(widget.inlineLabel ?? ''),
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

/*
Files Picker 

List<File> selectedFiles = []; 

FilesPicker(
  onFilesSelected: (List<File> files) {
    setState(() {
      selectedFiles = files;
    });
  }, // Pass callback to child
)

Map<String, File> formFiles = {};
if (selectedFiles.isNotEmpty) {
  for (int i = 0; i < selectedFiles.length; i++) {
    formFiles['file$i'] = selectedFiles[i]; // Change 'file$i' if needed
  }
}
*/
class FilesPicker extends StatefulWidget {
  final String? buttonLabel; // Label for the button
  final ValueChanged<List<File>>? onFilesSelected; // Callback to pass selected files to the parent

  const FilesPicker({
    super.key,
    this.buttonLabel = 'Select File(s)',
    this.onFilesSelected,
  });

  @override
  State<FilesPicker> createState() => _FilesPickerState();
}

class _FilesPickerState extends State<FilesPicker> {
  final List<File> _selectedFiles = [];
  final List<String> _selectedFileNames = [];

  void _showFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        //_selectedFiles.clear();
        //_selectedFileNames.clear();

        for (var file in result.files) {
          if (file.path != null) {
            _selectedFiles.add(File(file.path!));
            _selectedFileNames.add(file.name);
          }
        }
      });

      widget.onFilesSelected?.call(_selectedFiles);
    }
  }

  void _deleteFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _selectedFileNames.removeAt(index);
    });

    widget.onFilesSelected?.call(_selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.hexCode('primary'),
                foregroundColor: AppConfig.hexCode('white'),
                minimumSize: Size(0, 48)
              ),
              onPressed: _showFilePicker,
              child: Text(widget.buttonLabel!),
            ),
            if (_selectedFiles.isNotEmpty)...[
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConfig.hexCode('gray'), width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _selectedFiles.length,
                      separatorBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Divider(
                          color: AppConfig.hexCode('gray'),
                          thickness: 1,
                          height: 1,
                          indent: 0,
                          endIndent: 0
                        ),
                      ),
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(_selectedFileNames[i], overflow: TextOverflow.ellipsis),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppConfig.hexCode('red')),
                              onPressed: () => _deleteFile(i)
                            ),
                          ]
                        );
                      }
                    )
                  ]
                )
              )
            ],
            const SizedBox(height: 15)
          ]
        )
    );
  }
}