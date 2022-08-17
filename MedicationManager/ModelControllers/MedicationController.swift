//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//

import CoreData

class MedicationController {
    
    // Singleton
    static let shared = MedicationController()
    
    let scheduler = NotificationScheduler()
    
    private init() {}
    
    var medications: [Medication] = []
    
    var sections: [[Medication]] { [notTakenMeds, takenMeds]}
    var notTakenMeds: [Medication] = []
    var takenMeds: [Medication] = []
    var moodSurvey: MoodSurvey?
    
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // CRUD
    
    func createMedication(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
        
        scheduler.scheduleNotification(for: medication)
    
    }
    
    func fetchAllMedications() {
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
       
        takenMeds = medications.filter { $0.wasTakenToday() }
        notTakenMeds = medications.filter { !$0.wasTakenToday() }
        
    }
    
    func updateMedication(medication: Medication, name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
        
        scheduler.clearNotifications(for: medication)
        scheduler.scheduleNotification(for: medication)
    }
    
    func updateMedicationStatus(_ wasTaken: Bool, medication: Medication) {
        
        // if was taken, remove from one array and add to the other
        if wasTaken {
            scheduler.clearNotifications(for: medication)
             TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else { // if taken ws false, opposite of above
            // allowing ourselves to rewirte to a set. Sets once created cant be changed, but we are creating mutable version of the set
            let mutableTakenDates = medication.mutableSetValue(forKeyPath: "takenDates")
            
            //create takenDate as a set of TakenDate, give me first one
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: {takenDate in guard let date = takenDate.date else { return false}
                // check and return if the date is the same as today
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                // if above if let true then remove the takenDate
                mutableTakenDates.remove(takenDate)
                
                // then remove from taken and append to notTakenMeds
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
                
            }
            
            
            
        }
        CoreDataStack.saveContext()
       
    }
    
    
    func markMedicationTakenFromNotification(with id: String) {
        guard let medication = notTakenMeds.first(where: { $0.id == id }) else { return }
        
        updateMedicationStatus(true, medication: medication)
    
        // ABC
                
        // MEDICATION  -- id: ABZ
        // MEDICATION  -- id: XYZ
        // MEDICATION  -- id: ABC
    }
    
    func deleteMedication(_ medication: Medication) {
        if let index = notTakenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
            
        } else if let index = takenMeds.firstIndex(of: medication) {
        takenMeds.remove(at: index)
    }
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
    
        scheduler.clearNotifications(for: medication)
    }
}

