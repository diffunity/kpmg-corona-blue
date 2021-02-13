//
//  HomeViewController.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/05.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var outerOverviewView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBGView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setProfileImageView()
        setOverviewView()
        setTableView()
        setTitleImage()
        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar() {
        let bar: UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func setTitleImage() {
        let logo = UIImage(named: "titleLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func setProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.layer.masksToBounds = true
        profileBGView.layer.cornerRadius = profileBGView.bounds.height/2
        profileBGView.layer.masksToBounds = true
    }
    
    func setOverviewView() {
        outerOverviewView.clipsToBounds = false
        outerOverviewView.layer.shadowColor = UIColor.black.cgColor
        outerOverviewView.layer.shadowOpacity = 0.1
        outerOverviewView.layer.shadowOffset = CGSize(width: 0, height: 10)
        outerOverviewView.layer.shadowRadius = 15
        
        overviewView.clipsToBounds = true
        overviewView.layer.cornerRadius = 15
        
        outerOverviewView.addSubview(overviewView)
    }
    
    func setTableView() {
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.1
        outerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        outerView.layer.shadowRadius = 15
//        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 15).cgPath
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        
        outerView.addSubview(containerView)
    }

    

    @IBAction func callButtonToggled(_ sender: Any) {
        print("calling")
        let handle = "01035198789"
        let videoEnabled = false
        
        let backgroundTaskIdentifier =
          UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            AppDelegate.shared.displayIncomingCall(
              uuid: UUID(),
              handle: handle,
              hasVideo: videoEnabled
            ) { _ in
              UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
    }
    
    
    
    @IBAction func playRecording(_ sender: Any) {
        playAudio()
    }
    
}
