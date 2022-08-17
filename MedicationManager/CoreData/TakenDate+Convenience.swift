//
//  TakenDate+Convenience.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/22/22.
//

import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
