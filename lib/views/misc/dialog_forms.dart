import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taxi_chill/views/misc/loader.dart';
import 'package:taxi_chill/views/misc/misc_methods.dart';

class DialogForms {
  DialogForms._();

  static showInteractiveDialog({
    required BuildContext context,
    required Widget icon,
    required Text text,
    cancelButton,
    backFunctionText = 'Назад',
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: icon,
              content: text,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    cancelButton();
                    Navigator.pop(context);
                  },
                  child: Text(backFunctionText),
                ),
              ],
              actionsOverflowAlignment: OverflowBarAlignment.center,
            ),
          ),
        );
      },
    );
  }

  static void showInformationOverlay({
    required BuildContext context,
    required Widget widget,
    required Text text,
  }) async {
    logInfo('Показываем информационное окно');
    OverlayEntry? overlayEntry;
    remove() {
      if (overlayEntry!.mounted) {
        overlayEntry.remove();
      }
    }

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onDoubleTap: remove,
        child: Align(
          alignment: Alignment.center,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.7),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget,
                    text,
                    const Text('Нажмите два раза чтобы закрыть'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  static Future<void> showLoaderOverlay({
    required BuildContext context,
    required Function run,
  }) async {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            body: const Center(
              child: Loader(),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);
    await run();
    overlayEntry.remove();
  }
}
