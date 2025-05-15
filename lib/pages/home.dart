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
  Map<String, List<Map<String, String>>> _events = {};
  DateTime _focusedMonth = DateTime.now();
  DateTime _currentDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  // TextEditingController 為每個輸入欄位
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(text: 'John Ma'),
    'password': TextEditingController(text: 'Abc123'),
    'date': TextEditingController(text: '1992-04-11'),
    'time': TextEditingController(text: '17:15'),
    'email': TextEditingController(text: 'test@demo.com'),
    'address': TextEditingController(),
    'telephone': TextEditingController(),
    'numberGe0': TextEditingController(),
    'numberGt0': TextEditingController(),
  };

  String _selectedValue = '2';
  bool? _checkboxValue = true; 
  String _radioValue = '';
  List<File> selectedFiles = [];

  final htmlcontent = """
    <h1>Term 1: Introduction</h1>
    <p>This is the introduction paragraph of the terms and conditions.</p>
    <h2>Term 2: Usage</h2>
    <p>You agree to use our service in accordance with these terms.</p>
    <h3>Term 3: Privacy</h3>
    <p>We respect your privacy and do not share your personal information.</p>
    <p><a href="https://hk.yahoo.com" target="_black">Click here for more information</a></p>
    """;
  
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
    final currentSelectedLang = defaultLang.getCode();

    return AppLayout(
      currentIndex: 0, 
      childWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LableTxt(
              txt: '${defaultLang.getVal('welcome')}, ${authedUserInfo('name')}',
              defaultStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            LableTxt(txt: '1. 轉換語言'),
            const Divider(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: 
                    Padding(
                      padding: EdgeInsets.only(right: 5), 
                      child: 
                        PrimaryBtn(
                          label: 'Eng', 
                          onPressed: () async {
                            AppLang().setVal('en');
                          }, 
                          backgroundColor: (!isValueMatch(currentSelectedLang, 'en'))?AppConfig.hexCode('gray'):null,
                          enableDelay: false
                        )
                      )
                ),
                Expanded(
                  child: 
                    Padding(
                      padding: EdgeInsets.only(left: 5), 
                      child: 
                        PrimaryBtn(
                          label: '繁體', 
                          onPressed: () async {
                            AppLang().setVal('zh-hant');
                          }, 
                          backgroundColor: (!isValueMatch(currentSelectedLang, 'zh-hant'))?AppConfig.hexCode('gray'):null,
                          enableDelay: false
                        )
                      )
                )
              ],
            ),

            const SizedBox(height: 20),
            LableTxt(txt: '2. 圖片輪播'),
            const Divider(),
            SizedBox(
              child: ImageSlider( 
                imageUrls: [
                    'https://picsum.photos/id/1015/400/200',
                    'https://picsum.photos/id/1025/400/200',
                    'https://picsum.photos/id/1035/400/200',
                  ]
              )
            ),

            const SizedBox(height: 20),
            LableTxt(txt: '3. 事件日曆'),
            const Divider(),
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

            const SizedBox(height: 20),
            LableTxt(txt: '4. 基本表格'),
            const Divider(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputBox(
                    outlineLabel: defaultLang.getVal('user_id'),
                    controller: _controllers['username']!,
                    validationRule: 'required',
                  ),

                  InputBox(
                    outlineLabel: defaultLang.getVal('password'),
                    isPassword: true,
                    controller: _controllers['password']!,
                    validationRule: 'required|password'
                  ),

                  LableTxt(txt: defaultLang.getVal('gender'), defaultStyle:TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  FormField<String>(
                    validator: (value) {
                      if (_radioValue.isEmpty) {
                        return defaultLang.getVal('error_select_option');
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioBox<String>(
                            inlineLabel: defaultLang.getVal('gender_male'),
                            value: "M",
                            groupValue: _radioValue,
                            onChanged: (value) {
                              setState(() {
                                _radioValue = ((value != null)?value.toString():'');
                                field.didChange(value);
                                field.validate();
                              });
                            },
                          ),

                          RadioBox<String>(
                            inlineLabel: defaultLang.getVal('gender_female'),
                            value: "F",
                            groupValue: _radioValue,
                            onChanged: (value) {
                              setState(() {
                                _radioValue = ((value != null)?value.toString():'');
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
                                  style: TextStyle(color: AppConfig.hexCode('darkred'), fontSize: 12),
                                ),
                              )
                          ]
                        ]
                      );
                  }),
                  const SizedBox(height: 16),

                  InputBox(
                    outlineLabel: defaultLang.getVal('birth_date'),
                    hintTxt: 'e.g. 2000-02-12',
                    isDate: true,
                    controller: _controllers['date']!,
                    validationRule: 'required|date'
                  ),

                  InputBox(
                    outlineLabel: defaultLang.getVal('birth_time'),
                    isTime: true,
                     controller: _controllers['time']!,
                  ),

                  InputBox(
                    outlineLabel: defaultLang.getVal('email'),
                    controller: _controllers['email']!,
                    validationRule: 'required|email'
                  ),

                  InputBox(
                    outlineLabel: defaultLang.getVal('telephone'),
                    controller: _controllers['telephone']!,
                    validationRule: 'required|number'
                  ),

                  LableTxt(txt: defaultLang.getVal('district'), defaultStyle:TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  FormField<String>(
                    validator: (value) {
                      if (_selectedValue.isEmpty) {
                        return defaultLang.getVal('error_select_option');
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectBox(
                            items: [
                              {'id': 1, 'name': defaultLang.getVal('district_1') },
                              {'id': 2, 'name': defaultLang.getVal('district_2') },
                              {'id': 3, 'name': defaultLang.getVal('district_3') },
                            ],
                            hintText: defaultLang.getVal('please_select'),
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
                  const SizedBox(height: 16),

                  InputBox(
                    outlineLabel: defaultLang.getVal('address'),
                    controller: _controllers['address']!,
                    validationRule: 'required',
                    maxLines: 3,
                  ),

                  FilesPicker(
                    buttonLabel: defaultLang.getVal('attachment'),
                    onFilesSelected: (List<File> files) {
                      setState(() {
                        selectedFiles = files;
                      });
                    }, // Pass callback to child
                  ),

                  FormField<bool>(
                    validator: (value) {
                      if (_checkboxValue != true) {
                        return defaultLang.getVal('error_select_option');
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckBox(
                            inlineLabel: defaultLang.getVal('agree_tnc'),
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
                                  style: TextStyle(color: AppConfig.hexCode('darkred'), fontSize: 12),
                                ),
                              )
                          ]
                        ]
                      );
                    }
                  ),
                  const SizedBox(height: 16),

                  PrimaryBtn(
                    label: defaultLang.getVal('btn_submit'),
                    borderRadius: 20,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        doSubmit();
                      }
                      else {
                        showTips(context, defaultLang.getVal('error_required_all'));
                      }
                    }
                  ),

                  const SizedBox(height: 20),
                  LableTxt(txt: '5. 其他'),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () {
                        showAlert(context, defaultLang.getVal('hello'));
                    },
                    child: const Text('Alert Message'),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                        showConfirm(context, 'Are your sure delete this item?', yesCallback: () => {}, noCallback: () => {});
                    },
                    child: const Text('Confirm Dialog'),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                        showHtmlContent(context, htmlcontent, closeCallback: () => {});
                    },
                    child: const Text('Html Content Dialog'),
                  )
                ],
              ),
            ),
          ]
        )
    );
  }
}
