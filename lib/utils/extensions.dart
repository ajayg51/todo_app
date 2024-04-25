import 'package:flutter/material.dart';

extension NumExt on num {
  Widget get horizontalSpace => SizedBox(width: toDouble());

  Widget get verticalSpace => SizedBox(height: toDouble());
}

extension WidgetExt on Widget {
  Widget get toSliverBox => SliverToBoxAdapter(child: this);

  Widget padAll({required double value}) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget padSymmetric({double? horizontal, double? vertical}) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: this,
      );
}
