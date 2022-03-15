import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AdaptiveDateTimeField extends StatefulWidget {
  final ValueChanged<DateTime?>? onSaved;
  final ValueChanged<DateTime?>? onChanged;
  final String? Function(DateTime?)? validator;
  final String title;
  const AdaptiveDateTimeField({Key? key, this.onSaved, this.onChanged, this.validator, required this.title}) : super(key: key);

  @override
  _AdaptiveDateTimeFieldState createState() => _AdaptiveDateTimeFieldState();
}

class _AdaptiveDateTimeFieldState extends State<AdaptiveDateTimeField> {
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      decoration: InputDecoration(
        labelText: widget.title,
      ),
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      validator: widget.validator,
      format: DateUtil.defaultDateTimeFormat,
      onShowPicker: (context, currentValue) async {
        DateTime? date;
        if (Platform.isAndroid) {
          date = await showDatePicker(
            context: context,
            firstDate: DateTime(2021),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                currentValue ?? DateTime.now(),
              ),
            );
            date = DateTimeField.combine(date, time);
          }
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
                        mode: CupertinoDatePickerMode.dateAndTime,
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
