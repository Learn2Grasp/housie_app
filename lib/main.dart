import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Housie Number Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Housie Number Generator')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> numbersDone = new List();

  void generateRandomNumber() {
    if (this.numbersDone.length >= 90) {
      return;
    }

    int randomNumber = Random().nextInt(90) + 1;
    while (this.numbersDone.indexOf(randomNumber) >= 0) {
      randomNumber = Random().nextInt(90) + 1;
    }

    setState(() {
      this.numbersDone.insert(0, randomNumber);
    });
  }

  void reset() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Reset Conformation'),
        content: Text(
            'Do you want to reset the board? \nYou will lose all the generated numbers.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Accept'),
            color: Colors.red,
            onPressed: () {
              setState(() {
                this.numbersDone = new List();
              });
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget generateCell(int number) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            (this.numbersDone.indexOf(number) >= 0) ? Colors.red : Colors.blue,
      ),
      child: Center(child: Text('$number')),
    );
  }

  List<Widget> showGeneratedNumbers() {
    List<Widget> generatedNumberBalls = new List();

    for (int i = 0; i < this.numbersDone.length; i++) {
      generatedNumberBalls.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: generateCell(this.numbersDone[i]),
      ));
    }

    return generatedNumberBalls;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            crossAxisCount:
                (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? 5
                    : 10,
            childAspectRatio: 4 / 1,
            children: List.generate(90, (number) {
              return generateCell(number + 1);
            }),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: showGeneratedNumbers(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: generateRandomNumber,
                color: Colors.blue,
                child: Center(child: Text('Generate Number')),
              ),
              SizedBox(width: 10),
              RaisedButton(
                onPressed: reset,
                color: Colors.red,
                child: Center(child: Text('Reset')),
              )
            ],
          ),
        ],
      ),
    );
  }
}
