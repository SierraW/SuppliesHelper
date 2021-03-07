//
//  CameraCountViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-17.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

class CameraCountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func btnCamera(_ sender: Any) {
        getImage(from: .camera)
    }
    @IBAction func btnAlbum(_ sender: Any) {
        getImage(from: .photoLibrary)
    }
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var notificationView: NotificationView!
    
    var pickImageController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "图片数杯杯"
        imgView.image = UIImage(named: "Smart")
        addNotifyButton()
        notificationView.showBlurEffect(of: view.bounds)
        self.perform(#selector(showNotification), with: nil, afterDelay: 0.2)
    }
    
    func addNotifyButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showNotification))
        
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func showNotification() {
        if self.notificationView.alpha < CGFloat(0.5) {
            UIView.animate(withDuration: 0.4, animations: {
                self.notificationView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.notificationView.alpha = 0
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickImageController.dismiss(animated: true, completion: nil)
        if pickImageController.allowsEditing {
            imgView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        } else {
            imgView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
    }
    
    func getImage(from source: UIImagePickerController.SourceType) {
        pickImageController = UIImagePickerController.init()
        pickImageController.sourceType = source
        pickImageController.allowsEditing = false
        pickImageController.delegate = self
        present(pickImageController, animated: true, completion: nil)
    }
        
        //if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            //PHPhotoLibrary.requestAuthorization({ (status) in
                //switch status {

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cdvc = segue.destination as? CountDetailViewController {
            let image = imgView.image!
            cdvc.img = image
            if segue.identifier == "Count Detail"{
                cdvc.mode = .normal
            } else if segue.identifier == "Count Detail Contrast" {
                cdvc.mode = .contrast
            }
        }
        
        
    }

}
