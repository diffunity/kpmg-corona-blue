//
//  PhotoCell.swift
//  MHCare
//
//  Created by 허진욱 on 2021/02/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    
    func updateUI(photo: UIImage) {
        photoImage.image = photo
    }
}


class PhotoManager {
    var photos:[UIImage] = []
    
    init() {
        let photos = loadPhotos()
        self.photos = photos
    }
    
    func loadPhotos() -> [UIImage] {
        let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) ?? []
        var images:[UIImage] = []
        for url in urls {
            let data = try! Data(contentsOf: url)
            images.append(UIImage(data: data)!)
        }
        
        return images
    }
}
