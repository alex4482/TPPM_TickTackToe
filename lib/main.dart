

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
      home: const TicTacToeHomePage(title: 'Play Tic Tac Toe'),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TicTacToeHomePage> createState() => TicTacToeState();
}

class TicTacToeState extends State<TicTacToeHomePage> {
  var board;
  var painters;
  bool xRound = true;
  bool playAgainstAi = false;
  bool aiStarts = true;
  bool isGameOver = false;
  bool horizontalFinishLine = false;
  bool verticalFinishLine = false;

  List<bool> isSelected = [true, false];

  Offset? finishLineOffset1;
  Offset? finishLineOffset2;

  bool showTurnPickButtons = false;

  TicTacToeState() {
    
    

    refreshBoard();

  }

  void refreshBoard()
  {
    isGameOver = false;
    xRound = true;

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
  
    if(playAgainstAi && aiStarts)
    {
      doAiMove();
    }
  }

  void onButtonPressed(int row, int col) {
    setState(() {
      if(!isGameOver && painters[row][col].drawX == null)
      {
        painters[row][col].drawX = xRound;

        if(!playAgainstAi)
        {
          xRound = !xRound;
        }

        checkGameOver();
      }
     
    });
  }

  void checkGameOver()
  {
    setState(() {
    for(int i = 0; i < 3; i++)
    {
      if(painters[i][0].drawX == painters[i][1].drawX && painters[i][0].drawX == painters[i][2].drawX && painters[i][0].drawX != null)
      {
        isGameOver = true;
        verticalFinishLine = false;
        horizontalFinishLine = true;
        finishLineOffset1 = Offset(i.toDouble(), 0);
        finishLineOffset2 = Offset(i.toDouble(), 2);    
        return;
      }

      if(painters[0][i].drawX == painters[1][i].drawX && painters[0][i].drawX == painters[2][i].drawX && painters[0][i].drawX != null)
      {
        isGameOver = true;
        verticalFinishLine = true;
        horizontalFinishLine = false;
        finishLineOffset1 = Offset(0, i.toDouble());
        finishLineOffset2 = Offset(2, i.toDouble());    
        return;
      }
    }

    if(painters[0][0].drawX == painters[1][1].drawX && painters[0][0].drawX == painters[2][2].drawX && painters[0][0].drawX != null)
    {
      isGameOver = true;
      verticalFinishLine = false;
      horizontalFinishLine = false;
      finishLineOffset1 = const Offset(0, 0);
      finishLineOffset2 = const Offset(2, 2);
      return;
    }

    if(painters[0][2].drawX == painters[1][1].drawX && painters[0][2].drawX == painters[2][0].drawX && painters[0][2].drawX != null)
    {
      isGameOver = true;
      finishLineOffset1 = const Offset(0, 2);
      finishLineOffset2 = const Offset(2, 0);
      return;
    }
    }); 
  }

  void onResetButtonClick(){
    setState(() {
      refreshBoard();

      if(playAgainstAi && aiStarts)
      {
          doAiMove();
      }
    });
  }

  void doAiMove()
  {
    //foloseste !xRound ca sa desenezi ce face Ai
  }

  void onPlayAgainstPlayerButtonClick(){
    setState(() {

      showTurnPickButtons = false;

      playAgainstAi = false;
      refreshBoard();  
    });
    
  }

  void onPlayAgainstAiButtonClick(){
    setState(() {
      showTurnPickButtons = true;
      

      playAgainstAi = true;
      refreshBoard();  
    });
    
  }

  @override
  Widget build(BuildContext context) {
    Widget firstSecondButtons = ToggleButtons(
      fillColor: Colors.yellow,
      children: const [
            Text("First",
              style: TextStyle(           
                    color: Colors.white,
                    fontSize: 14)),
            Text("Second",
              style: TextStyle(
                    color: Colors.white,
                    fontSize: 14))
          ],
          isSelected: isSelected,
          onPressed: (int index){
            setState(() {

              isSelected[index] = true;
              isSelected[1- index] = false;
              

              if(index == 0)
              {
                aiStarts = false;
              }
              else
              {
                aiStarts = true;
              }
              refreshBoard();
            });
          },
          );

    List<Widget> appBarActions = [
          
          Container(
            margin: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: onResetButtonClick,
              style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange, // Background color
                  ),
              child: const Text(
                "Reset board",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18),
                
                ),
              ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.deepOrange,
            child: ElevatedButton(
              
              onPressed: onPlayAgainstAiButtonClick,
              style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange, // Background color
                  ),
              child: const Text(
                "Play against AI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18),
                
                ),
              ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.deepOrange,
            child: ElevatedButton(
              onPressed: onPlayAgainstPlayerButtonClick,
              style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange, // Background color
                  ),
              child: const Text(
                "Play against player",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18),
                
                ),
              ),
          ),
        ];

        if(showTurnPickButtons)
        {
          appBarActions.insert(0, firstSecondButtons);
        }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: appBarActions,
        backgroundColor: Colors.red,
      
        ),
      body: Center(
        child: AspectRatio(
            aspectRatio: 1,
            child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: CustomPaint(
                  foregroundPainter: TicTacToeBoardPainter(this),
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
                 
                ))),
      ),
    );
  }
}


