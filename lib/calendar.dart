import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'present.dart';

class Calendar extends StatefulWidget {
  final bool ishistory;

  const Calendar({super.key, required this.ishistory});

  @override
  State<Calendar> createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  bool _isAvailable = false;
  int day = DateTime.now().day;

  // Set to store the clicked days
  Set<int> _clickedDays = {};

  // Loads the clicked days from SharedPreferences
  Future<void> _loadClickedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? clickedDaysStringList = prefs.getStringList('clickedDays');
    if (clickedDaysStringList != null) {
      setState(() {
        _clickedDays = clickedDaysStringList.map((e) => int.parse(e)).toSet();
      });
    }
  }

  // Saves the clicked days to SharedPreferences
  Future<void> _saveClickedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> clickedDaysStringList = _clickedDays.map((e) => e.toString()).toList();
    await prefs.setStringList('clickedDays', clickedDaysStringList);
  }

  // Resets the clicked days in SharedPreferences
  Future<void> _resetClickedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('clickedDays');
    setState(() {
      _clickedDays.clear();  // Clears the clicked days
    });
  }

  bool _CheckAvailability(i, day) {
    _isAvailable = false;
    if (day < i) {
      return _isAvailable = false;
    }
    return _isAvailable = true;
  }

  @override
  void initState() {
    super.initState();
    _loadClickedDays();
    //_resetClickedDays(); // uncomment this line for debugging (resetting already clicked days)
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    int displayYear = widget.ishistory ? DateTime.now().year - 1 : DateTime.now().year;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          displayYear.toString(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  _CheckAvailability(index + 1, day);
                  bool isClicked = _clickedDays.contains(index + 1); // Checks if the day was clicked

                  return GestureDetector(
                    onTap: _isAvailable
                        ? () {
                      setState(() {
                        _clickedDays.add(index + 1);
                        _saveClickedDays();
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Present(day: index + 1),
                        ),
                      );
                    }
                        : null,
                    child: Card(
                      color: isClicked
                          ? Theme.of(context).colorScheme.inversePrimary // Darker color if the day was clicked
                          : (_isAvailable
                          ? const Color(0xFF0097A7) // Blue if available
                          : Colors.white10), // Grey if not available
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: (width / 100),
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  _CheckAvailability(index + 31, day);
                  bool isClicked = _clickedDays.contains(index + 31); // Checks if the day was clicked

                  return GestureDetector(
                    onTap: _isAvailable
                        ? () {
                      setState(() {
                        _clickedDays.add(index + 31);
                        _saveClickedDays();  // Saves the clicked days
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Present(day: index + 1),
                        ),
                      );
                    }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Card(
                        color: isClicked
                            ? Theme.of(context).colorScheme.inversePrimary // Darker color if the day was clicked
                            : (_isAvailable
                            ? const Color(0xFF0097A7) // Blue if available
                            : Colors.white10), // Grey if not available
                        child: Center(
                          child: Text(
                            (index + 31).toString(),
                            style: const TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
