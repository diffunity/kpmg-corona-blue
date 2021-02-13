//
//  Audio.swift
//  MHCare
//
//  Created by Jinwook Huh on 2021/02/07.
//

import AVFoundation

var audioRecorder: AVAudioRecorder!
var recordingSession: AVAudioSession!

var avplayer = AVPlayer()


func configureAudioSession() {
    print("Configuring audio session")
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
    } catch (let error) {
        print("Error while configuring audio session: \(error)")
    }
}

func startAudio() {
    print("Starting audio")
    do {
        recordingSession = AVAudioSession.sharedInstance()
        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true)
        recordingSession.requestRecordPermission() { allowed in
          if allowed {
            startRecording()
          }
        }
    } catch {
        // failed to record!
    }
    
}

func stopAudio() {
    print("Stopping audio")
    finishRecording(success: true)
    saveConvertedAudio()
}


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    print(paths.count)
    print(paths)
    return paths[0]
}

func startRecording() {
    let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
    print("--->\(audioFilename)")

    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    do {
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.record()
        print("starting record")
    } catch {
        finishRecording(success: false)
    }
}

func finishRecording(success: Bool) {
    audioRecorder.stop()
    audioRecorder = nil
//    let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp3")
    if !success {
      print("recording failed")
    }
}

func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
        finishRecording(success: false)
    }
}

func playAudio() {
    let url = getDocumentsDirectory().appendingPathComponent("recording.m4a")
    if FileManager.default.fileExists(atPath: url.path) {
      print("file exsist")
    } else {
      print("No file")
    }
    let item = AVPlayerItem(url: url)
    avplayer.replaceCurrentItem(with: item)
    avplayer.play()
}

func saveConvertedAudio() {
    let url = getDocumentsDirectory().appendingPathComponent("recording.m4a")
    let audioData = try! Data(contentsOf: url)
    let encodedString = audioData.base64EncodedString()
    RecordingManager.shared.addRecording(string: encodedString)
    print(RecordingManager.shared.count())
}
