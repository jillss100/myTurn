//
//  ActivitiesVC.swift
//  MyTurn
//
//  Created by Jill Uhl on 1/15/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class ActivitiesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    var controller: NSFetchedResultsController<Activity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        attemptFetch()
        
        //collectionView layout
        let width = (self.activitiesCollectionView.bounds.width - 12) / 2
        if let layout = self.activitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 12
        }
        activitiesCollectionView.reloadData()
    }

    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {

        segue.destination.dismiss(animated: false, completion: nil)
    }

    
    //Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        let item = controller.object(at: indexPath)
        
            cell.userArray = item.users?.allObjects as! [User]
            cell.userArray.sort(by: ({ $0.dateCreated?.compare($1.dateCreated! as Date) == .orderedAscending }))
        
        if cell.userArray.count > 0 {
            let userDate = item.dateCreated //activity date

            for user in cell.userArray {
                if userDate == user.dateCreated {
                    cell.currentUser = user
                    break
                } else {
                    cell.currentUser = cell.userArray.first
                }
            }
            cell.actUserName.text = cell.currentUser?.name
            cell.activityImage.image = cell.currentUser?.photo as? UIImage
            
        } else {
            cell.actUserName.text = ""
            cell.activityImage.image = nil
        }
        return cell
    }
    
    func configureCell(cell: ActivityCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditActivityVC" {
            if let destination = segue.destination as? EditActivityVC {
                if let item = sender as? Activity {
                    destination.activityEdit = item
                }
            }
        }
    }
    
    @IBAction func addActivity(_ sender: Any) {
        performSegue(withIdentifier: "AddActivityButton", sender: self)
    }

    @IBAction func editActivity(_ sender: Any) {
        performSegue(withIdentifier: "EditActivityVC", sender: self)
    }
    
    //Fetch
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //Controller
    var blockOperations = [BlockOperation]()

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if type == .insert {
            print("insert activity collectionView")
            blockOperations.append(BlockOperation(block: {
                (self.activitiesCollectionView?.insertItems(at: [newIndexPath!]))
            }))
        }
        if type == .delete {
            print("delete activity collectionView")
            blockOperations.append(BlockOperation(block: {
                (self.activitiesCollectionView?.deleteItems(at: [indexPath!]))
            }))
        }
        if type == .update {
            print("update activity collectionView")
            blockOperations.append(BlockOperation(block: {
                let cell = self.activitiesCollectionView.cellForItem(at: indexPath!) as! ActivityCell
                self.configureCell(cell: cell, indexPath: indexPath! as NSIndexPath)
            }))
        }
        if type == .move {
            print("move activity collectionView")
            blockOperations.append(BlockOperation(block: {
                if let indexPath = indexPath {
                    self.activitiesCollectionView.deleteItems(at: [indexPath])
                }
                if let indexPath = newIndexPath {
                    self.activitiesCollectionView.insertItems(at: [indexPath])
                }
            }))
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activitiesCollectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (completed) in
        })
    }
    
    func batchDelete() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDelete)
            print("deleted Activities")
        } catch {
            print("Error batch delete")
        }
    }

}

extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element
    
    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.index(of: item) {
            let lastItem: Bool = (index(after: itemIndex) == endIndex)
            
            if loop && lastItem {
                return self.first
            } else if lastItem {
                return nil
            } else {
                return self[index(after: itemIndex)]
            }
        }
        return nil
    }
    func before(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.index(of: item) {
            let firstItem: Bool = (itemIndex == startIndex)
            
            if loop && firstItem {
                return self.last
            } else if firstItem {
                return nil
            } else {
                return self[index(before:itemIndex)]
            }
        }
        return nil
    }
    
}
