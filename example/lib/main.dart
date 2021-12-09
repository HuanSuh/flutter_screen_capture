import 'package:flutter/material.dart';
import 'package:flutter_screen_capture/flutter_screen_capture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ScreenCaptureView(
      layoutBuilder: (_, captureView, ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: captureView,
          floatingActionButton: FloatingActionButton(
            onPressed: () => ctrl.capture(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
      captureBuilder: (_, ctrl) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '0',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        );
      },
    );
  }
}
