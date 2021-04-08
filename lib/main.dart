import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SnakeGame(),
    );
  }
}

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final snakePosition = [16, 17, 18, 19];
  var direction = Direction.right;

  void moveRight() {
    for (var i = 0; i < snakePosition.length; i++) {
      setState(() => snakePosition[i]++);
    }
  }

  void moveLeft() {
    for (var i = 0; i < snakePosition.length; i++) {
      setState(() => snakePosition[i]--);
    }
  }

  void moveUp() {
    final indexPosition = snakePosition.first;
    setState(() {
      snakePosition.add(
        snakePosition.first - 15 + snakePosition.length - 1,
      );
      snakePosition.remove(indexPosition);
    });
  }

  void moveDown() {
    final indexPosition = snakePosition.first;
    setState(() {
      snakePosition.add(
        snakePosition.first + 15 + snakePosition.length - 1,
      );
      snakePosition.remove(indexPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Timer.periodic(Duration(milliseconds: 300), (timer) {
            switch (direction) {
              case Direction.down:
                moveDown();
                break;
              case Direction.up:
                moveUp();
                break;
              case Direction.left:
                moveLeft();
                break;
              case Direction.right:
                moveRight();
                break;
              default:
            }
          });
        },
      ),
      appBar: AppBar(title: Text('Snake Game')),
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            setState(() => direction = Direction.left);
            moveLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            setState(() => direction = Direction.right);
            moveRight();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
            setState(() => direction = Direction.up);
            moveUp();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
            setState(() => direction = Direction.down);
            moveDown();
          }
        },
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 15 * 17,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 15,
          ),
          itemBuilder: (context, index) {
            final isSnakeSlithering = snakePosition.contains(index);
            return Container(
              margin: EdgeInsets.all(2.1),
              decoration: BoxDecoration(
                color: isSnakeSlithering ? Colors.white : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
