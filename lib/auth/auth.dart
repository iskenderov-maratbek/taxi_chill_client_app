import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/auth/models/email_form.dart';
import 'package:taxi_chill/auth/models/password_form.dart';
import 'package:taxi_chill/auth/models/phone_number_form.dart';
import 'package:taxi_chill/auth/pin_code_dialog.dart';
import 'package:taxi_chill/models/dialog_forms.dart';
import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/models/page_builder.dart';
import 'package:taxi_chill/auth/models/segmented_form.dart';
import 'package:taxi_chill/auth/models/validators.dart';
import 'package:taxi_chill/services/auth_service.dart';
import 'package:taxi_chill/services/gql_service.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: 'marat4@mail.ru');
  final TextEditingController _passwordController =
      TextEditingController(text: 'inane745');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '0553998299');
  late AuthService authService;
  late Map<int, String> tabItems;
  late List<Widget> items;
  int _segmentedIndex = 0;

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    logInfo('Disposing Auth State');
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _selectedIndex(int? index) {
    _segmentedIndex = index!;
    logInfo('Selected index: $_segmentedIndex');
  }

  login() async {
    bool allValidators = false;
    DialogForms.showLoaderOverlay(
      context: context,
      run: () async {
        //Segmented selected Form check
        switch (_segmentedIndex) {
          case 0:
            logInfo('_segmentedIndex: $_segmentedIndex');
            allValidators = _emailKey.currentState!.validate();
          case 1:
            logInfo('_segmentedIndex: $_segmentedIndex');
            allValidators = _phoneNumberKey.currentState!.validate();
          default:
            logError('_segmentedIndex: $_segmentedIndex');
            allValidators = false;
        }
        // Other forms check
      },
    );
    if (allValidators && _globalKey.currentState!.validate()) {
      switch (_segmentedIndex) {
        case 0:
          break;
        case 1:
          allValidators = await showPinCodeDialog(context);
        default:
      }
      if (allValidators &&
          await authService.login(
              email: _emailController.text,
              password: _passwordController.text) &&
          mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      }
      logInfo('Успешно!');
    }
  }

  @override
  Widget build(BuildContext context) {
    tabItems = {
      0: 'Почта',
      1: 'Номер телефона',
    };
    items = [
      Form(
        key: _emailKey,
        child: EmailForm(
            validator: Validators.email, controller: _emailController),
      ),
      Form(
        key: _phoneNumberKey,
        child: PhoneNumberForm(
            validator: Validators.phoneNumber,
            controller: _phoneNumberController),
      )
    ];
    logInfo(runtimeType);
    return PageBuilder(
      child: Form(
        key: _globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Вход',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 20),
            SegmentedForm(
              tabItems: tabItems,
              items: items,
              selectedIndex: _selectedIndex,
            ),
            const SizedBox(height: 5),
            PasswordTextField(
                controller: _passwordController,
                validator: Validators.password),
            Center(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.blue.withOpacity(0.3)),
                ),
                onPressed: () {
                  DialogForms.showLoaderOverlay(
                    context: context,
                    run: () {
                      Navigator.pushNamed(context, '/restore');
                    },
                  );
                },
                child: const Text(
                  'Забыли пароль?',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: login,
              child: const Text(
                'Войти',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Нет аккаунта? ',
                ),
                TextButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Color(0xFFFBC02D), width: .5)),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFBC02D).withOpacity(0.3)),
                  ),
                  onPressed: () {
                    DialogForms.showLoaderOverlay(
                        context: context,
                        run: () {
                          Navigator.pushNamed(context, '/register');
                        });
                  },
                  child: Text(
                    'Создать аккаунт',
                    style: TextStyle(fontSize: 16, color: Colors.yellow[700]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    tooltip: 'Войти через Apple',
                    icon: Image.asset(
                      'assets/images/apple_auth.png',
                      width: 35,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    tooltip: 'Войти через Google',
                    icon: Image.asset(
                      'assets/images/google_auth.png',
                      width: 35,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                    ),
                    onPressed: () {
                      gqlrequest('''
                              query {
                                    hello
                                    }
                                 ''');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
