import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    _instance ??= await Mixpanel.init("c5e1335ca73861f4a93985fc7d2cf5d4",
          optOutTrackingDefault: false);
    return _instance!;
  }
}