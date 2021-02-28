//
//  DetailNonFacialViewController.swift
//  MHCare
//
//  Created by 허진욱 on 2021/02/22.
//

import UIKit

class DetailNonFacialViewController: UIViewController {

    var results: NonFacialResult!
    
    
    var image = UIImage()
    
    @IBOutlet weak var positiveLabel: UILabel!
    
    @IBOutlet weak var neutralLabel: UILabel!
    
    
    @IBOutlet weak var negativeLabel: UILabel!
    
    
    @IBOutlet weak var photoOuterView: UIView!
    
    @IBOutlet weak var photoTabView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabUI()
        photoImageView.image = image
        // Do any additional setup after loading the view.
    }
    
    
    func setTabUI() {
        photoOuterView.clipsToBounds = false
        photoOuterView.layer.shadowColor = UIColor.black.cgColor
        photoOuterView.layer.shadowOpacity = 0.3
        photoOuterView.layer.shadowOffset = CGSize(width: 0, height: 10)
        photoOuterView.layer.shadowRadius = 15
        
        photoTabView.clipsToBounds = true
        photoTabView.layer.cornerRadius = 15
        
        photoOuterView.addSubview(photoTabView)
        
        positiveLabel.text = String(results.positive) + "%"
        neutralLabel.text = String(results.neutral) + "%"

        negativeLabel.text = String(results.negative) + "%"

    }

}
