import 'package:fluent_ui/fluent_ui.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Editor de equações matemáticas',
      theme: FluentThemeData(accentColor: Colors.blue),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.green,
      ),
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}
