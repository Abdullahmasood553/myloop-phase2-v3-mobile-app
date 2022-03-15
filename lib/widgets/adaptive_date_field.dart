import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop_hr/utils/date_util.dart';

class AdaptiveDateField extends StatefulWidget {
  final ValueChanged<DateTime?>? onSaved;
  final ValueChanged<DateTime?>? onChanged;
  final String? Function(DateTime?)? validator;
  final String title;
  final bool showPrefix;
  AdaptiveDateField({Key? key, required this.title, this.onSaved, this.validator, this.onChanged, this.showPrefix = false}) : super(key: key);

  @override
  State<AdaptiveDateField> createState() => _AdaptiveDateFieldState();
}

class _AdaptiveDateFieldState extends State<AdaptiveDateField> {
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      decoration: InputDecoration(
        labelText: widget.title,
        floatingLabelBehavior: widget.showPrefix ? FloatingLabelBehavior.never : null,
        contentPadding: widget.showPrefix ? EdgeInsets.zero : null,
        prefixIcon: widget.showPrefix ? Icon(Icons.calendar_today_outlined) : null,
      ),
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      validator: widget.validator,
      format: DateUtil.defaultDateFormat,
      onShowPicker: (context, currentValue) async {
        DateTime? date;
        if (Platform.isAndroid) {
          date = await showDatePicker(
            context: context,
            firstDate: DateTime(2021),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        } else {
          date = await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              DateTime? _date = DateTime.now();
              return BottomSheet(
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, null),
                          child: Text(
                            'Cancel',
                            textScaleFactor: 1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, _date);
                          },
                          child: Text(
                            'Done',
                            textScaleFactor: 1,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: currentValue,
                        maximumDate: DateTime(2100),
                        minimumDate: DateTime(2021),
                        onDateTimeChanged: (DateTime value) {
                          _date = value;
                        },
                      ),
                    ),
                  ],
                ),
                onClosing: () {},
              );
            },
          );
        }
        if (date != null) {
          return date;
        } else {
          return currentValue;
        }
      },
    );
  }
}
