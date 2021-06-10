//
//  MusicViewModel.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/02.
//

import Foundation

class MusicViewModel: NSObject {
    private var apiService: APIService!
    private(set) var music: Music! {
        didSet {
            self.bindMusicViewModelToController()
        }
    }
    
    var bindMusicViewModelToController: (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService = APIService()
        callFuncToGetMusicData()
    }
    
    func callFuncToGetMusicData() {
        self.apiService.apiToGetMusicData { [self] (musicData) in
            self.music = Music(isPlaying: false, data: musicData, lyrics: processLyrics(lyrics: musicData.lyrics))
        }
    }
    
    func processLyrics(lyrics: String) -> [ProcessedLyric] {
        let lineLyrics = lyrics.components(separatedBy: "\n").map{$0}
        var processedLyric = [ProcessedLyric]()
        lineLyrics.forEach {
            let components = $0.components(separatedBy: ["[", "]"])
            let time = components[1].components(separatedBy: ":").map { Int($0)! }
            let lyric = ProcessedLyric(timeInterval: time[0]*60000 + time[1]*1000 + time[2], text: components[2])
            processedLyric.append(lyric)
        }
        
        return processedLyric
    }
}
