import 'package:flutter/material.dart';
import 'package:loop_hr/utils/style.dart';

class TextDialog extends StatefulWidget {
  TextDialog({Key? key}) : super(key: key);

  @override
  _TextDialogState createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? value;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reason for rejection'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autocorrect: false,
          autofocus: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field is required';
            }
            return null;
          },
          onSaved: (newValue) {
            value = newValue;
          },
          cursorColor: Style.primaryColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Style.primaryColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Style.primaryColor),
            ),
            labelText: '',
            contentPadding: EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
          ),
        ),
      ),
      /* Here add your custom widget  */
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: Text(
                    'Submit',
                    style: Style.bodyText2.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Style.primaryColor,
                    onPrimary: Style.primaryColor,
                    elevation: 0,
                  ),
                  onPressed: validate,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton(
                  child: Text(
                    'Cancel',
                    style: Style.bodyText2.copyWith(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context, null),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  void validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, value);
    } else {
      print("Not Validated");
    }
  }
}
