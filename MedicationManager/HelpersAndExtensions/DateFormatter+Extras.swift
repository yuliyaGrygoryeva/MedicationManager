//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Yuliya  on 6/21/22.
//

import Foundation

extension DateFormatter {
    
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
}
