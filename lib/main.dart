import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  // This widget is the root of your application.
  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  double _loanAmount = 0;
  double _duration = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Car Loan and Mortgage Calculator"),
        ),
        body: Column(
          children: [
            Text("Select Car Loan or Mortgage"),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Icon(
                          Icons.car_rental,
                          size: 80
                        ),
                        Text("Car Loan")
                      ],
                    ),
                  )
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Icon(
                          Icons.house,
                          size: 80,
                        ),
                        Text("Mortgage")
                      ],
                    ),
                  )
                )
              ],
            ),
            Expanded(
              flex: 2,
              child: Card(
                child: Column(
                  children: [
                    Text("Select Loan or Mortgage Amount"),
                    Slider(
                      value: _loanAmount,
                      max: 400000,
                      divisions: 1000,
                      thumbColor: Colors.blue,
                      activeColor: Colors.lightBlue,
                      onChanged: (value) {
                        setState(() {
                          _loanAmount = value;
                        });
                      }
                    ),
                    Text("You selected £ ${_loanAmount.toStringAsFixed(0)}"),
                    Text("Select Duration"),
                    Slider(
                        value: _duration,
                        max: 25,
                        divisions: 25,
                        thumbColor: Colors.blue,
                        activeColor: Colors.lightBlue,
                        onChanged: (value) {
                          setState(() {
                            _duration = value;
                          });
                        }
                    ),
                    Text("You selected ${_duration.toStringAsFixed(0)} years")
                  ],
                ),
              ),
            ),
            Card(
              child: Row(
                children: [
                  Text("Your monthly repayment will be £${(_loanAmount * _duration).toStringAsFixed(0)}")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}