//
//  AddActivityVC.swift
//  MyTurn
//
//  Created by Jill Uhl on 4/10/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class AddActivityVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var activityName: UITextField!
    
    @IBOutlet weak var saveBtnOutlet: RoundedCorners!
    
    var activityEdit: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //dismiss textField and disable button if no text
        activityName.delegate = self
        
        if activityEdit != nil {
            activityName.text = activityEdit?.name
        }
        
        if activityName.text!.isEmpty {
            saveBtnOutlet.isEnabled = false
            saveBtnOutlet.alpha = 0.5
        }
 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (activityName.text! as NSString).replacingCharacters(in: range, with: string)

        if text.isEmpty {
            saveBtnOutlet.isEnabled = false
            saveBtnOutlet.alpha = 0.5
        } else {
            saveBtnOutlet.isEnabled = true
            saveBtnOutlet.alpha = 1.0
        }
        return true
    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteBtn(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Delete Activity", message: "Are you sure?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (ACTION) -> Void in
            if self.activityEdit != nil {
                context.delete(self.activityEdit!)
                
                adCoreData.saveContext()
            }
            self.navigationController?.popViewController(animated: true)
        })
        let no = UIAlertAction(title: "No", style: .default, handler: { (ACTION) -> Void in
            dialogMessage.dismiss(animated: true, completion: nil)
        })
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    
        //save to core data
        var item: Activity!
        
        if activityEdit == nil {
            item = Activity(context: context)
        } else {
            item = activityEdit
        }
        
        if let nameOfActivity = activityName.text {
            item.name = nameOfActivity
        }
        
        adCoreData.saveContext()
        
        performSegue(withIdentifier: "ParticipantsVC", sender: item)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParticipantsVC" {
            if let destination = segue.destination as? ParticipantsVC {
                if let item = sender as? Activity {
                    destination.activityEdit = item
                }
            }
        }
        print("segue")
    }
    
}

