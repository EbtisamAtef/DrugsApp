//
//  NewMerkViewController.swift
//  Drugs
//
//  Created by Ebtisam on 9/15/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit

class NewMerkViewController: UIViewController {

    @IBOutlet weak var merkname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func savebtn(_ sender: Any) {
        
        let newmerk = Manufacturer(context: context)
        newmerk.merk = merkname.text
        
        do{
            ad.saveContext()
            merkname.text = ""
            print("saved")
        }catch{
            print("can not saved")
        }
        
    }
    
    
    
    @IBAction func merkback(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}
    
    
    
    
    
    
    

