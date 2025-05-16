import 'package:base_app/core/base.dart';
import 'package:base_app/core/helper.dart';
import 'package:base_app/core/unit.dart';
import 'package:base_app/layout.dart';
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

  Future<void> doLogin() async {
    final String userId = _controllers['username']!.text;
    final String userPassword = _controllers['password']!.text;
    if(isValueMatch(userId, 'admin') && isValueMatch(userPassword, 'Abc123')) {
      Map<String, dynamic> userData = {
        'id': 1,
        'name': 'John Doe',
        'email': 'johndoe@example.com'
      };
      await setLocalData('authedUser', userData);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
    else {
      showTips(context, defaultLang.getVal('error_login_not_match'));
    }
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputBox(
                    outlineLabel: defaultLang.getVal('user_id'),
                    controller: _controllers['username']!,
                    validationRule: 'required',
                    borderRadius: 24
                  ),
                  InputBox(
                    outlineLabel: defaultLang.getVal('password'),
                    isPassword: true,
                    controller: _controllers['password']!,
                    validationRule: 'required',
                    borderRadius: 24
                  ),
                  const SizedBox(height: 10),
                  PrimaryBtn(
                    label: defaultLang.getVal('btn_login'), 
                    borderRadius: 20,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        doLogin();
                      }
                      else {
                        showTips(context, defaultLang.getVal('error_required_all'));
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
