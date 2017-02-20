//
//  DatabaseProvider.swift
//  Lets Chat
//
//  Created by Ankita Satpathy on 10/02/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


protocol FetchData : class {
    func dataReceived(contacts: [Contact])
}
class DatabaseProvider {
    private static let instance = DatabaseProvider()
    
    weak var delegate: FetchData!
    
    private init() {}
    
    static var Instance : DatabaseProvider {
        return instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var contactsRef : FIRDatabaseReference {
        return dbRef.child(Constants.CONTACTS)
    }
    var messagesRef : FIRDatabaseReference {
        return dbRef.child(Constants.MESSAGES)
    }
    
    var mediamessagesRef : FIRDatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES)
    }
    
    var storageRef : FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://lets-chat-b7106.appspot.com")
    }
    
    var imageStorageRef : FIRStorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    
    var videoStorageRef : FIRStorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE)
    }
    
    func  saveUser(id: String, email: String, paasword: String) {
        let data: [String : AnyObject] = [Constants.EMAIL: email as AnyObject  , Constants.PASSWORD: paasword as AnyObject]
        contactsRef.child(id).setValue(data)
    }
    
    func getContacts(){
        
        var con = [Contact]()
        contactsRef.observeSingleEvent(of: .value) { (snapshot : FIRDataSnapshot) in
            var contacts = [Contact]()
            if let myContacts = snapshot.value as? NSDictionary{
                for (key ,value) in myContacts {
                    if let contactData = value as? NSDictionary {
                        if let email = contactData[Constants.EMAIL] as? String {
                            let id = key as! String
                            let newContact = Contact(id: id, name: email)
                            contacts.append(newContact)
                         }
                        
                    }
                }
            }
            self.delegate.dataReceived(contacts: contacts)
        }
        //contactsRef.removeAllObservers()
       
        
    }
}
