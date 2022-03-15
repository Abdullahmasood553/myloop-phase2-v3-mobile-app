import 'package:flutter/material.dart';
import 'package:loop_hr/models/pay_slip.dart';
import 'package:loop_hr/utils/number_util.dart';
import 'package:loop_hr/utils/style.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';

class PaySlipDetailScreen extends StatelessWidget {
  final PaySlip slip;
  PaySlipDetailScreen({Key? key, required this.slip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        'Payslip Detail',
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: slip.lineItems.length,
          separatorBuilder: (context, index) => Divider(height: 16, thickness: .5),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return _buildPayslipListItem(slip.lineItems[index].elementName, slip.lineItems[index].value);
          },
        ),
      ),
    );
  }

  Widget _buildPayslipListItem(String key, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          textScaleFactor: 1.0,
          textAlign: TextAlign.left,
          style: Style.bodyText1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          NumberUtil.formatNumber(value),
          textScaleFactor: 1.0,
        ),
      ],
    );
  }
}
