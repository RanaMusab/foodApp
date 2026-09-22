import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/sizing.dart';

import '../resources/resources.dart';

class CustomDatePicker extends StatefulWidget {
  DateTime selectedDate;
  final ValueChanged<DateTime> onSelectedItemChanged;

   CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onSelectedItemChanged,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime currentTime =  DateTime.now().subtract(const Duration(days: 365 * 10));
  final List<int> days = List.generate(31, (index) => index + 1);

  final List<String> months = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  late List<int> years;

  late int day;
  late int month;
  late int year;

  @override
  void initState() {
    super.initState();
    day = widget.selectedDate.day;
    years = List.generate(90, (index) => currentTime.year - index);
    month = widget.selectedDate.month;

    year = widget.selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day Picker
          buildPicker(
            items: days.map((d) => d.toString()).toList(),
            selectedIndex: widget.selectedDate.day - 1,
            onSelectedItemChanged: (index) {
              day = days[index];
              widget.selectedDate = DateTime(
                year = year,
                month = month,
                day = days[index],
              );
              widget.onSelectedItemChanged(widget.selectedDate);
            },
          ),
          SizedBox(width: 10.w),
          // Month Picker
          buildPicker(
            items: months,
            selectedIndex: widget.selectedDate.month - 1,
            onSelectedItemChanged: (index) {
              month = index + 1;
              widget.selectedDate = DateTime(
                year = year,
                month = index + 1,
                day = day,
              );
              widget.onSelectedItemChanged(widget.selectedDate);
            },
          ),
          SizedBox(width: 10.w),
          buildPicker(
            items: years.map((y) => y.toString()).toList(),
            selectedIndex: years.indexOf(widget.selectedDate.year),
            onSelectedItemChanged: (index) {
              year = years[index];
              widget.selectedDate = DateTime(
                year = years[index],
                month = month,
                day = day,
              );
              widget.onSelectedItemChanged(widget.selectedDate);
            },
          ),
        ],
      ),
    );
  }

  Widget buildPicker({
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: selectedIndex,
          ),
          itemExtent: 70,
          diameterRatio: 1,
          onSelectedItemChanged: onSelectedItemChanged,
          magnification: 1,
          useMagnifier: true,
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: R.colors.primaryColor, width: 2),
                bottom: BorderSide(color: R.colors.primaryColor, width: 2),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          children:
              items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == selectedIndex;
                return Center(
                  child: Text(
                    item,
                    style: R.textStyles.font16M.copyWith(
                      color: isSelected ? R.colors.primaryColor : null,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
