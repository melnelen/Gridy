//
//  StartViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 10/06/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class StartViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var gridyPickButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickRandomImage(_ sender: Any) {
        let random = Int.random(in: 0...Helper.localImages.count-1)
        if let image = UIImage(named: Helper.localImages[random]) {
            processPicked(image: image)
        }
    }
    
    @IBAction func pickCameraImage(_ sender: Any) {
        let sourceType = UIImagePickerController.SourceType.camera
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Camera is not supported by this device.")
            return
        }
        
        displayMediaPicker(sourceType: sourceType)
    }
    
    @IBAction func pickPhotoLibraryImage(_ sender: Any) {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Can't open photo library.")
            return
        }
        
        displayMediaPicker(sourceType: sourceType)
    }
    
    /// Use the Image Picker for: camera or photo library
    ///
    /// - Parameter sourceType: camera or photo library
    func displayMediaPicker(sourceType: UIImagePickerController.SourceType) {
        let media = sourceType == .camera ? "Camera" : "Photo Library"
      
      if UIImagePickerController.isSourceTypeAvailable(sourceType) {
        let noPermissionMessage = "We are sorry, looks like Gridy doesn't have access to your \(media) :(...\nTo enable, please go to \"Settings\" -> \"Gridy\" and enable  your \(media)."
        
        if sourceType == .camera {
          actionAccordingTo(status: AVCaptureDevice.authorizationStatus(for: AVMediaType.video), noPermissionMessage: noPermissionMessage)
        } else {
          actionAccordingTo(status: PHPhotoLibrary.authorizationStatus(), noPermissionMessage: noPermissionMessage)
        }
      } else {
        troubleAlert(message: "Something went terribly wrong. Gridy is unable to access your \(media) at this time")
      }
    }
    
    /// Ask the user the authorization to use the camera.
    /// User can redirect to Settings if authorization not granted.
    /// Call Image Picker if authorization has already been granted
    ///
    /// - Parameters:
    ///   - status: Authorization status to use Camera
    ///   - noPermissionMessage: Message to display if authorization not granted
    func actionAccordingTo(status: AVAuthorizationStatus , noPermissionMessage: String?) {
        let sourceType = UIImagePickerController.SourceType.camera
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    self.presentImagePicker(sourceType: sourceType)
                    print ("Access authorized.")
                } else {
                    self.troubleAlert(message: noPermissionMessage)
                }
            })
        case .authorized:
            self.presentImagePicker(sourceType: sourceType)
            print ("Access authorized.")
        case .denied, .restricted:
            self.troubleAlert(message: noPermissionMessage)
        default:
            self.troubleAlert(message: "Something went terribly wrong. Gridy is unable to access your photo library at this time.")
        }
    }
    
    /// Ask the user the authorization to use the photo library.
    /// User can redirect to Settings if authorization not granted.
    /// Call Image Picker if authorization has already been granted
    ///
    /// - Parameters:
    ///   - status: Authorization status to use PhotoLibrary
    ///   - noPermissionMessage: Message to display if authorization not granted
    func actionAccordingTo(status: PHAuthorizationStatus , noPermissionMessage: String?) {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == .authorized {
                    self.presentImagePicker(sourceType: sourceType)
                    print ("Access authorized.")
                }
                else {
                    self.troubleAlert(message: noPermissionMessage)
                }
            })
        case .authorized:
            self.presentImagePicker(sourceType: sourceType)
            print ("Access authorized.")
        case .denied, .restricted:
            self.troubleAlert(message: noPermissionMessage)
        default:
            self.troubleAlert(message: "Something went terribly wrong. Gridy is unable to access your photo library at this time.")
        }
    }

    /// Present image picker
    /// - Parameter sourceType: Camera or photo library
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Present trouble alert view
    /// - Parameter message: Message for the user
    func troubleAlert(message: String?) {
            let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Got it!", style: .cancel)
            alertController.addAction(OKAction)
            present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let newImage = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage else { return }
        processPicked(image: newImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("User did cancel.")
    }
    
    func processPicked(image: UIImage) {
        guard let editingViewController = storyboard?.instantiateViewController(withIdentifier: "ImageEditorViewController")
            as? ImageEditorViewController else { return }
        editingViewController.image = image
        self.present(editingViewController, animated: true, completion: nil)
    }
}
