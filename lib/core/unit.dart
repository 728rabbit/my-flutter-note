import 'dart:io';
import 'dart:async';
import 'package:devapp/core/base.dart';
import 'package:devapp/core/config.dart';
import 'package:devapp/core/helper.dart';
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

Future<void> doSubmit() async {
  // Collect all form values
  final formData = _controllers.map((key, controller) {
    return MapEntry(key, controller.text);
  });

  formData['key_name'] = your_value;

  Map<String, File> formFiles = {};
  if (selectedFiles.isNotEmpty) {
    for (int i = 0; i < selectedFiles.length; i++) {
      formFiles['file_$i'] = selectedFiles[i]; // Change 'file$i' if needed
    }
  }

  showBusy(context);
  var response = await requestAPI(uploadUrl, body: body, files: formFiles);

  // Use a stored function instead of context if possible
  if (!mounted) return; // Ensure the widget is still in the widget tree
  hideBusy(context);
}
*/
// Button
class PrimaryBtn extends StatefulWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final bool enableDelay;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PrimaryBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.enableDelay = true,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.width = double.infinity,
    this.height = 46,
    this.borderRadius = 2,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<PrimaryBtn> createState() => _PrimaryBtnState();
}

class _PrimaryBtnState extends State<PrimaryBtn> {
  bool _isProcessing = false;

  Future<void> _handleTap() async {
    if (_isProcessing || widget.onPressed == null) return;
    setState(() => _isProcessing = true);
    try {
      await widget.onPressed!();
    } catch (e) {
      debugPrint('PrimaryBtn error: $e');
    } finally {
      if(widget.enableDelay) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppConfig.hexCode('primary');
    final fgColor = widget.foregroundColor ?? AppConfig.hexCode('white');

    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return bgColor.withValues(alpha: 100);
              }
              return bgColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return fgColor.withValues(alpha: 100);
              }
              return fgColor;
            },
          ),
          minimumSize: WidgetStateProperty.all(Size(widget.width, widget.height)),
          padding: WidgetStateProperty.all(widget.padding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        ),
        onPressed: _isProcessing ? null : _handleTap,
        child: _isProcessing
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Text(
                widget.label,
                style: TextStyle(fontSize: widget.fontSize),
              )
      )
    );
  }
}

// Label
class LableTxt extends StatelessWidget {
  final String txt;
  final TextStyle defaultStyle;

  const LableTxt({
    super.key,
    required this.txt,
    this.defaultStyle = const TextStyle(
      fontWeight: FontWeight.normal
    )
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(txt, style: defaultStyle)
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
    this.textStyle = const TextStyle(fontSize: 14),

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
            return defaultLang.getVal('error_required');
          }
          break;
        case 'email':
          if (!isValidEmail(value)) {
            return defaultLang.getVal('error_email_format');
          }
          break;
        case 'password':
          if (!isValidPassword(value)) {
            return defaultLang.getVal('error_password_format');
          }
          break;
        case 'number':
          if (!isValidNumber(value)) {
            return defaultLang.getVal('error_number_format');
          }
          break;
        case 'ge0':
          if (!isValidNumber(value)) {
            return defaultLang.getVal('error_number_format');
          }
          else if (double.tryParse(value.toString().trim())! < 0) {
            return defaultLang.getVal('error_ge0_format');
          }
          break;
        case 'gt0':
          if (!isValidNumber(value)) {
            return defaultLang.getVal('error_number_format');
          } 
          else if(double.tryParse(value.toString().trim())! <= 0) {
            return defaultLang.getVal('error_gt0_format');
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
          children: [
            if (widget.outlineLabel != null)...[
              Padding(
                padding: EdgeInsets.only(left: widget.borderRadius != null ? horizontalPadding : 0),
                child: Text(
                  widget.outlineLabel!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ),
              const SizedBox(height: 4),
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
                isDense: true,
                labelText: ((widget.inlineLabel?.isNotEmpty ?? false) ? widget.inlineLabel : null),
                hintText: ((widget.hintTxt?.isNotEmpty ?? false) ? widget.hintTxt: null),
                
                errorStyle: ((widget.showErrorTips == false)?TextStyle(fontSize: 0, height: 0): TextStyle(color: AppConfig.hexCode('darkred'), fontSize: 12, fontWeight: FontWeight.bold)),
                errorMaxLines: 3,

                filled: true,
                fillColor: AppConfig.hexCode('white'),
                hoverColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: horizontalPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('gray'), width: 2)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color:AppConfig.hexCode('gray'), width: 2)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('gray'), width: 2)
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble()),
                  borderSide: BorderSide(color: AppConfig.hexCode('red'), width: 2)
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: (
                  isPasswordField ? 
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent
                      ),
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility
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
            const SizedBox(height: 16)
          ]
        )
    );
  }
}

