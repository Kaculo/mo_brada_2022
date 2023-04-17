import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


    // TODO: Add your Google Maps API key
        GMSServices.provideAPIKey("AIzaSyDcVep2HYdKtEc9U6S6lM3XiMeBcUJpc1Y")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
