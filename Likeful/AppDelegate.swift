//
//  AppDelegate.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/2/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Kingfisher
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     FirebaseApp.configure()
        let tabBar: UITabBarController = self.window?.rootViewController as! UITabBarController
        tabBar.selectedIndex = 0
         tabBar.tabBar.tintColor = .black
        
        ImageCache.default.maxMemoryCost = 60 *  1024 * 1024
        ImageCache.default.maxDiskCacheSize = 60 * 1024 * 1024
        
    
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "6c7f7279-c6b7-4bc9-87b8-8e08dbc148ea",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
            if Auth.auth().currentUser?.uid != nil {
      callNotifs()
        }
        // Override point for customization after application launch.
        return true
    }


    func callNotifs () {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("inChat").removeValue()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("inChat").removeValue()
            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
            let feed = ["lastLog" : timeNow]
            ref.child("users").child(uid).updateChildValues(feed)
            ref.child("users").child(uid).child("active").removeValue()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let uid = Auth.auth().currentUser?.uid {
            
           
            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
            let feed = ["lastLog" : timeNow]
            let ref = Database.database().reference()
            ref.child("users").child(uid).updateChildValues(feed)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("inChat").removeValue()
            let timeNow: Int = Int(NSDate().timeIntervalSince1970)
            let feed = ["lastLog" : timeNow]
            ref.child("users").child(uid).updateChildValues(feed)
        }
        self.saveContext()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        let userID = status.subscriptionStatus.userId
        
        let pushToken = status.subscriptionStatus.pushToken
      
        if pushToken != nil {
          
            if let playerID = userID {
               
                if let uid = Auth.auth().currentUser?.uid {
                    let ref = Database.database().reference()
                    ref.child("users").child(uid).child("userKey").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if snapshot.exists() {
                            if let toker = snapshot.value as? String {
                                if toker == playerID {
                                    print(toker)
                                } else {
                                    ref.child("users").child(uid).updateChildValues(["userKey" : playerID])
                                    //change token if different from current device
                                }
                            }
                          
                        } else {
                            ref.child("users").child(uid).updateChildValues(["userKey" : playerID])
                        }
                    })
                }
            }
        }
        
        OneSignal.sendTag("myType", value: "myBroadCast")
        
    }
    


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Likeful")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

