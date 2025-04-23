**小 app**

用 `routes` 就夠，簡單乾淨

**大 app 或要傳參數**

用 `onGenerateRoute`，彈性最大

**兩個同時設**

沒錯，但要知道 `routes` 有的話，`onGenerateRoute` 不會被用到

`routes` ➔ 找不到 ➔ 才會用 `onGenerateRoute`

    MaterialApp(
      routes: {
        '/home': (context) => HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          return MaterialPageRoute(builder: (context) => ProfilePage());
        }
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );

-   如果你跳 `/home` → 直接走 `routes`
    
-   如果你跳 `/profile` → `routes` 沒有，才會走 `onGenerateRoute`
    
-   如果 `/abc` 也沒有 → `onGenerateRoute` 再去顯示 `NotFoundPage`


### 專業的小技巧：

-   `routes` 是 Map（固定），**不能傳參數**。
    
-   `onGenerateRoute` 是 function，**可以做任何邏輯判斷、傳參數**。
    
-   只要**你的 app 有任何需要傳參數跳轉**，都應該用 `onGenerateRoute`！


## Flutter 路由模板 (推介版)

    import 'package:flutter/material.dart';
    
    void main() {
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/settings': (context) => const SettingsPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/profile') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ProfilePage(username: args['username']),
              );
            }
            return MaterialPageRoute(builder: (context) => const NotFoundPage());
          },
        );
      }
    }
    
    // ========== 頁面們 ==========
    
    class HomePage extends StatelessWidget {
      const HomePage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text('Go to Settings'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/profile',
                      arguments: {'username': 'JohnDoe'},
                    );
                  },
                  child: const Text('Go to Profile (with arguments)'),
                ),
              ],
            ),
          ),
        );
      }
    }
    
    class SettingsPage extends StatelessWidget {
      const SettingsPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: const Center(child: Text('Settings Page')),
        );
      }
    }
    
    class ProfilePage extends StatelessWidget {
      final String username;
      const ProfilePage({super.key, required this.username});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(child: Text('Hello, $username!')),
        );
      }
    }
    
    class NotFoundPage extends StatelessWidget {
      const NotFoundPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: const Center(child: Text('Page Not Found')),
        );
      }
    }

`routes`

處理固定頁面：Home、Settings

`onGenerateRoute`

處理需要傳參數的頁面：Profile

`NotFoundPage`

處理亂跳或打錯路徑時，顯示 404

`arguments`

可以傳 Map 資料到 Profile 頁面
