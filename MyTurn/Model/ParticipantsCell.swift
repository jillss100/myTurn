//
//  ParticipantsCell.swift
//  MyTurn
//
//  Created by Jill Uhl on 2/22/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class ParticipantsCell: UITableViewCell, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var participantButton: UIButton!
    
    var buttonAction: ((Any) -> Void)?
    
    func configureParticipantCell(item: User) {
        participantLabel.text = item.name
    }

    @IBAction func participantBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        self.buttonAction?(sender)
    }
}
