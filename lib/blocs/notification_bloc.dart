import 'package:onesignal/onesignal.dart';

class NotificationBloc {
    void initOneSignal() {
      OneSignal.shared.init("b3d92f8d-1c42-42a7-aeb6-d96f4f3c5a19");
      OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    }
}
