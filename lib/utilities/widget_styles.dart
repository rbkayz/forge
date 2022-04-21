import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'constants.dart';

NeumorphicStyle forgeNeumorphicStyle() {
  return NeumorphicStyle(
    shape: NeumorphicShape.concave,
    lightSource: LightSource.topLeft,
    depth: 0.5,
    intensity: 1,
    surfaceIntensity: 0.05,
    color: Constants.kWhiteColor,
    boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.all(const Radius.circular(10))),
  );
}

BoxDecoration forgeBoxDecoration() {
  return BoxDecoration(
    color: Constants.kWhiteColor,
    boxShadow: const [
      BoxShadow(
          blurRadius: 0.5,
          color: Constants.kSecondaryColor,
          offset: Offset(0, 0.5))
    ],
  );
}
