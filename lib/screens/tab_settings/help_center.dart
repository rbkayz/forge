import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ForgeAppBar(title: 'Help Center',),
      body: Column(
        children: const [

          //FAQs
          WidgetFAQs(),

          //Contact Us
          WidgetContactUs(),

          //Legal
          WidgetLegal(),

          //App Info
          WidgetAppInfo(),

        ],
      ),
    );
  }
}

///--------------------------------------------------------------
/// FAQs
///--------------------------------------------------------------

class WidgetFAQs extends StatelessWidget {
  const WidgetFAQs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.help_outline),
      title: const Text('FAQs'),
      onTap: () {
        }
    );
  }
}


///--------------------------------------------------------------
/// Contact Us
///--------------------------------------------------------------

class WidgetContactUs extends StatelessWidget {
  const WidgetContactUs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 30,
        leading: const Icon(Icons.support_outlined),
        title: const Text('Contact Us'),
        onTap: () {
        }
    );
  }
}

///--------------------------------------------------------------
/// Terms & Conditions
///--------------------------------------------------------------

class WidgetLegal extends StatelessWidget {
  const WidgetLegal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 30,
        leading: const Icon(Icons.policy_outlined),
        title: const Text('Terms and Privacy Policy'),
        onTap: () {
        }
    );
  }
}

///--------------------------------------------------------------
/// App Info
///--------------------------------------------------------------

class WidgetAppInfo extends StatelessWidget {
  const WidgetAppInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 30,
        leading: const Icon(Icons.info_outlined),
        title: const Text('App Info'),
        onTap: () {
        }
    );
  }
}