import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide to action',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Slide to action'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late SlideController controller;

  @override
  void initState() {
    controller = SlideController();
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    controller.success();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have slide the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SlideToAction(
                controller: controller,
                onSlideComplete: () async {
                  controller.loading();

                  await Future.delayed(Duration(seconds: 2)).then(
                    (value) {
                      controller.success();
                      _incrementCounter();
                    },
                  );
                  await Future.delayed(Duration(seconds: 2)).then(
                    (value) {
                      controller.reset();
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
