import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> iconList = [];
  List<int> score = [];

  void resetQuiz() {
    setState(() {
      quizBrain.resetQuiz();
      iconList.clear();
      score.clear();
    });
  }

  void updateState({bool guess, bool answer}) {
    setState(() {
      if (guess == answer) {
        appendIconList(correct: true);
        score.add(1);
      } else {
        appendIconList(correct: false);
        score.add(0);
      }

      if (quizBrain.isLastQuestion()) {
        double finalScore = score.reduce((a, b) => a + b) / score.length * 100;
        Alert(
            context: context,
            title: finalScore.toStringAsFixed(1) + '%',
            desc: 'Lets play again!',
            buttons: [
              DialogButton(
                child: Text('Reset Quiz'),
                onPressed: () {
                  resetQuiz();
                  Navigator.pop(context);
                },
              )
            ]).show();
      }
      quizBrain.nextQuestion();
    });
  }

  void appendIconList({bool correct}) {
    if (correct) {
      iconList.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
    } else {
      iconList.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                updateState(guess: true, answer: quizBrain.getQuestionAnswer());
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                updateState(
                    guess: false, answer: quizBrain.getQuestionAnswer());
              },
            ),
          ),
        ),
        Row(children: iconList)
      ],
    );
  }
}

/*

*/
