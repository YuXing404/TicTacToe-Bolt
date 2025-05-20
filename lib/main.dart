import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe Bolt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          secondary: Colors.amber,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          secondary: Colors.amber,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bolt,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tic Tac Toe Bolt',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // In HomeScreen's build method:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo and Title
              Hero(
                tag: 'logo',
                child: Icon(
                  Icons.bolt,
                  size: 80,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tic Tac Toe Bolt',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The fast-paced twist on a classic game',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildButton(
                      context,
                      'Play Game',
                      Icons.play_arrow_rounded,
                      () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const GameScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      'How to Play',
                      Icons.help_outline,
                      () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const HowToPlayScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      Colors.white,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color == Colors.white ? Theme.of(context).colorScheme.primary : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildInstructionCard(
                context,
                'The Basics',
                'Tic Tac Toe Bolt is a twist on the classic game where players take turns placing X or O on a 3x3 grid.',
                Icons.grid_3x3,
              ),
              _buildInstructionCard(
                context,
                'The Twist',
                'Each player can only have their last THREE moves active on the board at any time.',
                Icons.bolt,
              ),
              _buildInstructionCard(
                context,
                'Disappearing Moves',
                'When you make your fourth move, your first move disappears from the board. As you continue playing, your oldest move always gets removed.',
                Icons.auto_delete,
              ),
              _buildInstructionCard(
                context,
                'Winning',
                'The goal is still to get three in a row (horizontally, vertically, or diagonally), but it has to be done with your current active moves.',
                Icons.emoji_events,
              ),
              _buildInstructionCard(
                context,
                'Strategy',
                'Since moves disappear, you need to think ahead and plan your strategy carefully. Block your opponent while setting up your own winning moves!',
                Icons.psychology,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Got it!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInstructionCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game state
  List<List<String?>> board = List.generate(3, (_) => List.filled(3, null));
  bool isPlayerXTurn = true; // X starts first
  List<Position> playerXMoves = [];
  List<Position> playerOMoves = [];
  String? winner;
  bool isDraw = false;
  
  // Animation controllers
  late AnimationController _boardController;
  late List<List<AnimationController>> _cellControllers;
  late AnimationController _winnerController;
  
  // Animations
  late Animation<double> _boardScaleAnimation;
  late Animation<double> _winnerScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize board animation
    _boardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _boardScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _boardController, curve: Curves.elasticOut),
    );
    
    // Initialize cell animations
    _cellControllers = List.generate(
      3,
      (_) => List.generate(
        3,
        (_) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      ),
    );
    
    // Initialize winner animation
    _winnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _winnerScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _winnerController, curve: Curves.elasticOut),
    );
    
    // Start board animation
    _boardController.forward();
  }

  @override
  void dispose() {
    _boardController.dispose();
    for (var row in _cellControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    _winnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Tic Tac Toe Bolt',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _resetGame,
                    ),
                  ],
                ),
              ),
              
              // Player Turn Indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPlayerIndicator('X', isPlayerXTurn, Colors.blue),
                    _buildPlayerIndicator('O', !isPlayerXTurn, Colors.red),
                  ],
                ),
              ),
              
              // Game status
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  key: ValueKey<String>(_getStatusMessage()),
                  child: Text(
                    _getStatusMessage(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: winner != null
                          ? (winner == 'X' ? Colors.blue : Colors.red)
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              
              // Game board
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _boardController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _boardScaleAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      margin: const EdgeInsets.all(16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            physics: const NeverScrollableScrollPhysics(),
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
                              return _buildCell(row, col);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Game controls
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      context,
                      'New Game',
                      Icons.refresh,
                      _resetGame,
                    ),
                    _buildControlButton(
                      context,
                      'How to Play',
                      Icons.help_outline,
                      () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const HowToPlayScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerIndicator(String player, bool isActive, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Text(
            'Player $player',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActive ? color : Colors.grey,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    final cellValue = board[row][col];
    final isNewMove = (cellValue != null) && (
      (isPlayerXTurn && playerOMoves.isNotEmpty && 
       playerOMoves.last.row == row && playerOMoves.last.col == col) ||
      (!isPlayerXTurn && playerXMoves.isNotEmpty && 
       playerXMoves.last.row == row && playerXMoves.last.col == col)
    );
    
    if (cellValue != null && isNewMove) {
      _cellControllers[row][col].forward(from: 0.0);
    }
    
    return GestureDetector(
      onTap: () => _handleCellTap(row, col),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: cellValue == null
            ? null
            : AnimatedBuilder(
                animation: _cellControllers[row][col],
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0,
                    child: child,
                  );
                },
                child: Center(
                  child: cellValue == 'X'
                      ? CustomPaint(
                          size: const Size(40, 40),
                          painter: XPainter(Colors.blue),
                        )
                      : CustomPaint(
                          size: const Size(40, 40),
                          painter: OPainter(Colors.red),
                        ),
                ),
              ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        
        // Trigger animation for the new move
        _cellControllers[row][col].reset();
        _cellControllers[row][col].forward();
      } else {
        playerOMoves.add(newMove);
        // Remove oldest move if we have more than 3
        if (playerOMoves.length > 3) {
          Position oldestMove = playerOMoves.removeAt(0);
          board[oldestMove.row][oldestMove.col] = null;
        }
        
        // Trigger animation for the new move
        _cellControllers[row][col].reset();
        _cellControllers[row][col].forward();
      }
      
      // Check for win
      if (_checkWin(symbol)) {
        winner = symbol;
        _winnerController.forward();
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
      
      // Reset animations
      _boardController.reset();
      _boardController.forward();
      
      for (var row in _cellControllers) {
        for (var controller in row) {
          controller.reset();
        }
      }
      
      _winnerController.reset();
    });
  }
}

// Custom painters for X and O
class XPainter extends CustomPainter {
  final Color color;
  
  XPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );
    
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OPainter extends CustomPainter {
  final Color color;
  
  OPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.35,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper class to track positions
class Position {
  final int row;
  final int col;
  
  Position(this.row, this.col);
}