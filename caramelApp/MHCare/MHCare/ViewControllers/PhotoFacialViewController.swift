//
//  PhotoFacialViewController.swift
//  MHCare
//
//  Created by 허진욱 on 2021/02/21.
//

import UIKit

class PhotoFacialViewController: UIViewController {

    let photoManager = PhotoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension PhotoFacialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoManager.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photo = photoManager.photos[indexPath.item]
        cell.updateUI(photo: photo)
        return cell
        
    }
    
    
}

extension PhotoFacialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

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
