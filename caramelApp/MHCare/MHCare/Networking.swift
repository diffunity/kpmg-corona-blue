//
//  Networking.swift
//  MHCare
//
//  Created by 허진욱 on 2021/02/21.
//

import UIKit


struct RequestObj: Codable {
    let project_type: String
    let data: AudioObj
}

struct AudioObj: Codable {
    let type: String
    let create_date_time: String
    let content: String
}
