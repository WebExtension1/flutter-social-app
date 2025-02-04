import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeBuild(),
    );
  }
}

class HomeBuild extends StatefulWidget {
  const HomeBuild({super.key});

  @override
  State<HomeBuild> createState() => HomeBuildState();
}

class HomeBuildState extends State<HomeBuild> {
  int selectedIndex = 0;

  static final List<Widget> pages = [
    const Home(),
    const Search(),
    const Messages(),
    const Profile(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.search),
            label: "Search"
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.message),
            label: "Messages"
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.person),
            label: "Profile"
          ),
        ],
      ),
    );
  }
}

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

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: Column(
          children: [
            Text("Search")
          ],
        )
    );
  }
}

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: Column(
        children: [
          Text("Messages")
        ],
      )
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
        body: Column(
          children: [
            Text("Profile")
          ],
        )
    );
  }
}