import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/auth/models/segmented_form.dart';
import 'package:taxi_chill/auth/models/text_field_auth.dart';
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
        child: TextFieldAuth(
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
        child: TextFieldAuth(
          maxLength: 9,
          prefixImg: 'assets/images/icons/kg_flag.png',
          prefixText: '+996',
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
    logInfo('Disposing Register State');
    _emailController.dispose();
    _phoneNumberController.dispose();
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
    if (allValidators) {
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
              username: _usernameController.text) &&
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
    logInfo(runtimeType);
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
          const SizedBox(height: 15),
          UsernameForm(
              validator: Validators.username, controller: _usernameController),
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
