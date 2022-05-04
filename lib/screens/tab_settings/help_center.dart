import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utilities/constants.dart';

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
      onTap: () async {

        String url = 'https://forgeapp.net';
        if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
        } else {
        throw 'Could not launch $url';
        }

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
        onTap: () async {

          String url = 'mailto:admin@forgeapp.net?subject=Support%20Request';
          if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
          } else {
          throw 'Could not launch $url';
          }


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
        onTap: () async {

          String url = 'https://forgeapp.notion.site/Terms-and-Privacy-Policy-fcc30e94e14b4a9cb897ecd76d61a818';
          if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
          } else {
          throw 'Could not launch $url';
          }


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

          Navigator.pushNamed(context, Constants.appInfoNavigate);

        }
    );
  }
}