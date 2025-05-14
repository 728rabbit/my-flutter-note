import 'package:devapp/layout.dart';
import 'package:devapp/core/helper.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late Future<Map<String, dynamic>> userDataFuture;
  late Future<Map<String, dynamic>> productDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserData();
    productDataFuture = getProductData();
  }

  Future<Map<String, dynamic>> getUserData() async {
    await Future.delayed(Duration(seconds: 1));
    return {'name': 'Alice', 'age': 30};
  }

  Future<Map<String, dynamic>> getProductData() async {
    await Future.delayed(Duration(seconds: 1));
    return {'product': 'Laptop', 'price': 999};
  }


  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 1, 
      childWidget: FutureBuilder(
        future: Future.wait([userDataFuture, productDataFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var userData = snapshot.data![0];
            var productData = snapshot.data![1];
            return Column(
                children: [
                  ListTile(
                    title: Text('User: ${userData['name']}'),
                    subtitle: Text('Age: ${userData['age']}'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Product: ${productData['product']}'),
                    subtitle: Text('Price: \$${productData['price']}'),
                  ),
                  SizedBox(
                    child: ElevatedButton(onPressed: () async {
                      setLocalData('authedUser', null);
                      Navigator.pushReplacementNamed(context, '/login');
                    }, child: const Text('登出')),
                  ),
                  SizedBox(
                    child: 
                    ElevatedButton(
                      onPressed: () => {},
                      child: Text('Show Alert'),
                    )
                  )
                ],
              );
         
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      )
    );
  }
  
}