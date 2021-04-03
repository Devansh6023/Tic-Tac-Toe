import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board_tile.dart';
import 'package:tic_tac_toe/tile_state.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);

  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(child: Text('Tic Tac Toe', style: TextStyle(color: Colors.white),))),
        body: Center(
          child: Stack(children: [
            Image.asset('reqdimages/board4.png'),
            _boardTiles()
        ],
        ),
      ),
    );
  }
  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension/3;

      return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;
            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTile(
                  tileState: tileState,
                  dimension: tileDimension,
                  onPressed: () => _updateTileStateForIndex(tileIndex),
                );
              }).toList(),
            );
          }).toList()
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectIndex) {
    if (_boardState[selectIndex] == TileState.EMPTY){
      setState(() {
        _boardState[selectIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS ?
        TileState.ZERO :
        TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
       print('Winner is: $winner');
       _showWinnerDialog(winner);
      }
    }
  }

  TileState _findWinner() {
    TileState Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0,1,2),
      winnerForMatch(3,4,5),
      winnerForMatch(6,7,8),
      winnerForMatch(0,3,6),
      winnerForMatch(1,4,7),
      winnerForMatch(2,5,8),
      winnerForMatch(0,4,8),
      winnerForMatch(2,4,6),
    ];

    TileState winner;
    for (int i = 0; i < checks.length; i++){
      if (checks[i] != null){
        winner = checks[i];
        break;
      }
    }
    return winner;
  }

  void _showWinnerDialog(TileState tileState){

   // final context = navigatorKey.currentState.overlay.context;

    showDialog(
        context: context,
        builder: (_) {
      return AlertDialog(
        title: Text("Winner"),
        content: Image.asset(
          tileState == TileState.CROSS ? 'reqdimages/cross.png' : 'reqdimages/zero.png'
        ),
        actions: [
          new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
                },
              child: Text('New Game', style: TextStyle(color: Colors.black),))],
      );
    });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
