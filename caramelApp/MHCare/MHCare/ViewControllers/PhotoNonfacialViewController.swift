//
//  PhotoNonfacialViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/21.
//

import UIKit

class PhotoNonfacialViewController: UIViewController {

    let photoManager = PhotoManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension PhotoNonfacialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GraphData.shared.photoData.photoNonFacialImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photo = GraphData.shared.photoData.photoNonFacialImages[indexPath.item]
        cell.updateUI(photo: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "DetailNonFacialViewController") as? DetailNonFacialViewController else {
            return
        }
        detailVC.image = GraphData.shared.photoData.photoNonFacialImages[indexPath.item]
        detailVC.results = GraphData.shared.photoData.photoNonFacialResults[indexPath.item]
        present(detailVC, animated: true, completion: nil)
    }
    
}


extension PhotoNonfacialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}
