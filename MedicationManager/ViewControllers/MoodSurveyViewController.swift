//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/22/22.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: AnyObject {
    func moodButtonTapped(with emoji: String)
}

class MoodSurveyViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name(Strings.reminderNotificationReceivedName), object: nil)
      
    }
    
    // MARK: - Properties
    weak var delegate: MoodSurveyViewControllerDelegate?
    
    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func moodButtonTapped(_ sender: UIButton) {
        guard let moodEmoji = sender.titleLabel?.text else { return }
        delegate?.moodButtonTapped(with: moodEmoji)
        dismiss(animated: true)
    }
    
    
    // MARK: - Functions
    @objc func didReceiveNotification() {
        view.backgroundColor = .systemTeal
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
        self.view.backgroundColor = .systemGray4
        }
    }
}
