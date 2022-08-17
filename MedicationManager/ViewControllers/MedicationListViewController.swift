//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//

import UIKit

class MedicationListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moodSurveyButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MedicationController.shared.fetchAllMedications()
        MoodSurveyController.shared.fetchTodaysMoodSurvey()
        
        moodSurveyButton.setTitle(MoodSurveyController.shared.todaysMoodSurvey?.mentalState ?? "❓" , for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name(Strings.reminderNotificationReceivedName), object: nil)
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Action
    
    @IBAction func moodSurveyButtonTapped(_ sender: Any) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "moodSurveyViewController") as? MoodSurveyViewController else { return }
        moodSurveyViewController.modalPresentationStyle = .fullScreen
        
        // set delegate to self
        moodSurveyViewController.delegate = self
        
        navigationController?.present(moodSurveyViewController, animated: true, completion: nil)
    
    }
    
    @objc func didReceiveNotification() {
        view.backgroundColor = .systemTeal
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
        self.view.backgroundColor = .systemGray4
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMedicationDetails",
           let indexPath = tableView.indexPathForSelectedRow,
           let destination = segue.destination as? MedicationDetailViewController {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            destination.medication = medication
        }
    }
    
}

extension MedicationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MedicationController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MedicationController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell
        else { return UITableViewCell() }
        
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        cell.medication = medication
        cell.wasTakenToday = medication.wasTakenToday()
        
        let image = cell.wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        cell.wasTakenButton.setImage(image, for: .normal)
        cell.wasTakenButton.tintColor = .black
        
        cell.nameLabel.text = medication.name
        cell.timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
        
        
        cell.delegate = self
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Not Taken"
        }else if section == 1 {
            return "Taken"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            MedicationController.shared.deleteMedication(medication)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}



extension MedicationListViewController: MedicationCellDelegate {
    func medicationWasTakenTapped(wasTaken: Bool, medication: Medication, cell: MedicationTableViewCell) {
        MedicationController.shared.updateMedicationStatus(wasTaken, medication: medication)
        tableView.reloadData()
    }
}

extension MedicationListViewController: MoodSurveyViewControllerDelegate {
    func moodButtonTapped(with emoji: String) {
        moodSurveyButton.setTitle(emoji, for: .normal)
        MoodSurveyController.shared.didTapMoodEmoji(emoji)
    }
}
