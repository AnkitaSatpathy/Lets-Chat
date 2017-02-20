//
//  chatVC.swift
//  Lets Chat
//
//  Created by Ankita Satpathy on 11/02/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import Firebase

class chatVC: JSQMessagesViewController , messageReceivedDelegate,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    private var messages = [JSQMessage]()
    let picker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
       picker.delegate  = self
       MessagesHandler.instance.delegate = self
        
        
        
        // Do any additional setup after loading the view.
        self.senderId = FIRAuth.auth()!.currentUser!.uid
        //self.senderDisplayName = FIRAuth.auth()!.currentUser!.displayName
        self.senderDisplayName = FIRAuth.auth()!.currentUser!.email

        
        MessagesHandler.instance.observeMessages()
    }
    //collection view func
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        
        if message.senderId == self.senderId{
           return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.green)
        }
        else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue)
        }
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "images"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = messages[indexPath.row]
        
        if let mediaItem = msg.media as?  JSQVideoMediaItem {
            let player = AVPlayer(url: mediaItem.fileURL)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            self.present(playerVC, animated: true, completion: nil)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
            return cell
               }
    //end of collection view func
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        MessagesHandler.instance.sendMessages(senderID: senderId, senderName: senderDisplayName, text: text)
        
        //messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        //collectionView.reloadData()
        //remove text from textfield
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "MEDIA MESSAGES", message: "Select a media", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photos = UIAlertAction(title: "Photos", style: .default) { (alert) in
            self.chooseMedia(type: kUTTypeImage)
        }
        let videos = UIAlertAction(title: "Videos", style: .default) { (alert) in
            self.chooseMedia(type: kUTTypeVideo)
        }
        
        alert.addAction(photos)
        alert.addAction(videos)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //picker view
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage]  as? UIImage {
            let image = JSQPhotoMediaItem(image: pic)
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: image))
        }
        else if let vidUrl = info[UIImagePickerControllerMediaURL] as? URL {
            let video = JSQVideoMediaItem(fileURL: vidUrl, isReadyToPlay: true)
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
        }
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
    }
    //end picker view
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text))
        collectionView.reloadData()	
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
