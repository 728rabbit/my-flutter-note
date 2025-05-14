import 'package:devapp/core/base.dart';
import 'package:devapp/core/helper.dart';
import 'package:devapp/core/unit.dart';
import 'package:devapp/layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      childWidget: 
        SizedBox(
        width: double.infinity,
        height: (MediaQuery.of(context).size.height  - 50),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // 垂直置中
              children: [
                InputBox(
                    outlineLabel: '帳戶ID',
                    controller: _controllers['username']!,
                    validationRule: 'required',
                  ),
                  InputBox(
                    outlineLabel: '密碼',
                    isPassword: true,
                    controller: _controllers['password']!,
                    validationRule: 'required'
                  ),
                  const SizedBox(height: 10),
                  PrimaryBtn(
                    label: '登入', 
                    borderRadius: 21,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                          Map<String, dynamic> userData = {
                            'id': 1,
                            'name': 'John Doe',
                            'email': 'johndoe@example.com'
                          };
                          await setLocalData('authedUser', userData);
                          Navigator.pushReplacementNamed(context, '/home');
                      }
                      else {
                        showTips(context, '請正確填寫帳戶ID&密碼!');
                      }
                    }
                  )
              ]
            )
          )
        )
      ),
      currentIndex: -1,
      includedHeaderFooter: false,
      backgroundImage: 'assets/images/background.jpg',
    ); 
  }
}
