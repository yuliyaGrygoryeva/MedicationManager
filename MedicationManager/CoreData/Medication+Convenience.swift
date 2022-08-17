//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//


import CoreData

extension Medication {
    
    // discardableResult - we dont care if the result of this is unused
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
        self.id = UUID().uuidString
        
    }
    // checking to see if a medication was taken TODAY
    func wasTakenToday() -> Bool {
        guard let _ = (takenDates as? Set<TakenDate>)?.first(where: { takenDate in
            guard let day = takenDate.date else { return false }
            return Calendar.current.isDate(day, inSameDayAs: Date())
        
        })
        else { return false }
        return true
    }
    
    
    
    
}
