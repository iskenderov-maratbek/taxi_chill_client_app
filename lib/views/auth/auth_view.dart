import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/views/forms/text_field_form.dart';
import 'package:taxi_chill/views/auth/pin_code_view.dart';
import 'package:taxi_chill/views/misc/dialog_forms.dart';
import 'package:taxi_chill/views/misc/misc_methods.dart';
import 'package:taxi_chill/views/auth/view_builder.dart';
import 'package:taxi_chill/views/forms/segmented_form.dart';
import 'package:taxi_chill/services/validator_service.dart';
import 'package:taxi_chill/services/auth_service.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  late AuthService authService;
  late Map<int, String> tabItems;
  late List<Widget> items;
  int _segmentedIndex = 0;

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    tabItems = {
      0: 'Почта',
      1: 'Номер телефона',
    };
    items = [
      Form(
        key: _emailKey,
        child: TextFieldForm(
          maxLength: 320,
          prefixIcon: Icons.email_rounded,
          hintText: 'example@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
          controller: _emailController,
        ),
      ),
      Form(
        key: _phoneNumberKey,
        child: TextFieldForm(
          maxLength: 10,
          prefixIcon: Icons.dialpad_rounded,
          hintText: '0553998299',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: Validators.phoneNumber,
          controller: _phoneNumberController,
        ),
      )
    ];
    super.initState();
  }

  @override
  void dispose() {
    logDispose('Страница Auth');
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  _selectedIndex(int? index) {
    _segmentedIndex = index!;
  }

  login() async {
    switch (_segmentedIndex) {
      case 0:
        logInfo('Выбранное меню: $_segmentedIndex');
        DialogForms.showLoaderOverlay(
            context: context,
            run: () async {
              if (_emailKey.currentState!.validate() &&
                  mounted &&
                  await authService.login(email: _emailController.text)) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (Route<dynamic> route) => false,
                );
              }
            });
      case 1:
        await showPinCodeDialog(context);
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    logBuild('Auth');
    return PageBuilder(
      canPop: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Вход',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 20),
          SegmentedForm(
            sizedBox: 5,
            tabItems: tabItems,
            items: items,
            selectedIndex: _selectedIndex,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            ),
            onPressed: login,
            child: const Text(
              'Войти',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.white)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(50, 50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icons/apple_auth.png',
                      width: 30,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                      child: Text(
                        'Войти c помощью Apple',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(50, 50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icons/google_auth.png',
                      width: 30,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                        child: Text(
                      'Войти c помощью Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(
            indent: 15,
            endIndent: 15,
            color: Colors.white54,
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.yellow[700]!.withOpacity(0.3)),
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pushNamed(
                context,
                '/register',
              );
            },
            child: Text(
              'Регистация',
              style: TextStyle(fontSize: 20, color: Colors.yellow[700]),
            ),
          ),
        ],
      ),
    );
  }
}
