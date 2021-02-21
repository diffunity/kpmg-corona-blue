//
//  HomeTableViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/05.
//

import UIKit
import Charts

class HomeTableViewController: UITableViewController {

    var textData: TextData!
    var voiceData: VoiceData!
    var photoData: PhotoData!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let destinationViewController = navigationController?.storyboard?.instantiateViewController(identifier: "VoiceViewController") as? VoiceViewController {
                voiceData = GraphData.shared.voiceData
                destinationViewController.voiceData = voiceData
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        } else if indexPath.row == 1 {
            if let destinationViewController = navigationController?.storyboard?.instantiateViewController(identifier: "PhotoViewController") as? PhotoViewController {
                photoData = GraphData.shared.photoData
                destinationViewController.photoData = photoData
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        } else {
            if let destinationViewController = navigationController?.storyboard?.instantiateViewController(identifier: "TextViewController") as? TextViewController {
                textData = GraphData.shared.textData
                destinationViewController.textData = textData
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
    }
}
