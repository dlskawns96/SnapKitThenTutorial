//
//  ViewController.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/01.
//

import UIKit
import SnapKit
import Then
import AVFoundation

class ViewController: UIViewController {
    
    private var musicViewModel: MusicViewModel!
    private var dataSource: Music!
    private var playingScreen: PlayingScreen?
    private var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callToViewModelForUIUpdate()
        
    }
    
    func playMusic() {
        dataSource.audioPlayer!.prepareToPlay()
        dataSource.audioPlayer!.play()
        playingScreen?.menuSet.onPlayButtonClicked = pauseMusic
        playingScreen?.menuSet.playButton.setImage(UIImage(named: "PauseButton"), for: .normal)
    }
    
    func pauseMusic() {
        dataSource.audioPlayer!.pause()
        playingScreen?.menuSet.onPlayButtonClicked = playMusic
        playingScreen?.menuSet.playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
    }
    
    // MARK: - Data
    func updateDataSource() {
        if playingScreen == nil {
            playingScreen = PlayingScreen(music: dataSource, view: view, viewController: self)
            configureUI()
            self.playingScreen?.menuSet.onPlayButtonClicked = self.playMusic
        } else {
            playingScreen?.update(music: dataSource)
        }
    }
    
    func callToViewModelForUIUpdate() {
        self.musicViewModel = MusicViewModel()
        self.musicViewModel.bindMusicViewModelToController = { [self] in
            self.dataSource = musicViewModel.music
            self.updateDataSource()
        }
    }
    
    // MARK: - Processing UI
    func configureUI() {
        view.backgroundColor = .white
        playingScreen?.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(125)
            $0.centerX.equalToSuperview()
        }
        playingScreen?.singerLabel.snp.makeConstraints {
            $0.top.equalTo((playingScreen?.titleLabel)!).offset(50)
            $0.centerX.equalToSuperview()
        }
        playingScreen?.image.snp.makeConstraints {
            $0.top.equalTo((playingScreen?.singerLabel)!).offset(50)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(75)
            $0.trailing.equalToSuperview().inset(75)
            $0.height.equalTo((playingScreen?.image)!.snp.width)
        }
        playingScreen?.lyrics.snp.makeConstraints {
            $0.top.equalTo((playingScreen?.image.snp.bottom)!)
            $0.height.equalTo((playingScreen?.lyricRowSize)! * 3.0)
            
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.lyrics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource.lyrics[row].text
    }
}
