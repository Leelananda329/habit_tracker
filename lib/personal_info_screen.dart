import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/app_database/app_database.dart';
import 'package:habit_tracker/app_utils/app_utils.dart';
import 'package:habit_tracker/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_constants.dart';
import 'country_list.dart';
import 'local_storage.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  double _age = 25;
  String _country = 'India';
  List<String> _countries = [];
  DatabaseServices dataService = DatabaseServices();
  int userID=-1;

  User? userDetail;
  bool _isLoading=false;
  @override
  void initState() {
    super.initState();
    _loadCountries().then((_) {
      _loadUserData();
    });
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading=true;
    });
    try {
      List<String> countries = await fetchCountries();
      setState(() {
        _countries = countries;
      });
    } catch (e) {
      // Handle error
      _showToast('Error fetching countries');
    }
  }

  Future<void> _loadUserData() async {


    userID=LocalStorage().getUserID()??-1;
    userDetail= await dataService.getUserById(userID);

    setState(() {

      _nameController.text = userDetail?.name ?? '';
      _usernameController.text = userDetail?.username ?? '';
      _age = userDetail?.age ?? 25;
      _country = userDetail?.country ?? 'India';
      _isLoading=false;
    });
  }

  Future<void> _saveUserData() async {
    // Create a User object with the updated information
    User updatedUser = User(
      id: userID, // Assuming userID is the id of the user being updated
      name: _nameController.text,
      username: _usernameController.text.toString().trim(),
      age: _age,
      country: _country,
      password: userDetail?.password??'',
    );


    await dataService.updateUser(updatedUser);

    LocalStorage().setUsername( _usernameController.text);
    LocalStorage().setName( _nameController.text);

    Fluttertoast.showToast(
      msg: "Profile updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Pass back the updated name
    Navigator.pop(context, _nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(AppConstants.profileInfo,style: TextStyle(color: Colors.white,fontSize: 16),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),

      ),
      body:
      SingleChildScrollView(
        child: !_isLoading
            ?
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 42),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                icon: Icons.alternate_email,
              ),
              const SizedBox(height: 16),
              Text(
                'Age: ${_age.round()}',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 18),
              ),
              Slider(
                value: _age,
                min: 21,
                max: 100,
                divisions: 79,
                activeColor: Colors.blue.shade600,
                inactiveColor: Colors.blue.shade300,
                onChanged: (value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.shade700),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: _country,
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
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (){
                  if (validateFields()) {
                    _saveUserData();
                  }},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  elevation: 5,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
        : const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            backgroundColor: Colors.white,
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
        required String label,
        required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade700),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
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

  bool validateFields() {
    if (_nameController.text.trim().isEmpty) {
      AppUtils().showErrorToast('Name cannot be empty');
      return false;
    }
    if (_usernameController.text.trim().isEmpty) {
      AppUtils().showErrorToast('Username cannot be empty');
      return false;
    }
    if (_country.isEmpty) {
      AppUtils().showErrorToast('Please select a country');
      return false;
    }
    return true;
  }
}