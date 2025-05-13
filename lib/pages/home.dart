import 'dart:io';
import 'package:devapp/core/base.dart';
import 'package:devapp/core/lang.dart';
import 'package:devapp/layout.dart';
import 'package:devapp/core/unit.dart';
import 'package:devapp/core/config.dart';
import 'package:devapp/core/helper.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final htmlcontent = """
                      <h1>Term 1: Introduction</h1>
                      <p>This is the introduction paragraph of the terms and conditions.</p>
                      <h2>Term 2: Usage</h2>
                      <p>You agree to use our service in accordance with these terms.</p>
                      <h3>Term 3: Privacy</h3>
                      <p>We respect your privacy and do not share your personal information.</p>
                      <p><a href="https://hk.yahoo.com" target="_black">Click here for more information</a></p>
                      """;
  final leftWidget = Container(
      color: Colors.red,
      height: 200,
      child: Center(child: Text('Left Content', style: TextStyle(color: Colors.white))),
    );

    final rightWidget = Container(
      color: Colors.blue,
      height: 200,
      child: Center(child: Text('Right Content', style: TextStyle(color: Colors.white))),
    );

  final _formKey = GlobalKey<FormState>();
  // TextEditingController 為每個輸入欄位
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(text: 'John Ma'),
    'password': TextEditingController(text: 'Abc123'),
    'date': TextEditingController(text: '2025-04-11'),
    'time': TextEditingController(text: '17:15'),
    'email': TextEditingController(text: 'test@demo.com'),
    'number': TextEditingController(text: '123'),
    'numberGe0': TextEditingController(),
    'numberGt0': TextEditingController(),
  };

  bool? _checkboxValue = true; 
  String _radioValue = '';
  String _selectedValue = '2';

   List<File> selectedFiles = [];
  

  Future<void> doSubmit() async {
    // Collect all form values
    final formData = _controllers.map((key, controller) {
      return MapEntry(key, controller.text);
    });

    Map<String, File> formFiles = {};
    if (selectedFiles.isNotEmpty) {
      for (int i = 0; i < selectedFiles.length; i++) {
        formFiles['file_$i'] = selectedFiles[i]; // Change 'file$i' if needed
      }
    }

    showBusy(context);
    var response = await requestAPI(
      'http://localhost:8000/myprojects/mylib/testupload.php', 
       body: formData, 
       files: formFiles,
       headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }
    );
    print(response);

    // Use a stored function instead of context if possible
    if (!mounted) return; // Ensure the widget is still in the widget tree
    hideBusy(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 0, 
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: ImageSlider( 
                imageUrls: [
                  'https://picsum.photos/id/1015/400/200',
                  'https://picsum.photos/id/1025/400/200',
                  'https://picsum.photos/id/1035/400/200',
                ]
            )
            )
            ,

            PrimaryBtn(
              label: 'Delete',
              onPressed: () => {},
            ),

             Form(
              key: _formKey,
              child: Column(
                children: [
                  InputBox(
                    outlineLabel: 'Username',
                    controller: _controllers['username']!,
                    validationRule: 'required',
                  ),
                  InputBox(
                    outlineLabel: 'Password',
                    isPassword: true,
                    controller: _controllers['password']!,
                    validationRule: 'required|password'
                  ),

                  InputBox(
                    outlineLabel: 'Birth Day',
                    inlineLabel: 'Enter date',
                    isDate: true,
                    controller: _controllers['date']!,
                    validationRule: 'required|date'
                  ),

                  InputBox(
                    outlineLabel: 'Birth Time',
                    inlineLabel: 'Enter time',
                    isTime: true,
                     controller: _controllers['time']!,
                  ),


                  InputBox(
                    outlineLabel: 'Email',
                    inlineLabel: 'Enter email',
                    controller: _controllers['email']!,
                    validationRule: 'required|email'
                  ),

                   InputBox(
                    outlineLabel: 'Number',
                    inlineLabel: 'Enter number',
                    controller: _controllers['number']!,
                    validationRule: 'required|number'
                  ),

                  FormField<String>(
                    validator: (value) {
                      //_selectedValue = ((value != null)?value.toString():'');
                      print(_selectedValue);
                      if (_selectedValue.isEmpty) {
                        return 'Please Select This Option';
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectBox(
                            items: [
                              {'id': 1, 'name': 'Apple'},
                              {'id': 2, 'name': 'Banana'},
                              {'id': 3, 'name': 'Cherry'},
                            ],
                            defaultValue: _selectedValue.toString(),
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
                ),

                  FormField<bool>(
                      validator: (value) {
                        if (_checkboxValue != true) {
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
                    ),


                  FormField<String>(
                    validator: (value) {
                      if (_radioValue.isEmpty) {
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
                  }),
                
                  FilesPicker(
                    onFilesSelected: (List<File> files) {
                      setState(() {
                        selectedFiles = files;
                      });
                    }, // Pass callback to child
                  ),


                  ElevatedButton(
                    onPressed: () async {
                        
                      if (_formKey.currentState?.validate() ?? false) {
                        doSubmit();
                        // Submit form if validation passes
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Form Submitted!')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),


                  ElevatedButton(
                    onPressed: () {
                        AppLang().setVal('en');
                    },
                    child: const Text('English'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                        AppLang().setVal('zh-hant');
                    },
                    child: const Text('繁體中文'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                        showAlert(context, 'hello world');
                      
                    },
                    child: const Text('show alert'),
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}
