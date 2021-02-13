//
//  HomeTableViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/05.
//

import UIKit
import Charts

class HomeTableViewController: UITableViewController {

        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let destinationViewController = navigationController?.storyboard?.instantiateViewController(identifier: "VoiceViewController") as? VoiceViewController {
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        } else if indexPath.row == 1 {
            if let destinationViewController = navigationController?.storyboard?.instantiateViewController(identifier: "PhotoViewController") as? PhotoViewController {
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        } else {
            if let destinationViewController = navigationController?.storyboard?.instantiateViewController(identifier: "TextViewController") as? TextViewController {
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
    }
}
