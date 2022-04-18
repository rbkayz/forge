import 'package:flutter/material.dart';

import '../../utilities/constants.dart';

class ForgeSnackBar {
  showFloatingSnackBar(BuildContext context, Widget content) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1000),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.zero,
      backgroundColor: Constants.kWhiteColor,

      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: content,
      ),
      behavior: SnackBarBehavior.floating,
    )
    );
  }
}
