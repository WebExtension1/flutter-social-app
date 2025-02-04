import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  double _loanAmount = 0;
  double _duration = 1;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Your feed"),
      ),
      body: Column(
        children: [
          const Text("Select Car Loan or Mortgage"),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Column(
                    children: const [
                      Icon(Icons.car_rental, size: 80),
                      Text("Car Loan"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: const [
                      Icon(Icons.house, size: 80),
                      Text("Mortgage"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Card(
            child: Column(
              children: [
                const Text("Select Loan or Mortgage Amount"),
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
                  },
                ),
                Text("You selected £ ${_loanAmount.toStringAsFixed(0)}"),
                const Text("Select Duration"),
                Slider(
                  value: _duration,
                  max: 25,
                  min: 1,
                  divisions: 25,
                  thumbColor: Colors.blue,
                  activeColor: Colors.lightBlue,
                  onChanged: (value) {
                    setState(() {
                      _duration = value;
                    });
                  },
                ),
                Text("You selected ${_duration.toStringAsFixed(0)} years"),
              ],
            ),
          ),
          Card(
            child: Row(
              children: [
                Text(
                  "Your monthly repayment will be £${(_loanAmount * _duration).toStringAsFixed(0)}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}