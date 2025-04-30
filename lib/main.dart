import 'package:bakeryadminapp/HomeScreens/provider/user_provider.dart';
import 'package:bakeryadminapp/firebase_options.dart';
import 'package:bakeryadminapp/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: "AIzaSyBma-vJige4ozn2JEw_Wz2Kpcwkzvd1rgE",
  //       authDomain: "groceryapp-a124b.firebaseapp.com",
  //       projectId: "groceryapp-a124b",
  //       storageBucket: "groceryapp-a124b.appspot.com",
  //       messagingSenderId: "700998957139",
  //       appId: "1:700998957139:web:b4385ad417e75812246ea6",
  //       measurementId: "G-CM4TXJVE4S",
  //     ),
  //   );
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 756),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
