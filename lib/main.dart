import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scalable OCR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String text = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScalableOCR(
                paintboxCustom: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4.0
                  ..color = const Color.fromARGB(153, 102, 160, 241),
                boxLeftOff: 5,
                boxBottomOff: 2.5,
                boxRightOff: 5,
                boxTopOff: 2.5,
                boxHeight: MediaQuery.of(context).size.height / 3,
                // getRawData: (value) {
                //   inspect(value);
                // },
                getScannedText: (value) {
                  setText(value);
                }),
            StreamBuilder<String>(
              stream: controller.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Result(text: snapshot.data != null ? snapshot.data! : "");
              },
            )
          ],
        ),
      )
    );
  }
}

class Result extends StatelessWidget {
  const Result({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    String convertedText = extractContinuousNumber(text);
    return Text("Readed text: $convertedText");
  }
}

String findAndConvertFormattedNumber(String input) {
  RegExp regExp = RegExp(r'(\d{4} \d{4} \d{4} \d{4})');
  String convertedText = input.replaceAllMapped(regExp, (match) {
    return match.group(0)!.replaceAll(' ', '');
  });

  return convertedText;
}


String extractContinuousNumber(String input) {
  RegExp regExp = RegExp(r'(\d{4} \d{4} \d{4} \d{4})');

  Match? match = regExp.firstMatch(input);

  if (match != null) {
    return match.group(0)!.replaceAll(' ', '',).replaceAll("  ", "").replaceAll("   ", "").replaceAll("    ", "");
  }
  return '';
}