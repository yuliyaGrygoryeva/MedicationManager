//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var medication: Medication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name(Strings.reminderNotificationReceivedName), object: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let name = nameTextField.text,
              !name.isEmpty
        else { return }
        
        let timeOfDay = datePicker.date
        
        if let medication = medication {
            //update
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: timeOfDay)
        } else {
            MedicationController.shared.createMedication(name: name, timeOfDay: timeOfDay)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateView() {
        if let medication = medication,
           let timeOfDay = medication.timeOfDay {
            nameTextField.text = medication.name
            datePicker.date = timeOfDay
            title = "Medication Details"
        } else {
            title = "Add Medication"
        }
    }
    @objc func didReceiveNotification() {
        view.backgroundColor = .systemTeal
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
        self.view.backgroundColor = .systemGray4
        }
    }

}
