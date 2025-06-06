import 'package:afghan_cosmos/theme/colors.dart';
import 'package:afghan_cosmos/theme/sizes.dart';
import 'package:flutter/material.dart';


class TAppBarTheme{
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: TColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    actionsIconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: TColors.white),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
     backgroundColor: TColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.grey, size: TSizes.iconMd),
    actionsIconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: TColors.white),
  );
}