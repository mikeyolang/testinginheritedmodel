import 'dart:math';

import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var color1 = colors.getRandomElement() as MaterialColor;
  var color2 = colors.getRandomElement() as MaterialColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomElement() as MaterialColor;
                    });
                  },
                  child: const Text("Change Color 1"),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.getRandomElement() as MaterialColor;
                    });
                  },
                  child: const Text("Change Color 2"),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(key: key, child: child);

  // The below function is called whenever the model is rebuilt. It is used to determine if the widget should be rebuilt or not.

  static AvailableColorsWidget? of(
    BuildContext context,
    AvailableColors aspect,
  ) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspect,
    );
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devtools.log("updateShouldNotify");
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant InheritedModel<AvailableColors> oldWidget,
      Set<AvailableColors> dependencies) {
    devtools.log("updateShouldNotifyDependent");
    return dependencies.contains(color1) || dependencies.contains(color2);
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log("ColorWidget one");
        break;

      case AvailableColors.two:
        devtools.log("ColorWidget two");
        break;
    }
    final provider = AvailableColorsWidget.of(context, color);

    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider!.color1 : provider!.color2,
    );
  }
}

// An array of colors to choose from
final List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.blue,
  Colors.orange,
  Colors.pink,
  Colors.purple,
  Colors.indigo,
  Colors.teal,
  Colors.cyan,
  Colors.brown,
  Colors.grey,
  Colors.lime,
  Colors.amber,
  Colors.black,
  Colors.white,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}
