//
//  NewItemViewController.swift
//  Drugs
//
//  Created by Ebtisam on 9/15/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//this is the last verison of this task

import UIKit
import CoreData

class NewItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var itemimage: UIImageView!
    
    @IBOutlet weak var itemname: UITextField!
    
    @IBOutlet weak var itemprice: UITextField!
    
    @IBOutlet weak var itemavailability: UITextField!
    
    @IBOutlet weak var itempickerview: UIPickerView!
    
    var EditOrDelete:Item?

    var imagepicker : UIImagePickerController?
    
    var listmerk = [Manufacturer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itempickerview.dataSource = self
        itempickerview.delegate = self
        imagepicker?.delegate = self
        imagepicker?.allowsEditing = true
        
        let tapgesture =  UITapGestureRecognizer(target: self, action: #selector(NewItemViewController.handleimage))
        itemimage.addGestureRecognizer(tapgesture)
        itemimage.isUserInteractionEnabled = true
        
        loadmerk()
        
        if EditOrDelete != nil{
            loadforedit()
        }
    }
    
    
    //start pickervew implement
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listmerk.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titlemerk = listmerk[row]
        return titlemerk.merk
    }
    
    //end pickervew implement
    
    
    func loadmerk(){
        
        // let fectchrequest:NSFetchRequest<Manufacturer>=Manufacturer.fetchRequest()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Manufacturer")
        do{
            
            listmerk = try context.fetch(request) as! [Manufacturer]
            //for data in listmerk as [NSManagedObject] {
            print("succed to get data")
            //}
        }
        catch {
            print("Could not fetch")
        }
    }
    
   
    
    
    @objc func handleimage(){
        
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        present(imagepicker , animated: true, completion: nil)
    }
    
    
    func loadforedit(){
        
        if let item = EditOrDelete{
            itemname.text = item.name
            itemprice.text = item.price
            itemimage.image = item.picture as! UIImage
            itemavailability.text = item.availability
            
            if let store = item.toManufacturer{
               
                var index = 0
                
                while index < listmerk.count{
                    let row = listmerk[index]
                    
                      if row.merk == store.merk{
                        
                        itempickerview.selectRow(index, inComponent: 0, animated: false)
                    }
                    
                    index = index + 1
                }
                
                
            }
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func backbutton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        // this code will excute when you selected an image for showing select image on profileimage
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            itemimage.image = image
        }
        
        
        dismiss(animated: true , completion: nil)
    }
    
    @IBAction func savenewitem(_ sender: Any) {
        
        let newitem = Item(context: context)
        newitem.name = itemname.text
        newitem.price = itemprice.text
        newitem.availability = itemavailability.text
        newitem.picture = itemimage.image
        newitem.toManufacturer = listmerk[itempickerview.selectedRow(inComponent: 0)]
        
        do{
            ad.saveContext()
            itemprice.text = ""
            itemname.text = ""
            itemavailability.text = ""
            print("done , new item saved ")
            
        }catch{
            
            print("failed , new item not saved ")
        }
    }
    
   
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)


    }
    
}
