import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_chill/models/misc_methods.dart';

class SegmentedForm extends StatefulWidget {
  const SegmentedForm(
      {super.key,
      required this.tabItems,
      required this.items,
      required this.selectedIndex});

  @override
  State<SegmentedForm> createState() => _SegmentedFormState();
  final Function selectedIndex;
  final Map<int, String> tabItems;
  final List<Widget> items;
}

class _SegmentedFormState extends State<SegmentedForm> {
  int? _sliding = 0;
  late Map<int, Padding> newTabItems;

  @override
  Widget build(BuildContext context) {
    newTabItems = widget.tabItems.map((key, value) => MapEntry(
          key,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: _sliding == key ? Colors.black : Colors.white,
              ),
            ),
          ),
        ));
    logBuild(runtimeType);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSlidingSegmentedControl(
          backgroundColor: Theme.of(context)
              .segmentedButtonTheme
              .style!
              .backgroundColor!
              .resolve({MaterialState.selected}) as Color,
          thumbColor: Theme.of(context)
              .segmentedButtonTheme
              .style!
              .foregroundColor!
              .resolve({MaterialState.selected}) as Color,
          children: newTabItems,
          groupValue: _sliding,
          onValueChanged: (value) {
            setState(() {
              _sliding = value;
            });
            widget.selectedIndex(_sliding!);
          },
        ),
        const SizedBox(height: 5),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.items[_sliding!],
        )
      ],
    );
  }
}
