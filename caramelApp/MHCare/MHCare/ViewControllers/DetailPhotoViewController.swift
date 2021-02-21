//
//  DetailPhotoViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/21.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    
    var image = UIImage()
    
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
    }


}
