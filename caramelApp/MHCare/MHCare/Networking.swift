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


struct UpdateRequestObj: Codable {
    let query: Int
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
    
    let photoDays: [String]
    let photoValues: [Double]
    let photoCount: [Int]
    
    
    let photoFacialUrl: [String]
    let photoFacialResult: [FacialResult]
    let photoNonFacialUrl: [String]
    let photoNonFacialResult: [NonFacialResult]
    
    
    
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
        
        case photoDays = "photo_days"
        case photoValues = "photo_values"
        case photoCount = "photo_count"
        
        
        case photoFacialUrl = "photo_facial_url"
        case photoFacialResult = "photo_facial_result"
        case photoNonFacialUrl = "photo_nonfacial_url"
        case photoNonFacialResult = "photo_nonfacial_result"
        

    }
    
}

struct FacialResult: Codable {
    let label: String
    let valence: Int
    let arousal: Int
}

struct NonFacialResult: Codable {
    let positive: Int
    let neutral: Int
    let negative: Int
}
