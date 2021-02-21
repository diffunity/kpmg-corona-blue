//
//  RecordingManager.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/08.
//

import Foundation

class RecordingManager {
    static let shared = RecordingManager()
    
    var recordings = [String]()
    
    func addRecording(string: String) {
        recordings.append(string)
    }
    
    func count() -> Int {
        return recordings.count
    }
}
