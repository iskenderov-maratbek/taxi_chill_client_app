import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/auth/models/email_form.dart';
import 'package:taxi_chill/auth/models/phone_number_form.dart';
import 'package:taxi_chill/auth/models/segmented_form.dart';
import 'package:taxi_chill/auth/models/validators.dart';
import 'package:taxi_chill/auth/pin_code_dialog.dart';
import 'package:taxi_chill/models/dialog_forms.dart';
import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/models/page_builder.dart';
import 'package:taxi_chill/services/auth_service.dart';

class Restore extends StatefulWidget {
  const Restore({super.key});

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late AuthService authService;
  late Map<int, String> tabItems;
  late List<Widget> items;
  int _segmentedIndex = 0;

  get text => null;

  @override
  void initState() {
    authService = context.read<AuthService>();
    super.initState();
  }

  _selectedIndex(int? index) {
    _segmentedIndex = index!;
  }

  @override
  void dispose() {
    logInfo('Disposing в окне восстановления....');
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  restore() async {
    bool allValidators = false;
    logInfo(allValidators);
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
    logInfo('Check valodators fo to do: $allValidators');
    if (allValidators) {
      if (_segmentedIndex == 0) {
        allValidators = await authService.restore(_emailController.text);
        logInfo('Send code: $allValidators');
        if (mounted) {
          DialogForms.showInteractiveDialog(
              context: context,
              icon: const Icon(
                Icons.mark_email_read_rounded,
              ),
              text: const Text(
                'На вашу почту отправлено письмо. Ожидаем подтверждения...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              cancelButton: () {});
        }
      } else {
        allValidators = await showPinCodeDialog(context);
      }
      logInfo('Успешно!');
    } else {
      logError('Валидаторы невалидны');
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Восстановление',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
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
          ElevatedButton(
            onPressed: restore,
            child: const Text(
              'Восстановить',
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
    );
  }
}
