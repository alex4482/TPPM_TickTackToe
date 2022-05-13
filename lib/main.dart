//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tick Tack Toe',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage(title: 'Play Tick Tack Toe'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var board;
  var painters;
  bool xRound = true;

  HomePageState() {
    painters = List.generate(3, (index) {
      return List.generate(3, (index2) {
        return TicTacToePainter(index * 3 + index2);
      });
    });

    board = List.generate(3, (index) {
      return List.generate(3, (index2) {
        return CustomPaint(
            painter: painters[index][index2],
            child: TextButton(
              child: Container(
              ),
              onPressed: () => onButtonPressed(index, index2),
            )

            //),)
            );
      });
    });
  }

  void onButtonPressed(int row, int col) {
    setState(() {
      if(painters[row][col].drawX == null)
      {
        painters[row][col].drawX = xRound;
        xRound = !xRound;
      }
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: AspectRatio(
            aspectRatio: 1,
            child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: Container(
                  color: Colors.red,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 4,
                        child: 
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: 
                              [
                              Expanded(
                              flex: 1,
                              child: board[0][0]),
                              Expanded(
                              flex: 1,
                              child: board[0][1]),
                              Expanded(
                              flex: 1,
                              child: board[0][2])
                            ],
                          ),
                        
                      ),
                      Expanded(
                        flex: 4,
                        child: 

                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: 
                              [
                              Expanded(
                              flex: 1,
                              child: board[1][0]),
                              Expanded(
                              flex: 1,
                              child: board[1][1]),
                              Expanded(
                              flex: 1,
                              child: board[1][2])
                            ],
                          ),
                        
                      ),
                      Expanded(
                        flex: 4,
                        child: 
 
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: 
                            [
                              Expanded(
                              flex: 4,
                              child: board[2][0]),
                              Expanded(
                              flex: 4,
                              child: board[2][1]),
                              Expanded(
                              flex: 4,
                              child: board[2][2])
                            ]
                              ,
                          ),
                        ),
                      
                    ],
                  ),
                  /*Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),*/
                ))),
      ),
    );
  }
}

class TicTacToePainter extends CustomPainter {
  int ownBoardPlace;
  bool? drawX;
  double parentSizeMaxFill = 0.8;
  double strokesThickness = 10;

  TicTacToePainter(this.ownBoardPlace);

  @override
  void paint(Canvas canvas, Size size) {
    if (drawX != null) {
      if (drawX == true) {
        paintX(canvas, size);
      } else {
        paintO(canvas, size);
      }
    }
  }

  void paintO(Canvas canvas, Size size) {
    Color oColor = Colors.blue;
    Offset center = Offset(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..color = oColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokesThickness;
    canvas.drawCircle(center, size.width * parentSizeMaxFill / 2, paint);
  }

  void paintX(Canvas canvas, Size size) {
    Color xColor = Colors.yellow;
    Offset topLeft = Offset(
      size.width * parentSizeMaxFill, 
      size.height - size.height * parentSizeMaxFill);
    Offset topRight = Offset(
      size.width - size.width * parentSizeMaxFill, 
      size.height - size.height * parentSizeMaxFill);
    Offset bottomLeft = Offset(
      size.width * parentSizeMaxFill, 
      size.height * parentSizeMaxFill);
    Offset bottomRight = Offset(
      size.width - size.width * parentSizeMaxFill, 
      size.height * parentSizeMaxFill);

    Paint paint = Paint()
      ..color = xColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokesThickness;
    canvas.drawLine(topLeft, bottomRight, paint);
    canvas.drawLine(topRight, bottomLeft, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return drawX != null;
  }
}
