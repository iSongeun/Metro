//
//  StationArrivalDataResponseModel.swift
//  Met
//
//  Created by 이송은 on 2022/12/13.
//

import Foundation

struct StationArrivalDataResponseModel : Decodable {
    var realtimeArrivalList : [RealTimeArrival] = []
    
    struct RealTimeArrival : Decodable {
        let line : String //~행
        let remainTime : String //도착정보
        let currentStation : String //현재위치
        
        enum CodingKeys : String , CodingKey {
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
        }
    }
}
