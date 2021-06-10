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
    private var dataSource: Music!
    private var playingScreen: PlayingScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        self.musicViewModel = MusicViewModel()
        self.musicViewModel.bindMusicViewModelToController = { [self] in
            self.dataSource = musicViewModel.music
            self.updateDataSource()
        }
    }
    
    func updateDataSource() {
        if playingScreen == nil {
            playingScreen = PlayingScreen(music: dataSource, view: view)
            configureUI()
        } else {
            playingScreen?.update(music: dataSource)
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
    var lyrics: UITextView
    
    init(music: Music, view: UIView) {
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
        lyrics = UITextView().then {
            view.addSubview($0)
            $0.backgroundColor = .yellow
            $0.text = music.data.lyrics
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textContainer.maximumNumberOfLines = 2
            
        }
    }
    
    func update(music: Music) {
        titleLabel.text = music.data.title
        singerLabel.text = music.data.singer
        let url = URL(string: music.data.image)
        if let data = try? Data(contentsOf: url!) {
            image.image = UIImage(data: data)
        }
        albumLabel.text = music.data.album
        lyrics.text = music.data.lyrics
    }
}
