import 'package:flutter/material.dart';
import 'package:devapp/core/config.dart';
import 'package:devapp/core/helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // 控制密碼是否隱藏

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
         Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'), // 本地圖片
              fit: BoxFit.cover, // 填滿整個背景
            ),
          ),
          child: Center(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                // Image.asset('assets/image/mylogo.png', height: 100),
              Padding(
                padding: EdgeInsets.only(bottom: 20), // 👉 這裡是 padding
                child:
                  SizedBox(
                    width: double.infinity,
                    child: Text('aaaa',
                      style: TextStyle(
                        fontSize: 18,            // 字體大小
                        fontWeight: FontWeight.bold,  // 字體粗細
                        color: Colors.blue,      // 字體顏色
                        letterSpacing: 1.5,      // 字母間距
                        height: 1.5,             // 行高
                        fontFamily: 'Roboto',    // 字體
                      ),
                    ),
                  ),
              ),


              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: Colors.blue,
                  width: 100,
                  height: 100,
                  child: const Center(child: Text('右下角')),
                ),
              ),

              const SizedBox(width: double.infinity, height: 20),

                // 帳戶 ID
              SizedBox(
                width: double.infinity,
                child: 
                  TextField(
                    style: TextStyle(fontSize: 18),
                    maxLines: 1,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '帳戶 ID',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      
                    ),
                  ),
              ),

                const SizedBox(height: 20),

                // 密碼
                SizedBox(
                  width: double.infinity,
                  child: 
                  TextField(
                    controller: passwordController,
                    style: TextStyle(fontSize: 14),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: '密碼',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2), // Set the border color and width
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2), // Same border for focused state
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2), // Same border for enabled state
                      ),
                      suffixIcon: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent, // 如果有陰影也清除
                        ),
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  )
                ),

                const SizedBox(height: 10),

                // 忘記密碼
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // 忘记密码的功能
                    },
                    child: const Text('忘記密碼?'),
                  ),
                ),

                const SizedBox(height: 20),

                // 登入按鈕
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50), // width, height
                    ),
                    onPressed: () async {

             

                      // 登录的逻辑
                      if(!isValidValue(nameController.text) || !isValidValue(passwordController.text)) {
                          // 顯示 Snackbar 提示
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('請輸入帳戶 ID 和密碼'),
                              backgroundColor: Colors.red,
                            ),
                          );

                      }
                      /*else if(!_isValidEmail(nameController.text.trim())){
                        // 顯示 Snackbar 提示
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('請輸入有效的電子郵件地址'),
                              backgroundColor: Colors.red,
                            ),
                          );
                      }*/
                      else {
                        // Check if the widget is still mounted before navigating
                        if (!mounted) return;


                        try {
                          final result = await requestAPI(
                            ('${AppConfig.apiBaseUrl}/fetch.php'),
                            body: {
                              'username': nameController.text.trim(),
                              'password': passwordController.text.trim(),
                            }
                          );
                          print(result);
                     
                          Map<String, dynamic> userData = {
                            'id': 1,
                            'name': 'John Doe',
                            'email': 'johndoe@example.com'
                          };

                          await setLocalData('authedUser', userData);
                          //Navigator.pushReplacementNamed(context, '/home');

                            Navigator.popAndPushNamed(context, '/home');

                        

                        } catch (e) {
                          print('Login error: $e');
                        }
                      }
                    },
                    child: const Text('登入'),
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}
