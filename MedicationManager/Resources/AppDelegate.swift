//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {authorized, error in
            if error != nil {
                print("The user did not allow notifications.")
                return
            }
            
            if authorized {
                
                UNUserNotificationCenter.current().delegate = self
                self.setNotificationCategories()
                
                print("✅ The user did authorize notifications.")
                
            } else {
                print("❌ The user has not authorized notifications")
            }
            
        }
        
        return true
    }

    
    private func setNotificationCategories() {
        
        let confirmAction = UNNotificationAction(identifier: Strings.confirmActionID, title: "✅ Taken")
        let laterAction = UNNotificationAction(identifier: Strings.laterActionID, title: "💤 Will take later")
        
        
        
        let category = UNNotificationCategory(identifier: Strings.medTakenNotificationCategoryID ,
                                              actions: [confirmAction, laterAction],
                                              intentIdentifiers: [],
                                              options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "MedicationManager")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == Strings.confirmActionID,  let id = response.notification.request.content.userInfo["medicationID"] as? String
        {
            MedicationController.shared.markMedicationTakenFromNotification(with: id)
            completionHandler()
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       
        NotificationCenter.default.post(name: Notification.Name(Strings.reminderNotificationReceivedName), object: nil)
        
        
        completionHandler([.sound, .banner])
    }
    
    
}
