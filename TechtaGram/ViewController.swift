//
//  ViewController.swift
//  TechtaGram
//
//  Created by Sakai Aoi on 2021/02/06.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage: UIImage!
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        } else {
            print("error")
        }
        
    }
    
    @IBAction func savePhoto(){
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    @IBAction func colorFilter(){
        let filterImage: CIImage = CIImage(image: originalImage)!
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        filter.setValue(1.0, forKey: "inputSaturation")
        filter.setValue(0.5, forKey: "inputBrightness")
        filter.setValue(2.5, forKey: "inputContrast")
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    @IBAction func openAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func snsPhoto(){
        let shareText = "テスト投稿"
        let shareImage = cameraImageView.image!
        let activityItems: [Any] = [shareText, shareImage]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y:self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        present(activityViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image = info[.editedImage] as? UIImage
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
    }
        


}

