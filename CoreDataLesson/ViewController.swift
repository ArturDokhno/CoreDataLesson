//
//  ViewController.swift
//  CoreDataLesson
//
//  Created by Артур Дохно on 19.02.2022.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var dataStoreManager =  DataStoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = dataStoreManager.obtainModelUser()
        
        nameLabel.text = user.name! + " " + (user.company?.name ?? " ")
        ageLabel.text = String(user.age)
        
        nameLabel.sizeToFit()
        ageLabel.sizeToFit()
        
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
//        print("\(textField.text)")
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let name = textField.text else { return }
        
        dataStoreManager.updateMainUser(with: name)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func removeButton(_ sender: Any) {
        
        dataStoreManager.removeNameUser()
    }
    
    
}

