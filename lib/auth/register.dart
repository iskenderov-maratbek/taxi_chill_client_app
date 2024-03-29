import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/auth/models/email_form.dart';
import 'package:taxi_chill/auth/models/password_form.dart';
import 'package:taxi_chill/auth/models/phone_number_form.dart';
import 'package:taxi_chill/auth/models/rules.dart';
import 'package:taxi_chill/auth/models/segmented_form.dart';
import 'package:taxi_chill/auth/models/username_form.dart';
import 'package:taxi_chill/auth/models/validators.dart';
import 'package:taxi_chill/auth/pin_code_dialog.dart';
import 'package:taxi_chill/models/dialog_forms.dart';
import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/models/page_builder.dart';
import 'package:taxi_chill/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  late AuthService authService;
  late Map<int, String> tabItems;
  late List<Widget> items;
  int _segmentedIndex = 0;
  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    super.initState();
  }

  _selectedIndex(int? index) {
    _segmentedIndex = index!;
  }

  @override
  void dispose() {
    logInfo('Disposing Auth State');
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  register() async {
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
          await authService.register(
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
              validator: Validators.email, controller: _emailController)),
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
              'Регистрация',
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
            const SizedBox(height: 20),
            PasswordTextField(
                controller: _passwordController,
                validator: Validators.password,
                hintText: 'Новый пароль'),
            const SizedBox(height: 10),
            ...passwordRules
                .map(
                  (key, value) => MapEntry(
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outlined,
                              color: value(
                                _passwordController.text,
                              )
                                  ? Colors.green
                                  : Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                key,
                                maxLines: 2,
                                style: TextStyle(
                                    color: value(
                                  _passwordController.text,
                                )
                                        ? Colors.green
                                        : Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    false,
                  ),
                )
                .keys
                .toList(),
            UsernameForm(
                validator: Validators.username,
                controller: _usernameController),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: register,
              child: const Text(
                'Завершить регистрацию',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Уже есть аккаунт? ',
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFBC02D).withOpacity(0.3)),
                  ),
                  onPressed: () {
                    DialogForms.showLoaderOverlay(
                        context: context,
                        run: () {
                          Navigator.pop(context, '/auth');
                        });
                  },
                  child: Text(
                    'Войти',
                    style: TextStyle(fontSize: 16, color: Colors.yellow[700]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
