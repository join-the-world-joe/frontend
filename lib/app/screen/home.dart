import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Home> {
  int lastStage = 0;
  int curStage = 0;
  int currentSelectedIndex = 0;

  void refresh() {
    setState(() {});
  }

  void setup() {}

  void progress() async {
    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setup();
    progress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(
                () {
                  currentSelectedIndex = index;
                },
              );
            },
            indicatorColor: Colors.amber[800],
            selectedIndex: currentSelectedIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: '首页',
              ),
              NavigationDestination(
                icon: ImageIcon(
                  AssetImage('lib/app/asset/icon/masseur.png'),
                  size: 50,
                  color: Colors.black,
                ),
                selectedIcon: ImageIcon(
                  AssetImage('lib/app/asset/icon/masseur.png'),
                  size: 50,
                  color: Colors.red,
                ),
                label: '技师',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.school),
                icon: Icon(Icons.school_outlined),
                label: 'School',
              ),
            ],
          ),
          body: <Widget>[
            Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text('Page 1'),
            ),
            Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text('Page 2'),
            ),
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Page 3'),
            ),
          ][currentSelectedIndex],
        );
      },
    );
  }
}
