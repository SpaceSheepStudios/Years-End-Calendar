import 'package:flutter/material.dart';
import './utils/time.dart';
import 'calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Countdown _countdown;
  String _countdownText = ''; // Countdown text
  bool _isCountdownFinished = false; // Checks if Countdown is finished

  @override
  void initState() {
    super.initState();
    _isCountdownFinished = false;

    // TargetDate for Launch of Calendar (30.11 of this year, 23:59:59)
    final DateTime targetStartDate = DateTime.utc(DateTime.now().year, DateTime.november, 30, 23, 59, 59);

    // --- DEBUG ---
    // TargetDate for Debugging Calendar (now):
    //final DateTime targetStartDate = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 59, 59);

    // define Countdown
    _countdown = Countdown(targetStartDate);

      // start countdown
      _countdown.startCountdown((String countdownText) {
        setState(() {
          _countdownText = countdownText; // update countdown text

          // Show button if countdown finished
          if (_countdownText == 'Countdown finished!') {
            _isCountdownFinished = true;
          }
        });
      });
  }

  @override
  void dispose() {
    _countdown.stopCountdown();
    super.dispose();
  }

  void _onCalButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Calendar(ishistory: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // if needed add AppBar here
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'The',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  ),
                  Text(
                    'Year\'s End',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    'Calendar',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      DateTime.now().year.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  ),
                  Center(
                    child: _isCountdownFinished
                      ? Container(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      )
                      : Text(
                      textAlign: TextAlign.center,
                      'starts in:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  ),
                  Center(
                    child: _isCountdownFinished
                        ? SizedBox(
                          height:100,
                          width:280,
                          child: ElevatedButton(
                              onPressed: _onCalButtonPressed,
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Open Calendar',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                          ),
                        )
                        : Text(
                          _countdownText, // show countdown as string
                          style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  ),
                  Center(
                  child: _isCountdownFinished
                    ? null
                    // After the first year of using the app, if you want to use the app the following year without erasing last year`s coupons, uncomment the History Button here to
                    // access last year`s coupons even if the new calendar is already available
                    : null // If needed uncomment History Button here & delete "null"
                    /*
                    SizedBox(
                      height:80,
                      width:260,
                      child: ElevatedButton(
                        onPressed: _onHisButtonPressed,
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          'History',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    ) */
                    
                  )
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}