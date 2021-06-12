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
    
    // func to play sound
    func playSound(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 2.0
            audioPlayer.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    func downloadFileFromURL() {
        let url = URL(string: dataSource.data.file)
        var downloadTask:URLSessionDownloadTask
        
        downloadTask = URLSession.shared.downloadTask(with: url!) { (url, response, error) in
            self.playSound(url: url!)
        }
        downloadTask.resume()
    }
    
    // MARK: - Data
    func updateDataSource() {
        if playingScreen == nil {
            playingScreen = PlayingScreen(music: dataSource, view: view, viewController: self)
            configureUI()
            downloadFileFromURL()
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

struct PlayingScreen {
    var titleLabel: UILabel
    var singerLabel: UILabel
    var image: UIImageView
    var albumLabel: UILabel
    var lyrics: UIPickerView
    var lyricRowSize: Double
    
    init(music: Music, view: UIView, viewController: ViewController) {
        titleLabel = UILabel().then {
            view.addSubview($0)
            $0.text = music.data.title
            $0.font = $0.font.withSize(20)
        }
        singerLabel = UILabel().then {
            view.addSubview($0)
            $0.text = music.data.singer
        }
        
        let url = URL(string: music.data.image)
        image = UIImageView().then {
            view.addSubview($0)
            if let data = try? Data(contentsOf: url!) {
                $0.image = UIImage(data: data)
                $0.layer.cornerRadius = 10
                $0.layer.masksToBounds = true
            }
            
        }
        albumLabel = UILabel().then {
            view.addSubview($0)
            $0.text = music.data.album
        }
        lyrics = UIPickerView().then {
            view.addSubview($0)
            $0.dataSource = viewController
            $0.delegate = viewController
        }
        lyricRowSize = Double(lyrics.rowSize(forComponent: 0).height)
    }
    
    func update(music: Music) {
        titleLabel.text = music.data.title
        singerLabel.text = music.data.singer
        let url = URL(string: music.data.image)
        if let data = try? Data(contentsOf: url!) {
            image.image = UIImage(data: data)
        }
        albumLabel.text = music.data.album
        //        lyrics.text = music.data.lyrics
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
