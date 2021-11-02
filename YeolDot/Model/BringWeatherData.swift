//
//  BringWeatherData.swift
//  YeolDot
//
//  Created by 김민우 on 02/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import UIKit
import CocoaMQTT

//날씨 데이터 가져오는 클래스
class BringWeatherData{
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    //날씨상태 구독 함수 (county = 행정구, mqtt: 클라이언트)
    static func subToWeather(_ county: String, _ mqtt: CocoaMQTT){
        //API 마지막 업데이트 시간 (요청 시간 기준 5분간격)
        mqtt.subscribe("weather/"+county+"/time", qos: CocoaMQTTQOS.qos2)
        
        //행정구 미세먼지, 초미세먼지 상태 구독 (.qos2 = 정확히 한번 전송)
        mqtt.subscribe("weather/"+county+"/dust/PM10", qos: CocoaMQTTQOS.qos2)
        mqtt.subscribe("weather/"+county+"/dust/PM25", qos: CocoaMQTTQOS.qos2)
        
        //행정구 온도와 기상상태 구독(.qos2 = 정확히 한번 전송)
        //송파구 API만 call시켜놔서 다른 구역은 불가능. 구독해도 값 들어오지 않음.
        mqtt.subscribe("weather/"+county+"/temperature", qos: CocoaMQTTQOS.qos2)
        mqtt.subscribe("weather/"+county+"/sky", qos: CocoaMQTTQOS.qos2)
    }
    
    //날씨상태 메시지 함수 (county = 행정구, mqtt: 클라이언트, message: MQTT메시지)
    static func bringMsg(_ county: String, _ mqtt: CocoaMQTT, message: CocoaMQTTMessage){
        if let msg = message.string {
            if(message.topic == "weather/"+county+"/time"){ //받은 메시지가 weather/구역/time 토픽일때
                //MQTT 시간 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_time"), object: msg)
            }
        }
        if let msg = message.string {
            if(message.topic == "weather/"+county+"/dust/PM10"){ //받은 메시지가 weather/구역/dust/PM10 토픽일때
                //MQTT 미세먼지 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_fineDust"), object: msg)
            }
        }
        if let msg = message.string {
            if(message.topic == "weather/"+county+"/dust/PM25"){ //받은 메시지가 weather/구역/dust/PM25 토픽일때
                //MQTT 초미세먼지 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_ultrafineDust"), object: msg)
            }
        }
        if let msg = message.string {
            if(message.topic == "weather/"+county+"/temperature"){ //받은 메시지가 weather/구역/dust/PM25 토픽일때
                //MQTT 온도 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_temperature"), object: msg)
            }
        }
        if let msg = message.string {
            if(message.topic == "weather/"+county+"/sky"){ //받은 메시지가 weather/구역/sky 토픽일때
                //MQTT 기상 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_sky"), object: msg)
            }
        }
    }
    
}
