//
//  EditActivityTwoVC.swift
//  MyTurn
//
//  Created by Jill Uhl on 4/11/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class EditActivityTwoVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var activityName: UITextField!
    
    @IBOutlet weak var saveBtn: RoundedCorners!
    
    var activityEditTwo: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //dismiss textField and don't show button if no text
        self.activityName.delegate = self
        if activityName.text!.isEmpty {
            saveBtn.isUserInteractionEnabled = false
        }
        
        if activityEditTwo != nil {
            activityName.text = activityEditTwo?.name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (activityName.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty {
            saveBtn.isUserInteractionEnabled = true
        } else {
            saveBtn.isUserInteractionEnabled = false
        }
        return true
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        //save to core data
        var item: Activity!
        
        if activityEditTwo == nil {
            item = Activity(context: context)
        } else {
            item = activityEditTwo
        }
        
        if let nameOfActivity = activityName.text {
            item.name = nameOfActivity
        }
        
        adCoreData.saveContext()
        
        performSegue(withIdentifier: "EditToParticipantsVC", sender: item)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditToParticipantsVC" {
            if let destination = segue.destination as? ParticipantsVC {
                if let item = sender as? Activity {
                    destination.activityEdit = item
                }
            }
        }
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        if activityEditTwo != nil {
            context.delete(activityEditTwo!)

            adCoreData.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }

}
