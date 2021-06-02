//
//  ViewController.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/01.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    private var musicViewModel: MusicViewModel!
    private var dataSource: MusicData!
    private var playingScreen: PlayingScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        self.musicViewModel = MusicViewModel()
        self.musicViewModel.bindMusicViewModelToController = { [self] in
            self.dataSource = musicViewModel.musicData
            self.updateDataSource()
        }
    }
    
    func updateDataSource() {
        if playingScreen == nil {
            playingScreen = PlayingScreen(musicData: dataSource, view: view)
            configureUI()
        } else {
            playingScreen?.update(musicData: dataSource)
        }
    }
    
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
            $0.top.equalTo((playingScreen?.image)!).offset(25)
            $0.centerX.equalToSuperview()
        }
    }
    
}

struct PlayingScreen {
    var titleLabel: UILabel
    var singerLabel: UILabel
    var image: UIImageView
    var albumLabel: UILabel
    var lyrics: UITextView
    
    init(musicData: MusicData, view: UIView) {
        titleLabel = UILabel().then {
            view.addSubview($0)
            $0.text = musicData.title
            $0.font = $0.font.withSize(20)
        }
        singerLabel = UILabel().then {
            view.addSubview($0)
            $0.text = musicData.singer
        }
        
        let url = URL(string: musicData.image)
        image = UIImageView().then {
            view.addSubview($0)
            if let data = try? Data(contentsOf: url!) {
                $0.image = UIImage(data: data)
            }
            
        }
        albumLabel = UILabel().then {
            view.addSubview($0)
            $0.text = musicData.album
        }
        lyrics = UITextView().then {
            view.addSubview($0)
            $0.text = musicData.lyrics
        }
    }
    
    func update(musicData: MusicData) {
        titleLabel.text = musicData.title
        singerLabel.text = musicData.singer
        let url = URL(string: musicData.image)
        if let data = try? Data(contentsOf: url!) {
            image.image = UIImage(data: data)
        }
        albumLabel.text = musicData.album
        lyrics.text = musicData.lyrics
    }
}
