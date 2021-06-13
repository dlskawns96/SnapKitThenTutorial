//
//  APIService.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/02.
//

import Foundation
import Alamofire

class APIService: NSObject {
    private let sourceURL =  "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    
    func apiToGetMusicData(completion: @escaping (MusicData) -> ()) {
        AF.request(sourceURL, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MusicData.self) { (data) in
                guard let musicData = data.value else { return }
                completion(musicData)
            }
    }
    
    func downloadMusic(url: URL,completion: @escaping (Data) -> ()) {
        AF.download(url)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.value {
                    completion(data)
                }
            }
    }
}
