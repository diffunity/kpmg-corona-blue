//
//  DetailPhotoViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/21.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    
    var image = UIImage()
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = image

        // Do any additional setup after loading the view.
    }
    


}
