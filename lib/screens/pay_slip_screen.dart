import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/payslip-bloc/payslip.dart';
import 'package:loop_hr/models/pay_slip.dart';
import 'package:loop_hr/utils/number_util.dart';
import 'package:loop_hr/utils/routes.dart';
import 'package:loop_hr/utils/style.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/error_widget.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({Key? key, slips}) : super(key: key);

  @override
  _PayslipScreenState createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PayslipBloc>(context).add(FetchPayslip());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        'Payslip',
      ),
      body: BlocBuilder<PayslipBloc, PayslipState>(
        builder: (context, state) {
          if (state is PaySlipLoaded) {
            if (state.slips.isEmpty) {
              return Center(
                child: Text(
                  'Payslip not found.',
                  textScaleFactor: 1.0,
                ),
              );
            }
            return BuildPayslipList(slips: state.slips);
          }
          if (state is PaySlipError) {
            return Center(
              child: MLErrorWidget(
                title: state.message,
                onPress: () => BlocProvider.of<PayslipBloc>(context).add(FetchPayslip()),
              ),
            );
          }
          return Center(child: ActivityIndicator());
        },
      ),
    );
  }
}

class BuildPayslipList extends StatelessWidget {
  final List<PaySlip> slips;

  const BuildPayslipList({Key? key, required this.slips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => Divider(
        thickness: .5,
        height: 1,
      ),
      itemCount: slips.length,
      itemBuilder: (BuildContext context, index) {
        PaySlip _payslip = slips[index];
        return ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              paySlipScreenDetailRoute,
              arguments: _payslip,
            );
          },
          leading: Text(
            _payslip.formattedMonth(),
            textScaleFactor: 1.0,
            style: Style.bodyText1.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          title: Text(
            "Rs. " + NumberUtil.formatNumber(_payslip.payable),
            textScaleFactor: 1.0,
            style: Style.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Container(
            child: Text(
              "Processing Date: " + _payslip.formattedPayDate(),
              textScaleFactor: 1.0,
            ),
          ),
        );
      },
    );
  }
}
