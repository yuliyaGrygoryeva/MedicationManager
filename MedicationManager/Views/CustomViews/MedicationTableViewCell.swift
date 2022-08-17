//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//

import UIKit

protocol MedicationCellDelegate: AnyObject {
    func medicationWasTakenTapped(wasTaken: Bool, medication: Medication, cell: MedicationTableViewCell)
    
}


class MedicationTableViewCell: UITableViewCell {
// MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: MedicationCellDelegate?
    var medication: Medication?
    var wasTakenToday: Bool = false
    
    // MARK: - Action
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        
        guard let medication = medication else {
            return
        }

        wasTakenToday.toggle()
        delegate?.medicationWasTakenTapped(wasTaken: wasTakenToday, medication: medication, cell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        medication = nil
        wasTakenToday = false
    }

}
