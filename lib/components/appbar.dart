import 'package:flutter/material.dart';
import 'package:forge/utilities/constants.dart';

class ForgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForgeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'forge',
        style: TextStyle(
            fontSize: 24,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.2,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, Constants.signInNavigate, (route) => false);
            },
            child: const Icon(
              Icons.search,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
            },
            child: const Icon(
              Icons.more_vert,
            ),
          ),
        ),
      ],
    );
  }
}

