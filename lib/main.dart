import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/customs/custom_transition.dart';
import 'package:taxi_chill/auth/auth.dart';
import 'package:taxi_chill/auth/register.dart';
import 'package:taxi_chill/home/home.dart';
import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/services/auth_service.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
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
    logInfo('Постройка главного виджета TaxiChill');

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
      // constraints: const BoxConstraints.expand(width: 100),
      contentPadding: const EdgeInsets.all(20),
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
    textTheme: GoogleFonts.nunitoTextTheme(
      Theme.of(context).textTheme.apply(bodyColor: Colors.white),
    ),
  );
}
