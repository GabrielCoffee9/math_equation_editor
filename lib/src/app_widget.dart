import 'package:fluent_ui/fluent_ui.dart';

import 'view/home_page.dart';

class MathEquationApp extends StatelessWidget {
  const MathEquationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Equation Editor',
      theme: FluentThemeData(
        accentColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          filledButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
        ),
        toggleButtonTheme: ToggleButtonThemeData(
          uncheckedButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          checkedButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
