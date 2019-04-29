//
//  EditActivityVC.swift
//  MyTurn
//
//  Created by Jill Uhl on 1/16/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class EditActivityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var activityName: UITextField!
    
    @IBOutlet weak var selectActivityTableView: UITableView!
    
    var activityEdit: Activity?
    
    var controller: NSFetchedResultsController<Activity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attemptFetch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
//    @IBAction func cancel(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectActivityTableView.dequeueReusableCell(withIdentifier: "EditActivityCell", for: indexPath) as! EditActivityCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)

        return cell
    }
    
    func configureCell(cell: EditActivityCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.activityName.text = item.name
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let removedActivity = controller.object(at: indexPath)
            
            let dialogMessage = UIAlertController(title: "Delete Activity", message: "Are you sure?", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (ACTION) -> Void in
                context.delete(removedActivity)
                adCoreData.saveContext()
                self.selectActivityTableView.reloadData()
            })
            
            let no = UIAlertAction(title: "No", style: .default, handler: { (ACTION) -> Void in
                dialogMessage.dismiss(animated: true, completion: nil)
            })
            
            dialogMessage.addAction(yes)
            dialogMessage.addAction(no)
            present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    //send activity to next view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = controller.fetchedObjects , object.count > 0 {
            activityEdit = object[indexPath.row]
            performSegue(withIdentifier: "EditActivityTwo", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditActivityTwo" {
            let destVC: EditActivityTwoVC = segue.destination as! EditActivityTwoVC
            destVC.activityEditTwo = activityEdit
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
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
}

