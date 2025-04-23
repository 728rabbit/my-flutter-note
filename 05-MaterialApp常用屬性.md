`home`

App 的首頁（通常搭配 `Scaffold` 使用）

`routes`

定義全 app 的路由表（用來管理跳轉頁面）

`initialRoute`

app 啟動時，先進入哪一個路由

`onGenerateRoute`

動態生成路由（比較彈性，支援傳參數）

`theme`

設定全 app 的主題（顏色、字體、按鈕樣式）

`darkTheme`

設定暗黑模式的主題

`themeMode`

控制使用 `theme` 還是 `darkTheme`（例如跟隨系統）

`locale`

指定語言地區（例如繁體中文 `Locale('zh', 'HK')`）

`localizationsDelegates`

配合 `locale` 使用，支援多語言

`supportedLocales`

支援的語言列表

`debugShowCheckedModeBanner`

控制右上角的 debug banner 是否顯示

`navigatorKey`

自定義 Navigator，方便全局控制跳轉

`builder`

全 app 入口可以插入一個 widget（比如強制加一層外框）
