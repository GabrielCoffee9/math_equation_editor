import 'package:fluent_ui/fluent_ui.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Editor de equações matemáticas',
      theme: FluentThemeData(
        accentColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          filledButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
        ),
        toggleSwitchTheme: ToggleSwitchThemeData(
          checkedDecoration: WidgetStateProperty.all<Decoration>(
            BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
