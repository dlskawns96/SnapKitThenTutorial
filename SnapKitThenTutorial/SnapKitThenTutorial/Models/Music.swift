//
//  Music.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/02.
//

import Foundation
import AVFoundation

struct Music {
    var isPlaying: Bool
    var data: MusicData
    var lyrics: [ProcessedLyric]
    var audioPlayer: AVAudioPlayer? = nil
    
    var playButtonAction = {}
    var previousButtonAction = {}
    var nextButtonAction = {}
}

struct MusicData: Codable {
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
//    let processedLyrics: [Double:String]
}

struct ProcessedLyric {
    let timeInterval: Int
    let text: String
}
