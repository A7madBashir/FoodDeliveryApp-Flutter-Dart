import 'package:flutter/material.dart';
import 'package:flutter_login_signup/GoogleMap/location_provider.dart';
import 'package:flutter_login_signup/screens/Card/orderProvider.dart';
import 'package:flutter_login_signup/screens/Card/purchases.dart';
import 'package:flutter_login_signup/screens/homepage/HomePage.dart';
import 'package:flutter_login_signup/Login_Signup/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Login_Signup/welcomePage.dart';
import 'package:http/http.dart' as http;

void main() async {
  //Check Every Time Customr Open The App if there data of his account and it was right it's will go to HomePage
  // else it will be go to Login screen To login again
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _chk = await SharedPreferences.getInstance();
  var token = _chk.getString("token");

  runApp(new MultiProvider(providers: [
    ChangeNotifierProvider.value(value: Purchasess()),
    ChangeNotifierProvider.value(value: LocationProvider()),
    ChangeNotifierProvider.value(value: Orders()),
  ], child: StartScreen()));

  if (await CheckCustomer(token) == true) {
    //HomePage
    runApp(new MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Purchasess()),
          ChangeNotifierProvider.value(value: LocationProvider()),
          ChangeNotifierProvider.value(value: Orders()),
        ],
        child:
            MaterialApp(debugShowCheckedModeBanner: false, home: HomePage())));
  } else {
    runApp(new MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Purchasess()),
          ChangeNotifierProvider.value(value: LocationProvider()),
          ChangeNotifierProvider.value(value: Orders()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false, home: WelcomePage())));
  }
}

Future<bool> CheckCustomer(String token) async {
  String url = "https://node-js-flutter.herokuapp.com/Customers/protected";
  final res = await http.get(
    url,
    headers: {"Content-Type": "application/json", "Authorization": "$token"},
  );
  if (res.statusCode == 201) {
    print("good");

    return true;
  } else {
    print("wrong");
    return false;
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Loading")
          ],
        ),
      )),
    );
  }
}
