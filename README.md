**一個使用 Flutter 開發的筆記應用程式，幫助你隨時記錄想法、待辦事項和重要資訊！**

**Flutter 安裝 plugin: flutter pub add http**
這個指令會自動幫你：
-   修改 `pubspec.yaml`
-   執行 `flutter pub get`

**一鍵升級所有 plugin 至最新版本: flutter pub upgrade**

**強制升級所有 plugin 至可用的最新版本: flutter pub upgrade --major-versions**


## 📍 步驟一：更改 Gradle Wrapper 版本（`gradle-wrapper.properties`）

打開檔案：

pgsql

複製編輯

`android/gradle/wrapper/gradle-wrapper.properties` 

找到這行（或類似）：

properties

複製編輯

`distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip` 

### 🔄 修改為你需要的版本，例如：

properties

複製編輯

`distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-all.zip` 

你可以從這裡找到官方版本： https://services.gradle.org/distributions/

----------

## 📍 步驟二：更改 Android Gradle Plugin 版本（`build.gradle`）

打開檔案：

bash

複製編輯

`android/build.gradle` 

找到這段：

groovy

複製編輯

`classpath 'com.android.tools.build:gradle:7.4.0'` 

### 🔄 修改為對應於你想用的 Gradle 版本，例如：

groovy

複製編輯

`classpath 'com.android.tools.build:gradle:8.1.0'` 

不同的 Gradle 版本需要配對不同的 Android Gradle Plugin（AGP）版本。參考對照表如下 👇


## ✅ 步驟三：執行升級

修改完畢後，在 terminal 執行：

bash

複製編輯

flutter clean
flutter pub get
flutter build apk 

或使用 Android Studio 重新同步 Gradle。
