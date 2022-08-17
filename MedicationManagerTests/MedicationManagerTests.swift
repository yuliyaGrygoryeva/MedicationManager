//
//  MedicationManagerTests.swift
//  MedicationManagerTests
//
//  Created by Yuliya  on 6/24/22.
//

import XCTest
@testable import MedicationManager

class MedicationManagerTests: XCTestCase {


    override func tearDownWithError() throws {
        for medSection in MedicationController.shared.sections {
            for medication in medSection {
                MedicationController.shared.deleteMedication(medication)
            }
        }
    
    }

    func testCreateMedication() {
        MedicationController.shared.createMedication(name: "Med1", timeOfDay: Date())
        MedicationController.shared.createMedication(name: "Med2", timeOfDay: Date())
        
        XCTAssertTrue(MedicationController.shared.notTakenMeds.count == 2)
        
    }
    
    func testUpdateMedicationDetails() {
       
        // create mock data
        MedicationController.shared.createMedication(name: "Med1", timeOfDay: Date())
        
        // call the function
        if let medtoUpdate = MedicationController.shared.notTakenMeds.first { medication in
            medication.name == "Med1"
            
        } {
            MedicationController.shared.updateMedication(medication: medtoUpdate, name: "MedUpdated", timeOfDay: Date())
            // verify output
            XCTAssertTrue(medtoUpdate.name == "MedUpdated")
        }
    }
    
    func testUpdateMedicationTakenStatus()  throws {
        // create mock data
        
        ["testMed1", "testMed2", "testMed3", "testMed4", "testMed5"].forEach { name in MedicationController.shared.createMedication(name: name, timeOfDay: Date())
        }
        
        // call the function
        let firstMedToUpdate = try XCTUnwrap(MedicationController.shared.notTakenMeds.first)
        let secondMedToUpdate =  try XCTUnwrap(MedicationController.shared.notTakenMeds.last)
        MedicationController.shared.updateMedicationStatus(true, medication: firstMedToUpdate)
        MedicationController.shared.updateMedicationStatus(true, medication: secondMedToUpdate)
        
        XCTAssertTrue(MedicationController.shared.notTakenMeds.count == 3)
        XCTAssertTrue(MedicationController.shared.takenMeds.count == 2)
        }


    func testDeleteMedication() throws {
        // create mock data
        
        ["testMed1", "testMed2", "testMed3", "testMed4", "testMed5"].forEach { name in MedicationController.shared.createMedication(name: name, timeOfDay: Date())
        }
        
       
        let firstMedToDelete = try XCTUnwrap(MedicationController.shared.notTakenMeds.first)
        let secondMedToDelete =  try XCTUnwrap(MedicationController.shared.notTakenMeds.last)
        
        //call delete function
        MedicationController.shared.deleteMedication(firstMedToDelete)
        MedicationController.shared.deleteMedication(secondMedToDelete)
        
        //Verify expected functionality
        XCTAssertTrue(MedicationController.shared.notTakenMeds.count == 3)
        
        let containsDeletedMeds = MedicationController.shared.notTakenMeds.contains{
            medication in medication.name == "testMed1" || medication.name == "testMed5"
        }
        XCTAssertFalse(containsDeletedMeds)
    }
    
}
    
    

