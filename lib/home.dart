import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flying_pigs/barriers.dart';

import 'bird.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -3.5;
  double velocity = 1.5;
  bool gameHasStarted = false;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  late int score = 0;
  late int highscore = 0;

  static List<double> barrierX = [2, 3 + 1.5, 5.5 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.7, 0.3],
    [0.5, 0.2],
    //[0.8, 0.3],
  ];

  void startGame() {
    gameHasStarted = true;
    score = 0;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });

      if (birdisDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }

      moveMap();

      time += 0.01;
    });
  }

  moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void jump() {
    setState(() {
      score += 1;
      time = 0;
      initialPos = birdY;
    });

    if (score >= highscore) {
      highscore = score;
    }
  }

  resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdisDead() {
    if (birdY <= -1 || birdY >= 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] || birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (
          context,
        ) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Center(
              child: Image.asset('assets/images/game_over.png', width: 190),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  resetGame();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Text(
                      ' Start Again ',
                      style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        gameHasStarted ? jump() : startGame();
      },
      child: Scaffold(
        body: Column(children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.lightBlueAccent,
                child: Center(
                  child: Stack(
                    children: [
                      Bird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWith: birdWidth,
                      ),
                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? '' : 'T A P   T O   P L A Y',
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Barrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          isThisBottomBarrier: false),
                      Barrier(
                          barrierX: barrierX[0], barrierWidth: barrierWidth, barrierHeight: barrierHeight[0][1], isThisBottomBarrier: true),
                      Barrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false),
                      Barrier(
                          barrierX: barrierX[1], barrierWidth: barrierWidth, barrierHeight: barrierHeight[1][1], isThisBottomBarrier: true),
                      Barrier(
                          barrierX: barrierX[2],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false),
                      Barrier(
                          barrierX: barrierX[2], barrierWidth: barrierWidth, barrierHeight: barrierHeight[1][1], isThisBottomBarrier: true),
                    ],
                  ),
                ),
              )),
          Container(
            height: 10,
            color: Colors.greenAccent,
          ),
          Expanded(
              child: Container(
            color: Colors.brown,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/score.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    'Score',
                    style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(color: Colors.amber, fontSize: 35, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/top.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    'High Score',
                    style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    highscore.toString(),
                    style: TextStyle(color: Colors.amber, fontSize: 35, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ]),
          ))
        ]),
      ),
    );
  }
}

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   static double birdYaxis = 0;
//   double time = 0;
//   double height = 0;
//   late int score = 0;
//   late int highscore = 0;
//   double initialheight = birdYaxis;
//   bool gameHasStarted = false;
//   static double barrierX1 = 2;
//   static double barrierX2 = barrierX1 + 1.5;
//   double barrierX3 = barrierX2 + 1.5;
//
//   void jump() {
//     setState(() {
//       time = 0;
//       score += 1;
//       initialheight = birdYaxis;
//     });
//
//     if (score >= highscore) {
//       highscore = score;
//     }
//     // Timer.periodic(Duration(milliseconds: 50), (timer) {
//     //   time += 0.04;
//     //   height = -4.9 * time * time + 2.8 * time;
//     //   setState(() {
//     //     birdYaxis = initialheight - height;
//     //   });
//     //   if (birdYaxis > 0) {
//     //     timer.cancel();
//     //   }
//     // });
//   }
//
//   void startGame() {
//     gameHasStarted = true;
//     score = 0;
//
//     Timer.periodic(Duration(milliseconds: 50), (timer) {
//       time += 0.04;
//       height = -3.84 * time * time + 1.8 * time;
//       setState(() {
//         birdYaxis = initialheight - height;
//
//         if (pigIsDead()) {
//           timer.cancel();
//           gameHasStarted = false;
//           _showDialog();
//         }
//
//         if (barrierX1 < -1.1) {
//           barrierX1 += 5.0;
//         } else {
//           barrierX1 -= 0.05;
//         }
//
//         if (barrierX2 < -1.1) {
//           barrierX2 += 5.0;
//         } else {
//           barrierX2 -= 0.05;
//         }
//
//         if (barrierX3 < -1.1) {
//           barrierX3 += 5.0;
//         } else {
//           barrierX3 -= 0.05;
//         }
//       });
//     });
//   }
//
//   bool pigIsDead() {
//     if (birdYaxis > 1 || birdYaxis < -1) {
//       return true; // Bird hits the top or bottom edge of the screen
//     }
//
//     // Calculate the y-axis range for the gap in each barrier
//     // double barrierGap = .5;
//     // double barrierTopY1 = 200 + barrierGap / 2;
//     // double barrierBottomY1 = 200 - barrierGap / 2;
//     // double barrierTopY2 = 150 + barrierGap / 2;
//     // double barrierBottomY2 = 250 - barrierGap / 2;
//     // double barrierTopY3 = 280 + barrierGap / 2;
//     // double barrierBottomY3 = 150 - barrierGap / 2;
//     //
//     // // Check if the bird hits any of the barriers
//     // if ((birdYaxis < barrierTopY1 || birdYaxis > barrierBottomY1) &&
//     //     (birdYaxis < barrierTopY2 || birdYaxis > barrierBottomY2) &&
//     //     (birdYaxis < barrierTopY3 || birdYaxis > barrierBottomY3)) {
//     //   if ((barrierX1 < 0.1 && barrierX1 > -0.1) || (barrierX2 < 0.1 && barrierX2 > -0.1) || (barrierX3 < 0.1 && barrierX3 > -0.1)) {
//     //     return true; // Bird hits one of the barriers
//     //   }
//     // }
//
//     return false; // Bird doesn't hit any barriers
//   }
//
//   void reset() {
//     Navigator.pop(context);
//     setState(() {
//       birdYaxis = 0;
//       gameHasStarted = false;
//       time = 0;
//       initialheight = birdYaxis;
//     });
//   }
//
//   void _showDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (
//             context,
//             ) {
//           return AlertDialog(
//             backgroundColor: Colors.black54,
//             title: Center(
//               child: Image.asset('assets/images/game_over.png', width: 190),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap: reset,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(5),
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     color: Colors.white,
//                     child: Text(
//                       ' Start Again ',
//                       style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (gameHasStarted) {
//           jump();
//         } else {
//           startGame();
//         }
//       },
//       child: Scaffold(
//         body: Column(children: [
//           Expanded(
//               flex: 3,
//               child: Stack(
//                 children: [
//                   AnimatedContainer(
//                     alignment: Alignment(0, birdYaxis),
//                     color: Colors.lightBlueAccent,
//                     duration: Duration(milliseconds: 0),
//                     child: Bird(),
//                   ),
//                   Container(
//                     alignment: Alignment(0, 0.5),
//                     child: gameHasStarted ? Container() : Image.asset('assets/images/play.png'),
//                   ),
//                   AnimatedContainer(
//                     alignment: Alignment(barrierX1, 1.2),
//                     duration: Duration(milliseconds: 0),
//                     child: Barrier(size: 200.00),
//                   ),
//                   AnimatedContainer(
//                     alignment: Alignment(barrierX1, -1.3),
//                     duration: Duration(milliseconds: 0),
//                     child: Barrier(size: 200.00),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   AnimatedContainer(
//                     alignment: Alignment(barrierX2, 1.2),
//                     duration: Duration(milliseconds: 0),
//                     child: Barrier(size: 150.00),
//                   ),
//                   AnimatedContainer(
//                     alignment: Alignment(barrierX2, -1.3),
//                     duration: Duration(milliseconds: 0),
//                     child: Barrier(size: 250.00),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   AnimatedContainer(
//                     alignment: Alignment(barrierX3, 1.2),
//                     duration: Duration(milliseconds: 0),
//                     child: Barrier(size: 280.00),
//                   ),
//                   AnimatedContainer(
//                     alignment: Alignment(barrierX3, -1.3),
//                     duration: Duration(milliseconds: 0),
//                     child: Barrier(size: 150.00),
//                   ),
//                 ],
//               )),
//           Container(
//             height: 10,
//             color: Colors.greenAccent,
//           ),
//           Expanded(
//               child: Container(
//                 color: Colors.brown,
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/score.png',
//                         width: 30,
//                         height: 30,
//                       ),
//                       Text(
//                         'Score',
//                         style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         score.toString(),
//                         style: TextStyle(color: Colors.amber, fontSize: 35, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/top.png',
//                         width: 30,
//                         height: 30,
//                       ),
//                       Text(
//                         'High Score',
//                         style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         highscore.toString(),
//                         style: TextStyle(color: Colors.amber, fontSize: 35, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                 ]),
//               ))
//         ]),
//       ),
//     );
//   }
// }
