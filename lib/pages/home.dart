import 'dart:io';
import 'package:devapp/core/base.dart';
import 'package:devapp/core/calendar.dart';
import 'package:devapp/core/imageslider.dart';
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

  Map<String, List<Map<String, String>>> _events = {};
  DateTime _focusedMonth = DateTime.now();
  DateTime _currentDate = DateTime.now();

  Future<Map<String, List<Map<String, String>>>> fetchEvents(DateTime newMonth) async {
    // Simulate delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate the data returned from the API
    if(newMonth.month.toInt() == 5) {
      return {
        '2025-05-14': [
          {
            'title': '看牙醫',
            'description': '下午 3 點在尖沙咀診所',
          }
        ],
        '2025-05-20': [
          {
            'title': '會議',
            'description': '與客戶會議，Zoom ID: 123-456-789',
          },
          {
            'title': '晚餐',
            'description': '與朋友晚餐，在銅鑼灣某餐廳',
          }
        ]
      };
    }
    else if(newMonth.month.toInt() == 6) {
      return {
        '2025-06-01': [
          {
            'title': '旅行',
            'description': '去日本旅行，早上 8 點機',
          }
        ]
      };
    }
    else {
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents(_focusedMonth);  // 載入資料
  }

  Future<void> _loadEvents(DateTime newMonth) async {
    final data = await fetchEvents(newMonth);
    setState(() {
      _events = data;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final dateKey = '${_currentDate.year.toString().padLeft(4, '0')}-'
                '${_currentDate.month.toString().padLeft(2, '0')}-'
                '${_currentDate.day.toString().padLeft(2, '0')}'; 
    final todayEvents = _events[dateKey] ?? [];

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

            CalendarWidget(
              focusedMonth: _focusedMonth,
              events: _events,
              showLang: 'zh',
              onMonthChanged: (newMonth) {
                setState(() {
                  _focusedMonth = newMonth;
                });
                _loadEvents(newMonth);
              },
              onDateSelected: (date) {
                setState(() {
                  _currentDate = date;
                });
              },
            ),
            ...[
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_currentDate.year.toString().padLeft(4, '0')}年${_currentDate.month.toString().padLeft(2, '0')}月${_currentDate.day.toString().padLeft(2, '0')}日',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  if(todayEvents.isEmpty)...[
                    const Text('No events today', style: TextStyle(color: Colors.grey))
                  ],
                  ...todayEvents.map((event) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(event['title'] ?? ''),
                    subtitle: Text(event['description'] ?? ''),
                    onTap: () {
                      print(event);
                    },
                  )),
                ],
              )
            ],



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
