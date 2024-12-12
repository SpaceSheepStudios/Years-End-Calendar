import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // For decoding JSON data
import 'package:flutter/services.dart';  // For loading JSON data

class Present extends StatefulWidget {
  final int day;

  // Constructor for getting the day
  const Present({super.key, required this.day});

  @override
  _PresentState createState() => _PresentState();
}

class _PresentState extends State<Present> {
  bool _isChecked = false;

  Map<String, String> presents = {};  // Map for presents

  // Load the JSON data from the file
  // --- INFO ---
  // To add your own daily coupon text to the calender, add the string to the JSON file (assets/presents.JSON)
  // where the key is the day and the value is the coupon

  Future<void> _loadPresents() async {
    String data = await rootBundle.loadString('assets/presents.json');  // Load the JSON data from the file
    Map<String, dynamic> jsonResult = jsonDecode(data);  // Decode the JSON data
    setState(() {
      presents = jsonResult.map((key, value) => MapEntry(key, value.toString()));  // Map the JSON data to the Map
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();// Load saved checkbox state
    _loadPresents();  // Load JSON data
  }

  // get the present for the specific day
  String _getPresent(int day) {
    if (presents.containsKey(day.toString())) {
      return presents[day.toString()]!;  // returns the string text for the specific day
    }
    return 'It`s day $day!';  // Standard Message in case there is no matching Data in the JSON
  }

  // load the state of the checkbox
  Future<void> _loadCheckboxState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // load the state of the checkbox for the specific day
      _isChecked = prefs.getBool('day${widget.day}') ?? false;  // If there is no saved state, set the default value to false
    });
  }

  // save the state of the checkbox
  Future<void> _saveCheckboxState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('day${widget.day}', value);  // save the state of the checkbox for the specific day
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Day ${widget.day}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
        child: Column(
          children: [
            Container(
              child: Text(
                textAlign: TextAlign.center,
                _getPresent(widget.day),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      title: const Text(
                        'Coupon redeemed: ',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      checkColor: Colors.white,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),

                      value: _isChecked,  // use the saved state of the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;  // update the state of the checkbox
                          _saveCheckboxState(_isChecked);  // save the new state of the checkbox
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

