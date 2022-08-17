//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/23/22.
//

import UserNotifications

class NotificationScheduler {
    
    func scheduleNotification(for medication: Medication) {
        
        guard let timeOfDay = medication.timeOfDay,
        let identifier = medication.id else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "It's time to take your meds!"
        content.body = "It's time to take your \(medication.name ?? "medication")"
        content.sound = .default
        content.categoryIdentifier = Strings.medTakenNotificationCategoryID
        content.userInfo = ["medicationID": identifier]
        
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: timeOfDay)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "takeMedNotificationID", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("There was a problem scheduling  this notification.")
                print(error?.localizedDescription)
        }
    }
    }
    
    func clearNotifications(for medication: Medication) {
        guard let identifier = medication.id else { return }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
