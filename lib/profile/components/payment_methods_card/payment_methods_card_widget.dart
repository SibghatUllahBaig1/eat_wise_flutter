import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'payment_methods_card_model.dart';
export 'payment_methods_card_model.dart';

class PaymentMethodsCardWidget extends StatefulWidget {
  const PaymentMethodsCardWidget({
    super.key,
    required this.paymentData,
    required this.index,
  });

  final PaymentMethodStruct? paymentData;
  final int? index;

  @override
  State<PaymentMethodsCardWidget> createState() =>
      _PaymentMethodsCardWidgetState();
}

class _PaymentMethodsCardWidgetState extends State<PaymentMethodsCardWidget> {
  late PaymentMethodsCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentMethodsCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            CreditCardPageWidget.routeName,
            queryParameters: {
              'paymentData': serializeParam(
                widget!.paymentData,
                ParamType.DataStruct,
              ),
              'index': serializeParam(
                0,
                ParamType.int,
              ),
            }.withoutNulls,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (widget!.paymentData?.type == 'Visa') {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0x272081E2),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/visa.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget!.paymentData?.type == 'Mastercard') {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFFDEACE),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/mastercard.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget!.paymentData?.type == 'PayPal') {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFD8DDF3),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/paypal.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget!.paymentData?.type == 'Google Pay') {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFE4E5E7),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/google_pay.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget!.paymentData?.type == 'Apple Pay') {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/apple_pay.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget!.paymentData?.type == 'Discover') {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFECDF),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: Image.asset(
                            'assets/images/discover.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFD3DEF7),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/american_express.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.paymentData?.cardNickname != null &&
                                    widget!.paymentData?.cardNickname != ''
                                ? widget!.paymentData?.cardNickname
                                : widget!.paymentData?.type,
                            'null',
                          ),
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                        if ((widget!.paymentData?.type != 'PayPal') ||
                            (widget!.paymentData?.type != 'Google Pay') ||
                            (widget!.paymentData?.type != 'Apple Pay'))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              valueOrDefault<String>(
                                functions.hiddenText(
                                    widget!.paymentData?.cardNumber, 2, 2),
                                'null',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Connected',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
