import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/animations/custom_transition.dart';
import 'package:taxi_chill/auth/auth.dart';
import 'package:taxi_chill/auth/register.dart';
import 'package:taxi_chill/auth/restore.dart';
import 'package:taxi_chill/firebase_options.dart';
import 'package:taxi_chill/home/home.dart';
import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/services/auth_service.dart';

final HttpLink httpLink = HttpLink('http://192.168.8.100:3000/graphql');
final ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);
Future<void> main() async {
  logInfo('Запуск... метод main');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const TaxiChill(),
    ),
  );
}

class TaxiChill extends StatefulWidget {
  const TaxiChill({super.key});

  @override
  State<TaxiChill> createState() => _TaxiChillState();
}

class _TaxiChillState extends State<TaxiChill> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logInfo('Постройка главного виджета TaxiChill');
    Map<String, Widget> onGenerateRoute = {
      '/home': const Home(),
      '/auth': const Auth(),
      '/register': const Register(),
      '/restore': const Restore(),
    };
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          return CustomRoute(
            builder: (context) => onGenerateRoute[settings.name]!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Taxi Chill',
        theme: theme(context),
        home: context.read<AuthService>().checkAuth()
            ? const Home()
            : const Auth(),
      ),
    );
  }
}

ThemeData theme(BuildContext context) {
  return ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomTransition(),
        TargetPlatform.iOS: CustomTransition(),
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
      hintStyle:
          const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      floatingLabelStyle: TextStyle(
        fontSize: 20,
        color: Colors.yellow[700],
      ),
      suffixIconColor: Colors.white,
      filled: true,
      fillColor: Colors.grey[900],
      labelStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFBC02D)),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFBC02D)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFBC02D)),
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
