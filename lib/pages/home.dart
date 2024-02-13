import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int score1 = 0;
  int timerSeconds = 0;
  final Map<String, bool> score = {};
  final Map<String, Color> choices = {
    '🍎': Colors.red,
    '🐲': Colors.green,
    '🐳': Colors.blue,
    '🍌': Colors.yellow,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
  };
  int index = 0;
  final play = AudioPlayer();

  void startTimer() {
    const int gameTime = 10; // จำนวนวินาทีของเวลาที่กำหนด
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds < gameTime) {
          timerSeconds++;
        } else {
          timer.cancel(); // หยุดการนับเมื่อเวลาหมด
        }
      });
    });
  }

  void stopTimer() {
    timerSeconds = 0;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void resetGame() {
    score.clear();
    score1 = 0;
    index++;
    stopTimer();
    timerSeconds = 0;
  }

  Widget build(BuildContext context) {
    if (timerSeconds >= 10) {
      // เปลี่ยน 10 เป็นเวลาที่ต้องการ
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: TextStyle(fontSize: 32),
              ),
              ElevatedButton(
                onPressed: () {
                  resetGame(); // รีเซ็ตเกมเมื่อกดปุ่ม
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Point = $score1 ,Timer = $timerSeconds s'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((element) {
                return Expanded(
                  child: Draggable<String>(
                    data: element,
                    child: Movable(element),
                    feedback: Movable(element),
                    childWhenDragging: Movable('😈'),
                  ),
                );
              }).toList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choices.keys.map((element) {
                return buildTarget(element);
              }).toList()
                ..shuffle(Random(index)),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                score.clear();
                score1 = 0;
                index++;
                stopTimer();
                timerSeconds = 0;
              });
            }));
  }

  Widget buildTarget(emoji) {
    return DragTarget<String>(
      builder: (context, incoming, rejects) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text('Congratulations'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          play.play(AssetSource('soo.mp3'));
          score1++;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Movable extends StatelessWidget {
  final String emoji;
  Movable(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 150,
        padding: EdgeInsets.all(15),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 60),
        ),
      ),
    );
  }
}
