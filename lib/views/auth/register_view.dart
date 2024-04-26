import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/views/forms/segmented_form.dart';
import 'package:taxi_chill/services/validator_service.dart';
import 'package:taxi_chill/views/forms/text_field_form.dart';
import 'package:taxi_chill/views/auth/pin_code_view.dart';
import 'package:taxi_chill/views/misc/dialog_forms.dart';
import 'package:taxi_chill/views/misc/misc_methods.dart';
import 'package:taxi_chill/views/auth/view_builder.dart';
import 'package:taxi_chill/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
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

  _selectedIndex(int? index) {
    _segmentedIndex = index!;
  }

  @override
  void dispose() {
    logDispose('Register');
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  register() async {
    switch (_segmentedIndex) {
      case 0:
        logInfo('Selected index SEGMENTED_MENU: $_segmentedIndex');
        DialogForms.showLoaderOverlay(
            context: context,
            run: () async {
              if (_emailKey.currentState!.validate() && mounted) {
                await authService.login(email: _emailController.text) && mounted
                    ? Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (Route<dynamic> route) => false,
                      )
                    : logError('Неправильный адрес');
              } else {
                logError('Некорректный адрес');
              }
            });
      case 1:
        await showPinCodeDialog(context);
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    logBuild('Regsiter');
    return PageBuilder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Регистрация',
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
          const SizedBox(height: 10),
          TextFieldForm(
            validator: Validators.username,
            controller: _usernameController,
            prefixIcon: Icons.person_rounded,
            maxLength: 32,
            hintText: 'Как к вам обращаться?',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: register,
            child: const Text(
              'Завершить регистрацию',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Уже есть аккаунт? ',
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.yellow[700]!.withOpacity(0.3)),
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
                  style: TextStyle(fontSize: 20, color: Colors.yellow[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
