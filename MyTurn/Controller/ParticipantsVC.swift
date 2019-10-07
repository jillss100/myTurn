//
//  ParticipantsVC.swift
//  MyTurn
//
//  Created by Jill Uhl on 2/22/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class ParticipantsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var saveButton: RoundedCorners!
    
    var activityEdit: Activity?
    var controller: NSFetchedResultsController<User>!
    
    var participantsSelected: [NSObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchUsers()
        
        activityLabel.text = activityEdit?.name
    }
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindToActivities", sender: nil)
    }

    @IBAction func saveParticipantsBtn(_ sender: Any) {
        
        if (activityEdit?.users!.count)! > 0 {
            adCoreData.saveContext()
            performSegue(withIdentifier: "unwindToActivities", sender: nil)
        } else {
        let dialogMessage = UIAlertController(title: "No Selection", message: "Please select Turn Takers for this activity.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    
    //TableView setup
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = participantTableView.dequeueReusableCell(withIdentifier: "ParticipantsCell", for: indexPath) as! ParticipantsCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        cell.selectionStyle = .none
        
        let user = controller.object(at: indexPath as IndexPath)
        
        //loads checkmarks on participants
        if (activityEdit?.users?.contains(user))! {
            cell.participantButton.isSelected = true
            } else {
            cell.participantButton.isSelected = false
        }
        
        //save participants with checkmark
        cell.buttonAction = { sender in
            if cell.participantButton.isSelected {
                self.activityEdit?.addToUsers(user)
            } else {
                if self.activityEdit?.users?.contains(user) == true {
                    self.activityEdit?.removeFromUsers(user)
                }
            }
        }
        
        return cell
    }
    
    func configureCell(cell: ParticipantsCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureParticipantCell(item: item)
    }
    
    
    //fetch
    func fetchUsers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    //Controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        participantTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        participantTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                participantTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                participantTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = participantTableView.cellForRow(at: indexPath) as! ParticipantsCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                participantTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                participantTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func batchDelete() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDelete)
        } catch {
            print("Error")
        }
    }
}
