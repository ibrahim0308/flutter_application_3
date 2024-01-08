import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Make sure to replace 'firebase_options.dart' with the correct import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MacfitApp());
}

// Main application class
class MacfitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacFit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Initial route set to login page
      routes: {
        '/': (context) => MacfitHomePage(),
        '/login': (context) => LoginPage(), // Login route
        '/exercises': (context) => ExercisePage(),
        '/Rewards': (context) => RewardsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Login page
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

// Login form
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Function to handle login
  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MacfitHomePage()),
          );
        }
      } catch (e) {
        print('Login failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: $e'),
          duration: Duration(seconds: 5),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // Implement form fields for email and password
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              // Validate email
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              // Validate password
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _login(context);
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

// Home page
class MacfitHomePage extends StatefulWidget {
  @override
  _MacfitHomePageState createState() => _MacfitHomePageState();
}

class _MacfitHomePageState extends State<MacfitHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MacFit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  image: DecorationImage(
                      image: NetworkImage(
                        "https://www.macfitind.com/wp-content/uploads/2021/06/cropped-Macf-fit-icon.png",
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Text(
              'Welcome to Macfit, your Friend fitness tracking companion!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'MacFit is App to you if you believe in being fit, exercise and living the good life in every moment, you are in the right place',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/exercises');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lime,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Exercise',
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Rewards');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lime,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Rewards',
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              color: Color(0xDD000000),
              size: 24.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings,
              color: Color(0xDD000000),
              size: 24.0,
            ),
          )
        ],
      ),
    );
  }
}

// Exercise page
class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  // Function to save and earn points
  void saveAndEarnPoints() {
    // Add points and navigate to RewardsPage
    RewardsPage.rewardsPageState?.addPoints(10);
    Navigator.pushNamed(context, '/Rewards');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Page'),
      ),
      backgroundColor: Colors.greenAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header section with exercise suggestions
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.accessibility,
                  size: 100,
                  color: Colors.deepPurpleAccent,
                ),
                SizedBox(height: 16),
                Text(
                  'Sample Exercise Suggestions:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // List of exercise cards
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                ExerciseCard(
                  title: 'Push day',
                  link: 'https://www.youtube.com/watch?v=c3pbe3qzatQ&t=374s',
                ),
                ExerciseCard(
                  title: 'Pull day',
                  link: 'https://www.youtube.com/watch?v=spKGN0XzErU&t=9s',
                ),
                ExerciseCard(
                  title: 'Leg day',
                  link: 'https://www.youtube.com/watch?v=H6mRkx1x77k&t=11s',
                ),
              ],
            ),
          ),
          // Button to save and earn points
          ElevatedButton(
            onPressed: saveAndEarnPoints,
            child: Text('Save and Earn 10 Points'),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final String title;
  final String link;

  ExerciseCard({
    required this.title,
    required this.link,
  });

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Display exercise title
            Text(
              widget.title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            // Checkbox for completion and button to watch the video
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () => _launchUrl(widget.link),
                  child: Text('Watch The Video'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch a URL
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}

class RewardsPage extends StatefulWidget {
  static _RewardsPageState? rewardsPageState;

  @override
  _RewardsPageState createState() {
    rewardsPageState = _RewardsPageState();
    return rewardsPageState!;
  }
}

class _RewardsPageState extends State<RewardsPage> {
  int rewardsPoints = 0;

  // Function to add points and show a snackbar
  void addPoints(int points) {
    setState(() {
      rewardsPoints += points;
    });

    // Show a message
    _showSnackBar('You earned $points points!');
  }

  // Function to display a snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards Point'),
      ),
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display a star icon
            Icon(
              Icons.star_border_rounded,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 22),
            // Display rewards points
            Text(
              'Your Rewards Points:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '$rewardsPoints ',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              color: Color(0xDD000000),
              size: 24.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings,
              color: Color(0xDD000000),
              size: 24.0,
            ),
          )
        ],
      ),
    );
  }
}

// Global key for accessing RewardsPage state
final GlobalKey<_RewardsPageState> _globalKey = GlobalKey<_RewardsPageState>();
