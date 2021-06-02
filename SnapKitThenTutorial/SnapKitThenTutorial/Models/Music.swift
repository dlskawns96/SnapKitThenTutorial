//
//  Music.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/02.
//

import Foundation

struct Music {
    var isPlaying: Bool
    let data: MusicData
}

struct MusicData: Codable {
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
}
