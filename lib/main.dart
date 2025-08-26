import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudum_kingdom/presentation/routes.dart';
import 'package:tudum_kingdom/presentation/theme/app_theme.dart'; // 👈 우리가 만든 테마 import!

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Tudum Kingdom',
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
