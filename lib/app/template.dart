import 'package:flutter/material.dart';

class BuilderTemplate extends StatefulWidget {
  const BuilderTemplate({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<BuilderTemplate> {
  int lastStage = 0;
  int curStage = 0;

  void refresh() {
    setState(() {});
  }

  void setup() {
  }

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
        return const Text('');
      },
    );
  }
}
