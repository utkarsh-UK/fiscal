import 'package:fiscal/core/core.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;

  const PrimaryButton({
    Key? key,
    required this.btnText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(FiscalTheme.SECONDARY_COLOR),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10.0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
        elevation: MaterialStateProperty.all(4.0),
      ),
      child: Text(
        btnText,
        style: FiscalTheme.bodyWhiteText.copyWith(color: Color(0xFFFFFFFF)),
      ),
    );
  }
}
