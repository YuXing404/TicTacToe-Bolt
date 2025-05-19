import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe Bolt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game state
  List<List<String?>> board = List.generate(3, (_) => List.filled(3, null));
  bool isPlayerXTurn = true; // X starts first
  List<Position> playerXMoves = [];
  List<Position> playerOMoves = [];
  String? winner;
  bool isDraw = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe Bolt'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _getStatusMessage(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Game board
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => _handleCellTap(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col] ?? '',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: board[row][col] == 'X' ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Reset button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _resetGame,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text(
                  'New Game',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage() {
    if (winner != null) {
      return 'Player $winner wins!';
    } else if (isDraw) {
      return 'Game ended in a draw!';
    } else {
      return 'Player ${isPlayerXTurn ? 'X' : 'O'}\'s turn';
    }
  }

  void _handleCellTap(int row, int col) {
    // Ignore taps if the game is over or the cell is already filled
    if (winner != null || isDraw || board[row][col] != null) {
      return;
    }

    setState(() {
      // Current player's symbol
      String symbol = isPlayerXTurn ? 'X' : 'O';
      
      // Place the symbol on the board
      board[row][col] = symbol;
      
      // Track the move
      Position newMove = Position(row, col);
      if (isPlayerXTurn) {
        playerXMoves.add(newMove);
        // Remove oldest move if we have more than 3
        if (playerXMoves.length > 3) {
          Position oldestMove = playerXMoves.removeAt(0);
          board[oldestMove.row][oldestMove.col] = null;
        }
      } else {
        playerOMoves.add(newMove);
        // Remove oldest move if we have more than 3
        if (playerOMoves.length > 3) {
          Position oldestMove = playerOMoves.removeAt(0);
          board[oldestMove.row][oldestMove.col] = null;
        }
      }
      
      // Check for win
      if (_checkWin(symbol)) {
        winner = symbol;
      } 
      // Check for draw - this is tricky in this variant, as the board keeps changing
      // We'll consider it a draw if all cells are filled and no winner
      else if (_isBoardFull()) {
        isDraw = true;
      }
      
      // Switch turns
      isPlayerXTurn = !isPlayerXTurn;
    });
  }

  bool _checkWin(String symbol) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == symbol && board[i][1] == symbol && board[i][2] == symbol) {
        return true;
      }
    }
    
    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] == symbol && board[1][i] == symbol && board[2][i] == symbol) {
        return true;
      }
    }
    
    // Check diagonals
    if (board[0][0] == symbol && board[1][1] == symbol && board[2][2] == symbol) {
      return true;
    }
    if (board[0][2] == symbol && board[1][1] == symbol && board[2][0] == symbol) {
      return true;
    }
    
    return false;
  }

  bool _isBoardFull() {
    for (var row in board) {
      for (var cell in row) {
        if (cell == null) {
          return false;
        }
      }
    }
    return true;
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, null));
      isPlayerXTurn = true;
      playerXMoves.clear();
      playerOMoves.clear();
      winner = null;
      isDraw = false;
    });
  }
}

// Helper class to track positions
class Position {
  final int row;
  final int col;
  
  Position(this.row, this.col);
}
