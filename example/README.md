```dart
import 'package:flutter/material.dart';
import 'package:of_codefield/of_codefield.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color(0xFF232233),
            child: Center(
              child: CodeField(
                succeed: () {
                  print('Input complete!');
                },
                codeLength: 4,
                blockHeight: 60,
                blockWidth: 60,
                blockSpace: 5,
                // contentBuilder: (String t) {
                //   return Icon(
                //     Icons.done,
                //     color: Colors.white,
                //   );
                // },
                // filledDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular((6.0)),
                //   color: Color(0xFF1D1D2B),
                //   boxShadow: [
                //     BoxShadow(
                //         color: Color(0xEEEEEEEE),
                //         blurRadius: 10.0,
                //         spreadRadius: 2.0),
                //   ],
                // ),
              ),
            )));
  }
}

```