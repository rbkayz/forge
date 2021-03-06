import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher_string.dart';

import '../../services/notifications_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
      ),
    );
  }

  @override
  void dispose() {

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

          Hive.box(FirebaseAuthService.getLinksBox(context)).close();
          Hive.box(FirebaseAuthService.getPrefsBox(context)).close();
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

class WidgetEditTags extends StatefulWidget {
  const WidgetEditTags({
    Key? key,
  }) : super(key: key);

  @override
  State<WidgetEditTags> createState() => _WidgetEditTagsState();
}

class _WidgetEditTagsState extends State<WidgetEditTags> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.tag),
      title: const Text('Tags'),
      onTap: () {
        Navigator.pushNamed(context, Constants.editTagsNavigate).then((value) => setState(() {}));
      },
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
        StoreRedirect.redirect(androidAppId: 'net.forgeapp');
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
      onTap: () async {

        String url = 'mailto:admin@forgeapp.net?subject=Feature%20Request';
        if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
        } else {
        throw 'Could not launch $url';
        }


      },
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
      onTap: () async {

        final prefsBox = Hive.box(FirebaseAuthService.getPrefsBox(context));
        final now = DateTime.now();
        DateTime? initialDateTime = await prefsBox.get(Constants.notificationTime);
        TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDateTime ?? DateTime(now.year, now.month, now.day,9, 0));

        TimeOfDay? pickedSchedule = await pickSchedule(context, initialTime);

        if (pickedSchedule != null) {

          await cancelScheduledNotifications();
          await prefsBox.put(Constants.notificationTime, DateTime(now.year, now.month, now.day, pickedSchedule.hour, pickedSchedule.minute));
          await createScheduledNotification(pickedSchedule);
        }

      },
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

    String sharetext = 'Hey there! forge has been helping me keep in touch with friends better. Check it out at forgeapp.net';


    return ListTile(
      minLeadingWidth: 30,
      leading: const Icon(Icons.share),
      title: const Text('Invite a friend'),
      onTap: () async {
        final box = context.findRenderObject() as RenderBox?;


        //TODO change the forge image

        ByteData imagebyte = await rootBundle.load(Constants.shareImage);
        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/forge.jpg';
        File(path).writeAsBytesSync(imagebyte.buffer.asUint8List());
        await Share.shareFiles([path], text: sharetext, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

      },
    );
  }
}
