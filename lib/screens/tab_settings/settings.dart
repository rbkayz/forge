import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
//import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        //Edit notifications
        WidgetNotifications(),

        //Edit tags
        WidgetEditTags(),

        //Feature Request
        WidgetFeatureRequest(),

        //Review Us
        WidgetReviewUs(),

        //Share with a friend
        WidgetShare(),

        //Help Center
        WidgetHelpCenter(),

        //Logout
        WidgetLogout(),

        // Center(
        //   child: Image.asset(Constants.forgeHeaderLogo,width: 50,)
        // ),

      ],
    );
  }

  @override
  void dispose() {
    Hive.box(Constants.linksBox).close();
    super.dispose();
  }
}

///--------------------------------------------------------------
/// Logout
///--------------------------------------------------------------

class WidgetLogout extends StatelessWidget {
  const WidgetLogout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () async {
        FirebaseAuthService auth = FirebaseAuthService();
        try {
          await auth.signOutFromGoogle();
        } catch (e) {
          if (e is FirebaseAuthException) {
            Navigator.pushReplacementNamed(context, Constants.errorNavigate);
          }
        }
      },
    );
  }
}

///--------------------------------------------------------------
/// Edit Tags
///--------------------------------------------------------------

class WidgetEditTags extends StatelessWidget {
  const WidgetEditTags({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.tag),
      title: const Text('Tags'),
      onTap: () {},
    );
  }
}

///--------------------------------------------------------------
/// Review us
///--------------------------------------------------------------

class WidgetReviewUs extends StatelessWidget {
  const WidgetReviewUs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.star),
      title: const Text('Review us'),
      onTap: () {
        //https://pub.dev/packages/in_app_review
      },
    );
  }
}

///--------------------------------------------------------------
/// Help Center
///--------------------------------------------------------------

class WidgetHelpCenter extends StatelessWidget {
  const WidgetHelpCenter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.help),
      title: const Text('Help Center'),
      onTap: () {
        Navigator.pushNamed(context, Constants.helpCenterNavigate);
      },
    );
  }
}

///--------------------------------------------------------------
/// Feature request
///--------------------------------------------------------------

class WidgetFeatureRequest extends StatelessWidget {
  const WidgetFeatureRequest({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.code),
      title: const Text('Request a feature'),
      onTap: () {},
    );
  }
}

///--------------------------------------------------------------
/// Notification Settings
///--------------------------------------------------------------

class WidgetNotifications extends StatelessWidget {
  const WidgetNotifications({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      onTap: () {},
    );
  }
}

///--------------------------------------------------------------
/// Share with a friend
///--------------------------------------------------------------

class WidgetShare extends StatelessWidget {
  const WidgetShare({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.share),
      title: const Text('Invite a friend'),
      onTap: () async {
        // final box = context.findRenderObject() as RenderBox?;
        //
        // await Share.share('Invite a friend to forge',
        //     subject: 'Invite',
        //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      },
    );
  }
}
