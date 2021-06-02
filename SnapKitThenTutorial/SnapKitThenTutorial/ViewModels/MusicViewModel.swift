//
//  MusicViewModel.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/02.
//

import Foundation

class MusicViewModel: NSObject {
    private var apiService: APIService!
    private(set) var musicData: MusicData! {
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
        self.apiService.apiToGetMusicData { (musicData) in
            self.musicData = musicData
        }
    }
}
