import 'package:flutter/material.dart';
import 'package:get_pet/screens/search/search.dart';

class TabControllerWidget extends StatelessWidget {
  const TabControllerWidget({Key key}) : super(key: key);

  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const TabBarView(
          children: [
            SearchScreen(),
            Text('2'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              title: const Text('first'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: const Text('second'),
            ),
          ],
        ),
      ),
    );
  }
}
