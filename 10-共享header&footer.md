在 Flutter 中，如果你想在多個頁面中共用同一個 `AppBar` 和 `BottomNavigationBar`，最常見的做法是使用一個「父級 Scaffold」來包裹所有頁面內容，讓它們共用相同的 `AppBar` 和 `BottomNavigationBar`。這可以透過創建一個 `MainLayout` 或 `BaseScaffold` 類來實現。

✅ 建立共用的 Scaffold Layout (`MainLayout`)

    class MainLayout extends StatefulWidget {
      final Widget child;
      final int currentIndex;
    
      const MainLayout({super.key, required this.child, this.currentIndex = 0});
    
      @override
      State<MainLayout> createState() => _MainLayoutState();
    }
    
    class _MainLayoutState extends State<MainLayout> {
      late int _selectedIndex;
    
      final List<String> _routeNames = [
        AppRoute.home,
        AppRoute.profile,
        AppRoute.settings,
      ];
    
      @override
      void initState() {
        super.initState();
        _selectedIndex = widget.currentIndex;
      }
    
      void _onItemTapped(int index) {
        if (_selectedIndex != index) {
          Navigator.pushReplacementNamed(context, _routeNames[index]);
        }
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text("Shared AppBar")),
          body: widget.child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      }
    }

✅ 使用 `MainLayout` 包裝你的頁面

    class HomePage extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MainLayout(
          currentIndex: 0,
          child: Center(child: Text('This is Home Page')),
        );
      }
    }
    
    class ProfilePage extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MainLayout(
          currentIndex: 1,
          child: Center(child: Text('This is Profile Page')),
        );
      }
    }
