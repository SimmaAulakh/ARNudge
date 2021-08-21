//
//  AppDelegate.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import UserNotifications

import Firebase

import FirebaseMessaging

import IQKeyboardManagerSwift

import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
     let locationManager = CLLocationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    var sendNotification :Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("")
        
        GMSPlacesClient.provideAPIKey("")
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(
            UIApplication.backgroundFetchIntervalMinimum)
        
        IQKeyboardManager.shared.enable = true
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        // Use Firebase library to configure APIs
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        notificationCenter.requestAuthorization(options: options) {
            
            (didAllow, error) in
            
            if !didAllow {
                
                print("User has declined notifications")
                
            }
            
        }
        
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if self.locationManager != nil {
            
            self.locationManager.startMonitoringSignificantLocationChanges()
        }

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if self.locationManager != nil {
            
            self.locationManager.startMonitoringSignificantLocationChanges()
            
        }

    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // If you are receiving a notification message while your app is in the background,
        
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
            print("Message ID: \(messageID)")
            
        }
        
        HelpingClass.shared.delay(1.0) {
         
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification") , object: nil, userInfo: nil)
            
        }
        
        // Print full message.
        print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // If you are receiving a notification message while your app is in the background,
        
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
            print("Message ID: \(messageID)")
            
        }
        
        // Print full message.
        print(userInfo)
        
        HelpingClass.shared.delay(1.0) {
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification") , object: nil, userInfo: nil)
            
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Unable to register for remote notifications: \(error.localizedDescription)")
        
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        
         Messaging.messaging().apnsToken = deviceToken
        
    }
    
    // Support for background fetch
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        scheduleNotification(notificationType: "backgroundFetch")
        //1
//        if let tabBarController = window?.rootViewController as? UITabBarController,
//            let viewControllers = tabBarController.viewControllers {
//
//            //2
//            for viewController in viewControllers {
//                if let fetchViewController = viewController as? FetchViewController {
//                    //3
//                    fetchViewController.fetch {
//                        //4
//                        fetchViewController.updateUI()
//                        completionHandler(.newData)
//                    }
//                }
//            }
//        }
    }
    
    

    func scheduleNotification(location: CLLocation) {
        
        if let fcmToken = UserDefaults.standard.value(forKey: "fcmToken"){
            
            WebServices.shared.getPush(lat: location.coordinate.latitude, long: location.coordinate.longitude, token: fcmToken as! String) { (status, message, error) in
                
            print("")
                
                 self.sendNotification = true
                
        }
            
    }
//        let content = UNMutableNotificationContent() // Содержимое уведомления
//
//        content.title = notificationType
        
//        content.body = "Check location"
        
//        content.sound = UNNotificationSound.default
        
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        let identifier = "Local Notification"
        
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationCenter.add(request) { (error) in
        
//            if let error = error {
        
//                print("Error \(error.localizedDescription)")
        
//            }
        
//        }
        
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        scheduleNotification(notificationType: "Updated")
        
        print("lllllloooocccaaattttiiiioooonnnn= \(String(describing: locations.last))")
        
        if locations.last != nil {
            
            HelpingClass.shared.currentLocation = locations.last!
            
        }
        let currentLoca:[String:CLLocation] = ["location":locations.last!]
        
        HelpingClass.shared.getNearbyLocations(location: locations.last!) { (status, error) in
            
            switch status{
                
            case true:
                
                if  !self.sendNotification{
                    
                self.scheduleNotification(location: locations.last!)
                    
                }
                
            case false:
                
                break
                
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationUpdated"), object: nil, userInfo: currentLoca)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        
        print("new loc",newLocation!)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .authorizedWhenInUse, .authorizedAlways:
            
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.allowsBackgroundLocationUpdates = true
            
            locationManager.pausesLocationUpdatesAutomatically = false
            
        case .denied, .restricted: break
            
            // AR won't work
            
           // navigationController?.popViewController(animated: true)
            
        case .notDetermined:
            
            locationManager.requestAlwaysAuthorization()
            
        @unknown default:
            
            break
            
            //fatalError()
            
        }
        
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        
        return true
        
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
            print("Message ID: \(messageID)")
            
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
            print("Message ID: \(messageID)")
            
        }
        
        if let info = userInfo["my_key"]{
            
            let offerId = (info as! NSString)
            
            let locationsData = Mapper<NotificationBase>().map(JSONString: offerId as String)
            
            HelpingClass.shared.delay(1.0) {
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification") , object: nil, userInfo: ["offer_Id":locationsData?._id!])
                
            }
            
        }
        
        // Print full message.
        
      //  print(userInfo)
        
//        HelpingClass.shared.delay(1.0) {
        
//
        
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification") , object: nil, userInfo: nil)
//        }
        
        completionHandler()
        
    }
    
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        
        // TODO: If necessary send token to application server.
        
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
    }
    
    // [END refresh_token]
    
    // [START ios_10_data_message]
    
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        print("Received data message: \(remoteMessage.appData)")
        
    }
    
    // [END ios_10_data_message]
    
}
