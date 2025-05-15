
Flutter 應用在 Android 平台上發布
---
your_flutter_project/
├── android/
│   ├── app/
│   │   ├── build.gradle       ← App 模組設定檔 (簽名設定寫這裡)
│   │   ├── your-release-key.jks  ← 你的 keystore 檔案 (自己放進去)
│   │   └── src/
│   │       └── ...
│   ├── key.properties          ← 存放簽名密碼的設定檔 (需自己新增)
│   ├── build.gradle            ← Android 項目設定
│   └── ...
├── lib/
│   └── main.dart
└── ...

### 1. 準備環境

-   確認已安裝 Android SDK 和 Java JDK
    
-   Flutter SDK 已設定完成
    
-   Android Studio 或命令列都可以操作
    

### 2. 設定應用版本號

-   在  `android/app/build.gradle`  修改  `versionCode`  與  `versionName`
   ---
    defaultConfig {
       ...
       versionCode 1
       versionName "1.0.0"
    } 
    

### 3. 產生簽名金鑰（Keystore）

-   使用命令產生簽名檔案
    ---
    keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
    
-   記得設定好密碼與備份 keystore 檔案
    
### 4. 配置簽名設定
-   把 keystore 複製到  `android/app`  目錄（或你想放的地方）
-   編輯  `android/key.properties`，新增：

---
       storePassword=你的密碼 
       keyPassword=你的密碼 
       keyAlias=my-key-alias 
       storeFile=my-release-key.jks
    
-   修改  `android/app/build.gradle`  中的 signingConfigs 節點
---
    import java.util.Properties
    import java.io.FileInputStream

    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }
    
    android {
        ...
        signingConfigs {
            release {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
            }
        }
        buildTypes {
            release {
                signingConfig signingConfigs.release
                minifyEnabled false
                shrinkResources false
                proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            }
        }
    }
    

### 5. 編譯發布版 APK 或 AAB
    
   flutter build apk --release
    
 或編譯 AAB（推薦，用於 Google Play）
    
   flutter build appbundle --release
    

### 6. 測試發布版 APK

-   把生成的  `build/app/outputs/flutter-apk/app-release.apk`  安裝到手機測試
    

### 7. 上傳 Google Play

-   在 Google Play Console 建立應用
    
-   上傳 AAB 檔案
    
-   填寫應用資料與隱私政策等
    
-   發布應用
├── lib/
│   └── main.dart
└── ...

