import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Empty extends StatelessWidget {
  final String intlKey;
  Empty(this.intlKey);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/img/empty.svg',
            semanticsLabel: 'Empty',
            width: 300.0,
          ),
          Text(
            FlutterI18n.translate(context, intlKey),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
