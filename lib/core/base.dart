/*
class YourPage extends StatefulWidget {
  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends BaseState<YourPage> {
   Widget build(BuildContext context) {

   }
}
*/
import 'package:base_app/core/config.dart';
import 'package:base_app/core/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom show Element;
import 'package:url_launcher/url_launcher.dart';

Map<String, dynamic>? authedUser;

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final AppLang defaultLang = AppLang();
  
  @override
  void initState() {
    super.initState();
    defaultLang.addListener(_onLangChanged);
  }

  @override
  void dispose() {
    defaultLang.removeListener(_onLangChanged);
    super.dispose();
  }

  void _onLangChanged() {
    setState(() => {});
  }

  int screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width.toInt();
  }

  int screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height.toInt();
  }

  // authedUserInfo('name')
  dynamic authedUserInfo(String? key) {
    if(key != null) {
      return (authedUser?[key] ?? '');
    }
    else {
      return authedUser;
    }
  }

  // showTips(context, 'your_message_here')
  void showTips(BuildContext context, String tipsMessage) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tipsMessage, 
          style: TextStyle(
            color: AppConfig.hexCode('white')
          )
        ),
        backgroundColor: AppConfig.hexCode('primary')
      )
    );
  }

  // showAlert(context, 'your_message_here', closeCallback: () => { })
  void showAlert(BuildContext context, String alertMessage, {VoidCallback? closeCallback}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          //contentPadding: EdgeInsets.all(20),
          content: Text(alertMessage, 
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          ), 
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.hexCode('primary'),
                  foregroundColor: AppConfig.hexCode('white'),
                  minimumSize: Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21)
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (closeCallback != null) { closeCallback(); }
              },
              child: Text(defaultLang.getVal('btn_ok')) 
            )
          ]
        );
      }
    );
  }

  // showConfirm(context, 'your_message_here', yesCallback: () => {}, noCallback: () => {})
  void showConfirm(BuildContext context, String confirmMessage, {VoidCallback? yesCallback, VoidCallback? noCallback}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          //contentPadding: EdgeInsets.all(20),
          content: Text(
            confirmMessage,
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded( // Ensure buttons expand properly
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.hexCode('primary'),
                        foregroundColor: AppConfig.hexCode('white'),
                        minimumSize: Size(double.infinity, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21)
                        )
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (yesCallback != null) { yesCallback(); }
                      },
                      child: Text(defaultLang.getVal('btn_yes'))
                    )
                  )
                ),
                Expanded( // Ensure buttons expand properly
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.hexCode('primary'),
                        foregroundColor: AppConfig.hexCode('white'),
                        minimumSize: Size(double.infinity, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21)
                        )
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (noCallback != null) { noCallback(); }
                      },
                      child: Text(defaultLang.getVal('btn_no'))
                    )
                  )
                )
              ]
            )
          ]
        );
      },
    );
  }

  void showContent(BuildContext context, Widget childUnit, {VoidCallback? closeCallback}) {
    showDialog(
      context: context,
      //barrierDismissible: false, 
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: childUnit
                )
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: AppConfig.hexCode('black')),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (closeCallback != null) { closeCallback(); }
                  }
                )
              )
            ]
          )
        );
      },
    );
  }

  void showHtmlContent(BuildContext context, String htmlData, {VoidCallback? closeCallback}) {
    showDialog(
      context: context,
      //barrierDismissible: false, 
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Html(
                        data: htmlData, 
                        onLinkTap: (String? url, Map<String, String> attributes, dom.Element? element) {
                          if (url == null) return;
                          final uri = Uri.parse(url);
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        style: {
                          "*": Style(
                            color: AppConfig.hexCode('black')
                          ),
                          "a": Style(
                            color: AppConfig.hexCode('blue')
                        )}
                      )
                    ]
                  )
                )
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: AppConfig.hexCode('black')),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (closeCallback != null) { closeCallback(); }
                  }
                )
              )
            ]
          )
        );
      },
    );
  }

  void showBusy(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,  // Prevent dismiss by tapping outside
      barrierColor: const Color.fromARGB(128, 255, 255, 255),  // Adjust overlay transparency
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConfig.hexCode('primary')),
            strokeWidth: 4
          )
        );
      },
    );
  }

  void hideBusy(BuildContext context) {
    Navigator.of(context).pop();  // Close the dialog
  }
}