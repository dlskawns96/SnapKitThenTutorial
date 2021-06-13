//
//  PlayingScreen.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/13.
//

import UIKit

struct PlayingScreen {
    var titleLabel: UILabel
    var singerLabel: UILabel
    var image: UIImageView
    var albumLabel: UILabel
    var lyrics: UIPickerView
    var lyricRowSize: Double
    var menuSet: MenuSet
    
    init(music: Music, view: UIView, viewController: ViewController) {
        titleLabel = UILabel().then {
            view.addSubview($0)
            $0.text = music.data.title
            $0.font = $0.font.withSize(20)
            $0.textColor = .black
        }
        singerLabel = UILabel().then {
            view.addSubview($0)
            $0.text = music.data.singer
            $0.textColor = .black
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
            $0.textColor = .black
        }
        lyrics = UIPickerView().then {
            view.addSubview($0)
            $0.dataSource = viewController
            $0.delegate = viewController
            $0.backgroundColor = .red
        }
        lyricRowSize = Double(lyrics.rowSize(forComponent: 0).height)
        menuSet = MenuSet(view: view, lyricView: lyrics)
    }
    
    func update(music: Music) {
        titleLabel.text = music.data.title
        singerLabel.text = music.data.singer
        let url = URL(string: music.data.image)
        if let data = try? Data(contentsOf: url!) {
            image.image = UIImage(data: data)
        }
        albumLabel.text = music.data.album
    }
}

class MenuSet {
    let playButton: UIButton
    let nextButton: UIButton
    let previousButton: UIButton
    
    var onPlayButtonClicked = {}
    var onPreviousButtonClicked = {}
    var onNextButtonClicked = {}
    
    init(view: UIView, lyricView: UIPickerView) {
        playButton = UIButton().then {
            $0.setImage(UIImage(named: "PlayButton"), for: .normal)
            $0.contentMode = .scaleToFill
        }
        nextButton = UIButton().then {
            $0.contentMode = .scaleToFill
            $0.setImage(UIImage(named: "NextButton"), for: .normal)
        }
        previousButton = UIButton().then {
            $0.contentMode = .scaleToFill
            $0.setImage(UIImage(named: "PreviousButton"), for: .normal)
        }
        addActions()
        view.addSubview(playButton)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        configureUI(lyricView: lyricView)
    }
    
    func addActions() {
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonAction), for: .touchUpInside)
    }
    
    func configureUI(lyricView: UIPickerView) {
        playButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(25)
            $0.top.equalTo(lyricView.snp.bottom).offset(20)
        }
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(playButton)
            $0.width.height.equalTo(25)
            $0.centerX.equalToSuperview().offset(50)
        }
        previousButton.snp.makeConstraints {
            $0.centerY.equalTo(playButton)
            $0.width.height.equalTo(25)
            $0.centerX.equalToSuperview().offset(-50)
        }
    }
    
    @objc func playButtonAction() {
        print("Play button clicked")
        onPlayButtonClicked()
    }
    
    @objc func previousButtonAction(_ sender: Any) {
        print("Previous button clicked")
        onPreviousButtonClicked()
    }
    
    @objc func nextButtonAction(_ sender: Any) {
        print("Next button clicked")
        onNextButtonClicked()
    }
}

