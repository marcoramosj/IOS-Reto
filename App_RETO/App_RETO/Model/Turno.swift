//
//  Stats.swift
//  
//
//  Created by ediaz205  on 9/20/25.
//

import Foundation
import ColorSync
import SwiftUI

struct Turno: Identifiable {
    var id: Int
    var scheduledDate: Date
    var status: Bool
    var servicedDate: Date
    
    init(id: Int, scheduledDate: Date, status: Bool, servicedDate: Date) {
        self.id = id
        self.scheduledDate = scheduledDate
        self.status = status
        self.servicedDate = servicedDate
    }
}

