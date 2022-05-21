


import 'dart:math';

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
  late List<List<CustomPaint>> board;
  late List<List<TicTacToePainter>>  painters;

  bool xRound = true;

  bool playAgainstAi = false;
  bool aiStarts = true;
  bool isGameOver = false;
  bool isDraw = false;

  bool horizontalFinishLine = false;
  bool verticalFinishLine = false;
  bool mainDiagonalFinishLine = false;

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
    isDraw = false;
    horizontalFinishLine = false;
    verticalFinishLine = false;
    mainDiagonalFinishLine = false;

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

        checkGameOver();

        if(!playAgainstAi)
        {
          xRound = !xRound;
        }
        else if(!isGameOver)
        {
          doAiMove();
        }
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
      mainDiagonalFinishLine = true;
      finishLineOffset1 = const Offset(0, 0);
      finishLineOffset2 = const Offset(2, 2);
      return;
    }

    if(painters[0][2].drawX == painters[1][1].drawX && painters[0][2].drawX == painters[2][0].drawX && painters[0][2].drawX != null)
    {
      isGameOver = true;
      verticalFinishLine = false;
      horizontalFinishLine = false;
      mainDiagonalFinishLine = false;
      finishLineOffset1 = const Offset(0, 2);
      finishLineOffset2 = const Offset(2, 0);
      return;
    }

    for(int i = 0; i < painters.length; i++)
    {
      for(int j = 0; j < painters[i].length; j++)
      {
        if(painters[i][j].drawX == null)
        {
          return;
        }
      }
    }

    isGameOver = true;
    isDraw = true;
    }); 
  }

  void onResetButtonClick(){
    setState(() {
      refreshBoard();
    });
  }

  void doAiMove()
  {
    setState(() {

    String opponentChar = !xRound ? "o" : "x";
    String playerChar = !xRound ? "x" : "o";
    TicTacToeAiMinimax ai = TicTacToeAiMinimax(opponentChar, playerChar);
    //TicTacToeAiBkt ai = TicTacToeAiBkt(opponentChar, playerChar);

    List<String> boardString = ["", "", ""];
    for(int i = 0; i < board.length; i++)
    {
      for(int j = 0; j < board[i].length; j++)
      {
        if(painters[i][j].drawX == null)
        {
          boardString[i] += '_';
        }
        else if (painters[i][j].drawX == true)
        {
          boardString[i] += 'x';
        }
        else{
          boardString[i] += 'o';
        }
      }
    }

    Offset bestMove = ai.findBestMove(boardString);

    painters[bestMove.dx.toInt()][bestMove.dy.toInt()].drawX = !xRound;

    //foloseste !xRound ca sa desenezi ce face Ai

    checkGameOver();

    });
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

  void onTurnChooseButtonPress(int index){
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
          onPressed: onTurnChooseButtonPress,
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

    if(game.isGameOver && !game.isDraw)
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
    else if (game.mainDiagonalFinishLine){
      widthAddition2 = size.width / 3;
      heightAddition2 = size.height / 3;
    }
    else{
      widthAddition1 = size.width / 3;
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

class TicTacToeAiBkt{
  String opponent;
  String player;

  TicTacToeAiBkt(this.opponent, this.player);

  Offset findBestMove(List<String> board)
  {
    int score = -10000;
    double row = 0, col = 0;
    for(int i = 0; i < board.length; i++)
    {
      for(int j = 0; j < board[i].length; j++)
      {
        if(board[i][j] == '_'){
          List<String> newBoard = [...board];
          newBoard[i] = newBoard[i].substring(0, j) + opponent + newBoard[i].substring(j+1);
          if(getMoveScore(newBoard, false) > score)
          {
              row = i.toDouble();
              col = j.toDouble();
          }
        }
      }
    }
    return Offset(row, col);
  }

  int getMoveScore(List<String> board, bool opponentTurn)
  {
    int score = 0;

    if(!isMovesLeft(board))
    {
      return evaluate(board);
    }

    for(int i = 0; i < board.length; i++)
    {
      for(int j = 0; j < board[i].length; j++)
      {
        if(board[i][j] == '_'){
          List<String> newBoard = [...board];
          if(opponentTurn)
          {
            newBoard[i] = newBoard[i].substring(0, j) + opponent + newBoard[i].substring(j+1);
          }
          else
          {
            newBoard[i] = newBoard[i].substring(0, j) + player + newBoard[i].substring(j+1);
          }

          score += getMoveScore(newBoard, !opponentTurn);
        }
      }
    }

    return score;
  }

  bool isMovesLeft(List<String> board)
{
    for (int i = 0; i<3; i++){
        for (int j = 0; j<3; j++) {
          if (board[i][j]=="_") {
            return true;
          }
        }
    }
    return false;
}
 
// This is the evaluation function as discussed
// in the previous article ( http://goo.gl/sJgv68 )
int evaluate(List<String> b)
{
    // Checking for Rows for X or O victory.
    for (int row = 0; row<3; row++)
    {
        if (b[row][0]==b[row][1] &&
            b[row][1]==b[row][2])
        {
            if (b[row][0]==player) {
              return 1;
            } else if (b[row][0]==opponent) {
              return -1;
            }
        }
    }
 
    // Checking for Columns for X or O victory.
    for (int col = 0; col<3; col++)
    {
        if (b[0][col]==b[1][col] &&
            b[1][col]==b[2][col])
        {
            if (b[0][col]==player) {
              return 1;
            } else if (b[0][col]==opponent) {
              return -1;
            }
        }
    }
 
    // Checking for Diagonals for X or O victory.
    if (b[0][0]==b[1][1] && b[1][1]==b[2][2])
    {
        if (b[0][0]==player) {
          return 1;
        } else if (b[0][0]==opponent) {
          return -1;
        }
    }
 
    if (b[0][2]==b[1][1] && b[1][1]==b[2][0])
    {
        if (b[0][2]==player) {
          return 1;
        } else if (b[0][2]==opponent) {
          return -1;
        }
    }
 
    // Else if none of them have won then return 0
    return 0;
}
}

class TicTacToeAiMinimax{

  String opponent;
  String player;

  TicTacToeAiMinimax(this.opponent, this.player);

  // This function returns true if there are moves
// remaining on the board. It returns false if
// there are no moves left to play.
bool isMovesLeft(List<String> board)
{
    for (int i = 0; i<3; i++){
        for (int j = 0; j<3; j++) {
          if (board[i][j]=="_") {
            return true;
          }
        }
    }
    return false;
}
 
// This is the evaluation function as discussed
// in the previous article ( http://goo.gl/sJgv68 )
int evaluate(List<String> b)
{
    // Checking for Rows for X or O victory.
    for (int row = 0; row<3; row++)
    {
        if (b[row][0]==b[row][1] &&
            b[row][1]==b[row][2])
        {
            if (b[row][0]==player) {
              return 10;
            } else if (b[row][0]==opponent) {
              return -10;
            }
        }
    }
 
    // Checking for Columns for X or O victory.
    for (int col = 0; col<3; col++)
    {
        if (b[0][col]==b[1][col] &&
            b[1][col]==b[2][col])
        {
            if (b[0][col]==player) {
              return 10;
            } else if (b[0][col]==opponent) {
              return -10;
            }
        }
    }
 
    // Checking for Diagonals for X or O victory.
    if (b[0][0]==b[1][1] && b[1][1]==b[2][2])
    {
        if (b[0][0]==player) {
          return 10;
        } else if (b[0][0]==opponent) {
          return -10;
        }
    }
 
    if (b[0][2]==b[1][1] && b[1][1]==b[2][0])
    {
        if (b[0][2]==player) {
          return 10;
        } else if (b[0][2]==opponent) {
          return -10;
        }
    }
 
    // Else if none of them have won then return 0
    return 0;
}
 
// This is the minimax function. It considers all
// the possible ways the game can go and returns
// the value of the board
int minimax(List<String> board, int depth, bool isMax)
{
    int score = evaluate(board);
 
    // If Maximizer has won the game return his/her
    // evaluated score
    if (score == 10) {
      return score;
    }
 
    // If Minimizer has won the game return his/her
    // evaluated score
    if (score == -10) {
      return score;
    }
 
    // If there are no more moves and no winner then
    // it is a tie
    if (isMovesLeft(board)==false) {
      return 0;
    }
 
    // If this maximizer's move
    if (isMax)
    {
        int best = -1000;
 
        // Traverse all cells
        for (int i = 0; i<3; i++)
        {
            for (int j = 0; j<3; j++)
            {
                // Check if cell is empty
                if (board[i][j]=='_')
                {
                    // Make the move
                    board[i] = board[i].substring(0, j) + player + board[i].substring(j+1);
                    //board[i][j] = player;
 
                    // Call minimax recursively and choose
                    // the maximum value
                    best = max( best,
                        minimax(board, depth+1, !isMax) );
 
                    // Undo the move
                    //board[i][j] = '_';
                    board[i] = board[i].substring(0, j) + '_' + board[i].substring(j+1);
                }
            }
        }
        return best - depth;
    }
 
    // If this minimizer's move
    else
    {
        int best = 1000;
 
        // Traverse all cells
        for (int i = 0; i<3; i++)
        {
            for (int j = 0; j<3; j++)
            {
                // Check if cell is empty
                if (board[i][j]=='_')
                {
                    // Make the move
                    //board[i][j] = opponent;
                    board[i] = board[i].substring(0, j) + opponent + board[i].substring(j+1);
 
                    // Call minimax recursively and choose
                    // the minimum value
                    best = min(best,
                           minimax(board, depth+1, !isMax));
 
                    // Undo the move
                    //board[i][j] = '_';
                    board[i] = board[i].substring(0, j) + '_' + board[i].substring(j+1);
                }
            }
        }
        return best + depth;
    }
}
 
// This will return the best possible move for the player
Offset findBestMove(List<String> board)
{
    int bestVal = -1000;
    Offset bestMove = Offset(-1, -1);
 
    // Traverse all cells, evaluate minimax function for
    // all empty cells. And return the cell with optimal
    // value.
    for (int i = 0; i<3; i++)
    {
        for (int j = 0; j<3; j++)
        {
            // Check if cell is empty
            if (board[i][j]=='_')
            {
                // Make the move
                //board[i][j] = player;
                board[i] = board[i].substring(0, j) + player + board[i].substring(j+1);

                // compute evaluation function for this
                // move.
                int moveVal = minimax(board, 0, false);

                // Undo the move
                //board[i][j] = '_';
                board[i] = board[i].substring(0, j) + '_' + board[i].substring(j+1);
 
                // If the value of the current move is
                // more than the best value, then update
                // best/
                if (moveVal > bestVal)
                {
                    bestMove = Offset(i.toDouble(),j.toDouble());
                    bestVal = moveVal;
                }
            }
        }
    }
 
    print("The value of the best Move is : " + bestVal.toString() + "\n\n");
 
    return bestMove;
}
}