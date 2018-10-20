//
//  ListViewController.swift
//  Drugs
//
//  Created by Ebtisam on 9/15/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate, UISearchDisplayDelegate,NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var names: [NSManagedObject] = []
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        searchbar.delegate = self
        loaditem()
        tableview.reloadData()

        
    }
    
    
    func loaditem(){
        
        let ad = UIApplication.shared.delegate as! AppDelegate
        let context = ad.persistentContainer.viewContext
        let fetchrequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchrequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            print("yes its work")
            try fetchedResultsController?.performFetch()
        }catch{
            print("faild can not featch data")
        }
        
        tableview.reloadData()

    }
    
    //MARK: UITableView Data Source and Delegate Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as! TableViewCell
        
        if let cellitem = fetchedResultsController?.object(at: indexPath) as? Item {
            
            cell.namecell.text = "Name : \(cellitem.name ?? "")"
            cell.availabilitycell.text = "Availability : \(cellitem.availability ?? "")"
            cell.pricecell.text = "Price : \(cellitem.price ?? "")"
            cell.categorycell.text = "Merk : \(cellitem.toManufacturer?.merk ?? "")"
            cell.imagecell.image = cellitem.picture as? UIImage
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objc = fetchedResultsController?.fetchedObjects{
            let item = [indexPath.row]
            performSegue(withIdentifier: "EditOrdelete", sender: item)
        }
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditOrdelete" {
            if let destination = segue.destination as? NewItemViewController{
                if let item = sender as? Item{
                    destination.EditOrDelete = item
                }
            }
        }
    }
    
    
    
    //MARK: NSFetchedResultsController Delegate Functions
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case NSFetchedResultsChangeType.insert:
            tableview.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: UITableViewRowAnimation.fade)
            break
        case NSFetchedResultsChangeType.delete:
            tableview.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: UITableViewRowAnimation.fade)
            break
        case NSFetchedResultsChangeType.move:
            break
        case NSFetchedResultsChangeType.update:
            break
        default:
            break
        }
    }
    
    
    
    
    
    private func controllerWillChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>){
        
        tableview.beginUpdates()
    }
    
    public enum NSFetchedResultsChangeType : UInt {
        
        case insert
        
        case delete
        
        case move
        
        case update
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableview.cellForRow(at: indexPath) {
                //configureCell(cell, at: indexPath)
            }
            break;
            
        case .move:
            if let indexPath = indexPath {
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableview.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
            
        }
    }
    
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        
        tableview.endUpdates()
        
    }
    

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        if !searchText.isEmpty {
            // Clear out the fetchedResultController
            fetchedResultsController = nil
            
            // Setup the fetch request
            let fetchrequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")

            fetchrequest.fetchLimit = 25
            
            fetchrequest.predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
            
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            
            fetchrequest.sortDescriptors = [sortDescriptor]
            
            // Pass the fetchRequest and the context as parameters to the fetchedResultController
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext:context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
            
            // Make the fetchedResultController a delegate of the MoviesViewController class
            fetchedResultsController?.delegate = self as? NSFetchedResultsControllerDelegate
            
            // Execute the fetch request or display an error message in the Debugger console
            
            
            do{
                print("yes its work")
                try fetchedResultsController?.performFetch()
            }catch{
                print("faild can not featch data")
            }
            
            // Refresh the table view to show search results
            tableview.reloadData()
        }
    }
    

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.text = nil
        searchbar.showsCancelButton = false // Hide the cancel
        searchbar.resignFirstResponder() // Hide the keyboard
        loaditem()
        
        // Refresh the table view to show fetchedResultController results
        tableview.reloadData()
    }
    
    @IBAction func BuyNowbtn(_ sender: Any) {
        
        let myphone = "+134345345345"
   
        if let url = URL(string:"telprompt://\(myphone)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("calling now")
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    @IBAction func logoutbtn(_ sender: Any) {
        
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "signinview")
            self.present(vc, animated: false, completion: nil)
        }
        
        
        
        
       }
    
    
}
