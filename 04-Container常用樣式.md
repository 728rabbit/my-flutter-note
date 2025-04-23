    import 'package:flutter/material.dart';
    
    void main() {
      runApp(MyApp());
    }
    
    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Container Example')),
            body: Center(
              child: Container(
                width: 250,  // 設置寬度
                height: 250, // 設置高度
                margin: EdgeInsets.all(16), // 外邊距
                padding: EdgeInsets.all(16), // 內邊距
                decoration: BoxDecoration(
                  color: Colors.blue, // 背景顏色
                  borderRadius: BorderRadius.circular(20), // 圓角
                  border: Border.all(color: Colors.red, width: 3), // 邊框
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'), // 背景圖
                    fit: BoxFit.cover, // 填滿
                  ),
                  gradient: LinearGradient( // 漸變背景
                    colors: [Colors.blue.withOpacity(0.7), Colors.green.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [ // 陰影效果
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Styled Container',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

### 這個範例包括了：

-   **`color`**：設定背景顏色為藍色。
    
-   **`borderRadius`**：設定圓角半徑為 20。
    
-   **`border`**：設置紅色邊框，寬度為 3。
    
-   **`padding`**：設置內邊距為 16。
    
-   **`margin`**：設置外邊距為 16。
    
-   **`image`**：設置背景圖片並使用 `BoxFit.cover` 來填滿。
    
-   **`gradient`**：添加漸變背景，從藍色到綠色。
    
-   **`boxShadow`**：添加陰影，讓容器看起來浮起來。
    
-   **`Text`**：在容器中放置文本，並且設置了字體大小和顏色。
