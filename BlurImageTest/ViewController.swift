//
//  ViewController.swift
//  BlurImageTest
//
//  Created by Mathew, Aby (Buck) on 14/05/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private var imgView1: UIImageView!
    @IBOutlet private var imgView2: UIImageView!
    @IBOutlet private var showButton: UIButton!
    
    
    private var context = CIContext(options: nil)
    private var isAppliedBlurAndText: Bool = false {
        didSet {
            showButton.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func clickButtonAction(_ sender: Any) {
        imgView2.image = createImageWithLabelOverlay()
    }
    
    @IBAction func applyTextOverlayAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.applyBlurEffect()
        }
        
    }
    
    fileprivate func applyBlurEffect() {

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: imgView1.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imgView1.image = processedImage
        
        applyTextOverlay()
    }
    
    
    
    fileprivate func applyTextOverlay(){
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .green
        label.text = "Racing Track"
        label.font = label.font.withSize(50)
        
        label.translatesAutoresizingMaskIntoConstraints = false
    
        imgView1.addSubview(label)
        
        NSLayoutConstraint.activate([
        
            label.centerYAnchor.constraint(equalTo: imgView1.centerYAnchor),
             label.centerXAnchor.constraint(equalTo: imgView1.centerXAnchor),
             label.widthAnchor.constraint(equalTo: imgView1.widthAnchor),
             label.heightAnchor.constraint(equalTo: imgView1.heightAnchor),
            
        ])
        
        isAppliedBlurAndText = true
    }
    
     func createImageWithLabelOverlay() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imgView1.frame.width, height: imgView1.frame.height), false, 2.0)
        imgView1.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

