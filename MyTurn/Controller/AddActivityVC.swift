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
        
        //dismiss textField and don't show button if no text
        self.activityName.delegate = self
        if activityName.text!.isEmpty {
            saveBtnOutlet.isUserInteractionEnabled = false
        }
        
        if activityEdit != nil {
            activityName.text = activityEdit?.name
        }
        
        //        if let topItem = self.navigationController?.navigationBar.topItem {
        //
        //            topItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        //        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (activityName.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty {
            saveBtnOutlet.isUserInteractionEnabled = true
        } else {
            saveBtnOutlet.isUserInteractionEnabled = false
        }
        return true
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

