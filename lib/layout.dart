/*
AppLayout(
  childWidget: YourChildWidget(),
  currentIndex: 0,
  includedHeaderFooter: true,
  isFullWith: false,
  showFloatingActionButton: true,
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // 按鈕點擊處理邏輯
    },
    child: const Icon(Icons.add),
  )
)
*/

import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget childWidget;
  final int currentIndex;
  final bool? includedHeaderFooter;
  final bool? isFullWith;
  final bool? showFloatingActionButton;
  final Widget? floatingActionButton;
  final String? backgroundImage;

  const AppLayout({
    super.key,
    required this.childWidget,
    required this.currentIndex,
    this.includedHeaderFooter = true,
    this.isFullWith = false,
    this.showFloatingActionButton = false,
    this.floatingActionButton,
    this.backgroundImage = ''
  });

  void _onItemTapped(BuildContext context, int index) {
    final routes = ['/home', '/profile', '/settings'];
    if (index != currentIndex && index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ((includedHeaderFooter ?? true)
          ? AppBar(
              automaticallyImplyLeading: Navigator.canPop(context),
              title: const Text("App Title Here"),
            )
          : null),
      body: SafeArea(
        child: 
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              image: ((backgroundImage!.isNotEmpty)? DecorationImage(
                image: AssetImage(backgroundImage.toString()),
                fit: BoxFit.cover, 
              ): null)
            ),
            child:  
              SingleChildScrollView(
              padding: ((isFullWith == false)
                  ? const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40)
                  : null),
              child: childWidget
            )
          )
      ),
      bottomNavigationBar: ((includedHeaderFooter ?? true)
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => _onItemTapped(context, index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            )
          : null),
      floatingActionButton: ((showFloatingActionButton ?? false)
          ? (floatingActionButton ?? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ))
          : null)
    );
  }
}