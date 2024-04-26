import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/views/misc/custom_transition.dart';
import 'package:taxi_chill/views/auth/auth_view.dart';
import 'package:taxi_chill/views/auth/register_view.dart';
import 'package:taxi_chill/views/home/home.dart';
import 'package:taxi_chill/views/misc/misc_methods.dart';
import 'package:taxi_chill/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const TaxiChill(),
    ),
  );
}

class TaxiChill extends StatelessWidget {
  const TaxiChill({super.key});

  @override
  Widget build(BuildContext context) {
    logBuild('Запуск приложения TaxiChill');

    Map<String, Widget> onGenerateRoute = {
      '/home': const Home(),
      '/auth': const Auth(),
      '/register': const Register(),
    };
    return MaterialApp(
      onGenerateRoute: (settings) {
        return CustomRoute(
          builder: (context) => onGenerateRoute[settings.name]!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Taxi Chill',
      theme: theme(context),
      home:
          context.read<AuthService>().checkAuth() ? const Home() : const Auth(),
    );
  }
}

ThemeData theme(BuildContext context) {
  return ThemeData(
    fontFamily: 'MiSans',
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomTransition(),
        TargetPlatform.iOS: CustomTransition(),
        TargetPlatform.macOS: CustomTransition(),
        TargetPlatform.windows: CustomTransition(),
      },
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFFBC02D)),
    )),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.yellow[700],
      selectionColor: Colors.blue,
      selectionHandleColor: Colors.yellow[700],
    ),
    scaffoldBackgroundColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      prefixStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIconColor: Colors.white,
      filled: true,
      fillColor: Colors.grey[900],
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      border: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow[700]!, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red[700]!, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red[700]!, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(50, 70),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all<Color>(const Color(0xFFFBC02D)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFFBC02D)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> state) {
          if (state.contains(MaterialState.pressed)) {
            return Colors.grey[700];
          } else if (state.contains(MaterialState.selected)) {
            return Colors.black;
          }
          return Colors.black;
        }),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