class TicTacToeBoardPainter extends CustomPainter{

  Color boardBackgroundColor = Colors.black;
  Color boardInnerStrokesColor = Colors.orange;
  double strokeThickness = 10;

  TicTacToeState game;
  double strokesThickness = 10;

  Color endLineColor = Colors.purple;

  TicTacToeBoardPainter(this.game);

  @override
  void paint(Canvas canvas, Size size){
  Paint paintBorder = Paint()
    ..color = boardBackgroundColor
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = strokeThickness;

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset( size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  canvas.drawLine(topLeft, topRight, paintBorder);
  canvas.drawLine(topLeft, bottomLeft, paintBorder);
  canvas.drawLine(bottomLeft, bottomRight, paintBorder);
  canvas.drawLine(bottomRight, topRight, paintBorder);
    
  Paint paintInnerStrokes = Paint()
    ..color = boardInnerStrokesColor
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = strokeThickness;

  Offset p11 = Offset(size.width / 3, 0);
  Offset p12 = Offset(size.width * 2 / 3, 0);

  Offset p21 = Offset(0, size.height / 3);
  //Offset p21 = Offset(size.width / 3, size.height / 3);
  //Offset p22 = Offset(size.width * 2 /3, size.height / 3);
  Offset p22 = Offset(size.width, size.height / 3);

  Offset p31 = Offset(0, size.height * 2 / 3);
  //Offset p31 = Offset(size.width / 3, size.height * 2 / 3);
  //Offset p32 = Offset(size.width * 2 / 3, size.height * 2 / 3);
  Offset p32 = Offset(size.width, size.height * 2 / 3);

  Offset p41 = Offset(size.width / 3, size.height);
  Offset p42 = Offset(size.width * 2 / 3, size.height);

  canvas.drawLine(p11, p41, paintInnerStrokes);
  canvas.drawLine(p12, p42, paintInnerStrokes);
  canvas.drawLine(p21, p22, paintInnerStrokes);
  canvas.drawLine(p31, p32, paintInnerStrokes);

    if(game.isGameOver)
    {
      paintEndLine(canvas, size);
    }
  }

  @override 
  bool shouldRepaint(CustomPainter oldDelegate){
    return game.isGameOver;
  }

  
void paintEndLine(Canvas canvas, Size size){
    Paint paint = Paint()
      ..color = endLineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokesThickness;

    double widthAddition1 = 0, heightAddition1 = 0;
    double widthAddition2 = 0, heightAddition2 = 0;

    if(game.horizontalFinishLine)
    {
      widthAddition2 = size.width / 3;

      heightAddition1 = size.height / 6;
      heightAddition2 = size.height / 6;
    }
    else if(game.verticalFinishLine)
    {
      widthAddition1 = size.width / 6;
      widthAddition2 = widthAddition1;

      heightAddition2 = size.height / 3;
    }
    else {
      widthAddition2 = size.width / 3;
      heightAddition2 = size.height / 3;
    }

    Offset p1 = Offset (
      size.width * game.finishLineOffset1!.dy / 3 + widthAddition1, 
      size.height * game.finishLineOffset1!.dx / 3 + heightAddition1
      );
    Offset p2 = Offset (
      size.width * game.finishLineOffset2!.dy / 3 + widthAddition2, 
      size.height * game.finishLineOffset2!.dx / 3 + heightAddition2
      );

    canvas.drawLine( p1, p2, paint);
  }


}

class TicTacToePainter extends CustomPainter {
  int ownBoardPlace;
  bool? drawX;
  double parentSizeMaxFill = 0.8;
  double strokesThickness = 10;

  Color oColor = Colors.blue;
  Color xColor = Colors.yellow;  

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
    
    Offset center = Offset(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..color = oColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokesThickness;
    canvas.drawCircle(center, size.width * parentSizeMaxFill / 2, paint);
  }

  void paintX(Canvas canvas, Size size) {
    
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
