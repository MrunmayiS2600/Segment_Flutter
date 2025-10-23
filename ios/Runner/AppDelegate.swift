import UIKit
import Flutter
import Segment
import Segment_CleverTap
import CleverTapSDK
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let segmentChannel = FlutterMethodChannel(name: "segment_clevertap", binaryMessenger: controller.binaryMessenger)

        segmentChannel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "init":
                if let args = call.arguments as? [String: Any],
                   let writeKey = args["writeKey"] as? String {
                    self?.initSegment(writeKey: writeKey)
                    result(nil)
                }
            case "identify":
                if let args = call.arguments as? [String: Any],
                   let userId = args["userId"] as? String,
                   let traits = args["traits"] as? [String: Any] {
                    Analytics.shared().identify(userId, traits: traits)
                    result(nil)
                }
            case "track":
                if let args = call.arguments as? [String: Any],
                   let eventName = args["eventName"] as? String,
                   let properties = args["properties"] as? [String: Any] {
                    Analytics.shared().track(eventName, properties: properties)
                    result(nil)
                }
            case "screen":
                if let args = call.arguments as? [String: Any],
                   let screenName = args["screenName"] as? String,
                   let properties = args["properties"] as? [String: Any] {
                    Analytics.shared().screen(screenName, properties: properties)
                    result(nil)
                }
            case "reset":
                Analytics.shared().reset()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func initSegment(writeKey: String) {
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)

        let configuration = AnalyticsConfiguration(writeKey: writeKey)
        configuration.use(SEGCleverTapIntegrationFactory.instance())
        configuration.trackApplicationLifecycleEvents = true
        configuration.recordScreenViews = true
        Analytics.setup(with: configuration)
    }

    // Push Notifications
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Analytics.shared().registeredForRemoteNotifications(withDeviceToken: deviceToken)
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                              fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Analytics.shared().receivedRemoteNotification(userInfo)
        completionHandler(.noData)
    }

    // UNUserNotificationCenterDelegate
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .badge, .banner])
        } else {
            completionHandler([.sound, .badge])
        }
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        Analytics.shared().receivedRemoteNotification(response.notification.request.content.userInfo)
        completionHandler()
    }
}



