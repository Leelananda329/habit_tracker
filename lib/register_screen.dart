import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/services/service.dart';
import 'constants/app_constants.dart';
import 'country_list.dart';
import 'habits/habit_tracker_screen.dart';
import 'local_storage.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  double _age = 25; // Default age set to 25
  String _country = 'United States';
  List<String> _countries = [];

  Map<String, String> selectedHabitsWithColors = {};

  bool _isLoading=false;
  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };

  String _getNextColorName() {
    // Simple logic to cycle through colors
    return _habitColors.keys.toList()[selectedHabitsWithColors.length % _habitColors.length];
  }
  List<String> availableHabits = [
    'Wake Up Early',
    'Workout',
    'Drink Water',
    'Meditate',
    'Read a Book',
    'Practice Gratitude',
    'Sleep 8 Hours',
    'Eat Healthy',
    'Journal',
    'Walk 10,000 Steps'
  ];

  @override
  void initState() {
    super.initState();
    _isLoading=true;
    _loadCountries();
  }


  Future<void> _loadCountries() async {
    try {
      List<String> countries = await fetchCountries();


      setState(() {
        _countries = countries;
        _countries.sort();
        _country = _countries.isNotEmpty ? _countries[0] : 'India';
        _isLoading=false;
      });
    } catch (e) {
      // Handle error
      _showToast('Error fetching countries');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _register() async {
    final name = _nameController.text;
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();



    LocalStorage storage=LocalStorage();
    storage.setName(name);
    storage.setUsername(name);


    final service = DatabaseServices();

    await service.registerUser(
      name: name,
      username: username,
      password: password,
      age: _age,
      country: _country,
      habits: selectedHabitsWithColors, // Pass only habit names
    );

    final result = await service.getUserWithHabits(username);

    if(result!=null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HabitTrackerScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          AppConstants.register,
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Stack(children: [

      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(_nameController, 'Name', Icons.person),
                const SizedBox(height: 10),
                _buildInputField(
                    _usernameController, 'Username', Icons.alternate_email),
                const SizedBox(height: 10),
                _buildPasswordInputField(),
                const SizedBox(height: 10),
                Text('Age: ${_age.round()}',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                Slider(
                  value: _age,
                  min: 21,
                  max: 100,
                  divisions: 79,
                  activeColor: Colors.blue.shade600,
                  inactiveColor: Colors.blue.shade300,
                  onChanged: (double value) {
                    setState(() {
                      _age = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildCountryDropdown(),
                const SizedBox(height: 10),
                const Text('Select Your Habits',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableHabits.map((habit) {
                    final isSelected = selectedHabitsWithColors.containsKey(habit);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedHabitsWithColors.remove(habit);
                          } else {
                            String nextColorName = _getNextColorName();
                            selectedHabitsWithColors[habit] = nextColorName;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? _habitColors[selectedHabitsWithColors[habit]] : Colors.white,
                          // color:
                          //     isSelected ? Colors.blue.shade600 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade700),
                        ),
                        child: Text(
                          habit,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: (){
                      if(validetion())
                      _register();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (_isLoading)
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
                strokeWidth: 5,
              ),
              SizedBox(height: 10),
              Text("Loading...", style: TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
        )],),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
          hintText: 'Password',
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.blue.shade700,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: _country,
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
        isExpanded: true,
        underline: const SizedBox(),
        items: _countries.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _country = newValue!;
          });
        },
      ),
    );
  }

  bool validetion() {
    if (_nameController.text.isEmpty) {
      _showToast('Please enter your name');
      return false;
    }
    if (_usernameController.text.isEmpty) {
      _showToast('Please enter your username');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showToast('Please enter your password');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showToast('Password must be at least 6 characters long');
      return false;
    }
    return true;
  }
}