/* 
CheckBox Options:

bool _checkboxValue = false;

FormField<bool>(
  validator: (value) {
    if (_checkboxValue != true) {
      return 'Please Select This Option';
    }
    return null;
  },
  builder: (field) {
    return Column(
      children: [
        CheckBox(
          inlineLabel: 'Keep me login',
          value: _checkboxValue ?? false,
          onChanged: (value) {
            setState(() {
              _checkboxValue = value;
              field.didChange(value);
              field.validate();
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
          dense: true,
          title: Text(widget.inlineLabel ?? '', style: TextStyle(fontSize: 14)),
          value: widget.value,
          onChanged: widget.onChanged,
          activeColor: AppConfig.hexCode('primary'),
          hoverColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
        )
    );
  }
}

/* 
Raido Options:

String _radioValue = 'A';

FormField<String>(
  validator: (value) {
    if (_radioValue.isEmpty) {
      return 'Please Select One Option';
    }
    return null;
  },
  builder: (field) {
    return Column(
      children: [
        RadioBox<String>(
          inlineLabel: "Option A",
          value: "A",
          groupValue: _radioValue, // Bind to group value
          onChanged: (value) {
            setState(() {
              _radioValue = ((value != null)?value.toString():''); // Update selected value when option changes
              field.didChange(value);
              field.validate();
            });
          },
        ),

        RadioBox<String>(
          inlineLabel: "Option B",
          value: "B",
          groupValue: _radioValue, // Bind to group value
          onChanged: (value) {
            setState(() {
              _radioValue = ((value != null)?value.toString():''); // Update selected value when option changes
              field.didChange(value);
              field.validate();
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
          dense: true,
          title: Text(widget.inlineLabel ?? '', style: TextStyle(fontSize: 14)),
          value: widget.value,
          groupValue: widget.groupValue, 
          onChanged: widget.onChanged,
          activeColor: AppConfig.hexCode('primary'),
          hoverColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)
        ) 
    );
  }
}

/* Select Options:
String _selectedValue = '';

FormField<String>(
    validator: (value) {
      if (_selectedValue.isEmpty) {
        return 'Please Select This Option';
      }
      return null;
    },
    builder: (field) {
      return Column(
        children: [
          SelectBox(
            items: [
              {'id': 1, 'name': 'Apple'},
              {'id': 2, 'name': 'Banana'},
              {'id': 3, 'name': 'Cherry'},
            ],
            //defaultValue: 2,
            errorText: field.errorText,
            onChanged: (value) {
              _selectedValue = ((value != null)?value.toString():'');
              field.didChange(value);
              field.validate();
            }
          )
        ]
      );
    }
)
*/
class SelectBox extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final dynamic defaultValue;
  final void Function(String?)? onChanged;
  final String? hintText;
  final String? errorText;
  final int? borderRadius;

  const SelectBox({
    super.key,
    required this.items,
    this.defaultValue,
    this.onChanged,
    this.hintText = 'Please select',
    this.errorText,
    this.borderRadius,
  });

  @override
  State<SelectBox>createState() => _SelectBoxState();
}

class _SelectBoxState extends BaseState<SelectBox> {
  Map<String, dynamic>? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      _selectedItem = widget.items.firstWhere(
        (item) => (item['id'].toString() == widget.defaultValue.toString()),
        orElse: () => {}
      );
      if (_selectedItem!.isEmpty) _selectedItem = null;
    }
  }

  void _showSelectPicker() {
    final List<Map<String, dynamic>> allItems = [
      {'id': null, 'name': widget.hintText},
      ...widget.items
    ];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: allItems.map((item) {
            final bool isSelected = item['id'] == _selectedItem?['id'];
            return ListTile(
              title: Text(item['name'], style: TextStyle(color: (isSelected ? AppConfig.hexCode('white') : AppConfig.hexCode('black')))),
              trailing: isSelected ? Icon(Icons.check, color: AppConfig.hexCode('white')) : null,
              selected: isSelected,
              selectedTileColor: AppConfig.hexCode('primary'),
              onTap: () {
                setState(() {
                  _selectedItem = item;
                });
                widget.onChanged?.call(item['id']?.toString());
                
                Navigator.pop(context);
              }
            );
          }).toList()
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = (widget.borderRadius != null ? (widget.borderRadius! / 2 + 12): 12);

    return InkWell(
      onTap: _showSelectPicker,
      child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
              height: 39,
              decoration: BoxDecoration(
                color: AppConfig.hexCode('white'),
                border: Border.all(color: (widget.errorText != null ? AppConfig.hexCode('red') : AppConfig.hexCode('gray')), width: 2),
                borderRadius: BorderRadius.circular((widget.borderRadius ?? 4).toDouble())
              ),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedItem?['name'] ?? widget.hintText,
                        style: TextStyle(
                          fontSize: 14
                        )
                      )
                    ),
                    Icon(Icons.arrow_drop_down)
                  ]
                )
            ),
            if (widget.errorText != null)...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: Text(
                    widget.errorText!,
                    style: TextStyle(color: AppConfig.hexCode('darkred'), fontSize: 12)
                  )
                )
            ]
          ]
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
    formFiles['file_$i'] = selectedFiles[i];
  }
}
*/
class FilesPicker extends StatefulWidget {
  final String buttonLabel;
  final ValueChanged<List<File>>? onFilesSelected;

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
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.hexCode('primary'),
                foregroundColor: AppConfig.hexCode('white'),
                minimumSize: Size(0, 46),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )*/
              ),
              onPressed: _showFilePicker,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add), // Plus icon
                  SizedBox(width: 2),
                  Text(widget.buttonLabel, style: TextStyle(fontSize: 14)),
                ],
              )
            ),
            if (_selectedFiles.isNotEmpty)...[
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConfig.hexCode('gray'), width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
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
                        )
                      ),
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(_selectedFileNames[i], overflow: TextOverflow.ellipsis),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, size: 18, color: AppConfig.hexCode('darkred')),
                              onPressed: () => _deleteFile(i)
                            )
                          ]
                        );
                      }
                    )
                  ]
                )
              )
            ],
            const SizedBox(height: 16)
          ]
        )
    );
  }
}