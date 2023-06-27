import 'package:alarm_test/screens/dashboardScreen.dart';
import 'package:alarm_test/screens/signUpScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:alarm_test/screens/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  // await Alarm.init();

  runApp(const WeWake());
}

class WeWake extends StatelessWidget {
  const WeWake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WeWake',
        theme: ThemeData(
            brightness: Brightness.dark, focusColor: Colors.blue[700]),
        initialRoute: SplashScreen.route,
        home: SplashScreen(),
        routes: {
          SplashScreen.route: (context) => SplashScreen(),
          SignUpScreen.route: (context) => SignUpScreen(),
          DashboardScreen.route: (context) => DashboardScreen()
        });
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Alarm.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var ttl;

//   void _incrementCounter() async {
//     final now = DateTime.now();
//     DateTime dateTime =
//         DateTime(now.year, now.month, now.day, now.hour, now.minute + 2, 0, 0);
//     var alarmSettings = AlarmSettings(
//         id: 1,
//         dateTime: dateTime,
//         assetAudioPath: 'assets/nokia.mp3',
//         notificationTitle: 'Test Alarm',
//         notificationBody: 'Test alarm',
//         stopOnNotificationOpen: true);
//     print(dateTime);
//     await Alarm.set(alarmSettings: alarmSettings);
//     setState(() {
//       ttl = dateTime;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$ttl',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
