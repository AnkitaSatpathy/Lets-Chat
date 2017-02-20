//
//  ContactsVC.swift
//  Lets Chat
//
//  Created by Ankita Satpathy on 10/02/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit
import FirebaseAuth


class ContactsVC: UIViewController , UITableViewDataSource , UITableViewDelegate , FetchData{

    @IBOutlet weak var tableview: UITableView!
    var usename = ""
    
    private var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseProvider.Instance.delegate = self
         DatabaseProvider.Instance.getContacts()
           }

    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts
        
        for contact in contacts {
            if contact.id == FIRAuth.auth()?.currentUser?.uid {
                usename = contact.name
            }
        }
        tableview.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        do{
           try  FIRAuth.auth()?.signOut()
 
        }
        
        catch{
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
        
            
        }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = contacts[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chatSegue", sender: nil)
    }
    
}
