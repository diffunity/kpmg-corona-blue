//
//  Networking.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/21.
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



struct ResponseObj: Codable {
    let textDays: [String]
    let textValues: [Double]
    let textEmotions: [String]
    let textEmotionValues: [Double]
    let textCount: [Int]
    
    let voiceContentDays: [String]
    let voiceContentValues: [Double]
    let voiceContentEmotions: [String]
    let voiceContentEmotionValues: [Double]
    let voiceContentCount: [Int]
    
    let voiceToneDays: [String]
    let voiceToneValues: [Double]
    let voiceToneCount: [Int]
    
    enum CodingKeys: String, CodingKey {
        case textDays = "text_days"
        case textValues = "text_values"
        case textEmotions = "text_emotions"
        case textEmotionValues = "text_emotion_values"
        case textCount = "text_count"
        
        case voiceContentDays = "voice_content_days"
        case voiceContentValues = "voice_content_values"
        case voiceContentEmotions = "voice_content_emotions"
        case voiceContentEmotionValues = "voice_content_emotion_values"
        case voiceContentCount = "voice_content_count"
        
        case voiceToneDays = "voice_tone_days"
        case voiceToneValues = "voice_tone_values"
        case voiceToneCount = "voice_tone_count"
    }
    
}
