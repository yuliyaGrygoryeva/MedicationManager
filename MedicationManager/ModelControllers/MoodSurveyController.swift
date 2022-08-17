//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/24/22.
//

import CoreData

class MoodSurveyController {
    
    static let shared = MoodSurveyController()
    var todaysMoodSurvey: MoodSurvey?
    
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        
        let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) ?? Date()
        
        let afterPredicate = NSPredicate(format: "date > %@", startOfToday as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", endOfToday as NSDate)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
        return request
    }()
    
    
    // CRUD
    
    func didTapMoodEmoji(_ emoji: String) {
        // if let currentMood = todaysMoodSurvey {
        if let _ = todaysMoodSurvey {
            update(moodEmoji: emoji)
        } else {
            create(moodEmoji: emoji)
        }
    }
    
    private func create(moodEmoji: String) {
        let moodSurvey = MoodSurvey(mentalState: moodEmoji, date: Date())
        todaysMoodSurvey = moodSurvey
        CoreDataStack.saveContext()
    }
    
    //read
    func fetchTodaysMoodSurvey() {
        let todaysMoodSurvey =  ((try? CoreDataStack.context.fetch(fetchRequest)) ?? []).first
        self.todaysMoodSurvey = todaysMoodSurvey
    }
    
    private func update(moodEmoji: String) {
        todaysMoodSurvey?.mentalState = moodEmoji
        CoreDataStack.saveContext()
    }
}
