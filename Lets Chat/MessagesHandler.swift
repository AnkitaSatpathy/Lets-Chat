//
//  MessagesHandler.swift
//  Lets Chat
//
//  Created by Ankita Satpathy on 19/02/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
protocol messageReceivedDelegate : class {
    func messageReceived(senderID: String ,senderName: String, text: String)
}

class MessagesHandler {
    
    private static let _instance = MessagesHandler()
    private init() { }
    
    weak var delegate: messageReceivedDelegate!
    
    static var instance : MessagesHandler {
        return _instance
    }
    
    func sendMessages(senderID: String , senderName : String , text: String){
        
        let data: [String: AnyObject] = [Constants.SENDER_ID :  senderID as AnyObject,
                                         Constants.SENDER_NAME : senderName as AnyObject,
                                          Constants.TEXT : text as AnyObject]
        
        DatabaseProvider.Instance.messagesRef.childByAutoId().setValue(data)
    }
    
    func observeMessages() {
        DatabaseProvider.Instance.messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot)  in
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let text = data[Constants.TEXT] as? String {
                        if let senderName = data[Constants.SENDER_NAME] as? String{
                            self.delegate.messageReceived(senderID: senderID, senderName: senderName, text: text)

                        }
                    }
                }
             }
        }
    }
    
    
}
