import Flutter
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    
    FlutterLocalNotifications Plugin.setPlugin RegistrantCallback { (registry) in
    GeneratedPlugin Registrant.register(with: registry)}


    GeneratedPluginRegistrant.register(with: self)

    if #available (iOS 10.0, *) {
      UNUserNotification Center.current().delegate = self as? UNUserNotification CenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
