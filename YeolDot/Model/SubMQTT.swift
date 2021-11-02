//
//  SubMQTT.swift
//  YeolDot
//
//  Created by 김민우 on 02/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import CocoaMQTT

//MQTT 사용 클래스
class SubMQTT: CocoaMQTTDelegate{
    static let client = CocoaMQTT(clientID: "YeolDot-1", host: "manage.mwkim177.xyz", port: 1883) //MQTT 클라이언트 설정
    
    func connectionSetting () {
        SubMQTT.client.keepAlive = 60 //연결시간 설정
        SubMQTT.client.delegate = self //클라이언트 delegate CocoaDelegate로
    }
    
    func connect(){
        //연결중, 연결된 상태가 아닐때 연결
        if(SubMQTT.client.connState != .connected && SubMQTT.client.connState != .connecting){
            _ = SubMQTT.client.connect()
        }
    }
    
}

//CocoaMQTT 함수
extension SubMQTT{
    //메시지를 받았을때 처리함수
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        BringWeatherData.bringMsg("송파구", SubMQTT.client, message: message) //날씨 메시지
        BringDeviceData.bringMsg(SubMQTT.client, message: message) //기기 메시지
    }
    
    //서버에 연결됐을때
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("연결됨")
        //클라이언트 상태가 연결되었을때 구독
        if(SubMQTT.client.connState == .connected){
            BringWeatherData.subToWeather("송파구", SubMQTT.client)
        }else {
            print("연결 안됨")
        }
    }
    
    //연결이 끊어졌을때
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("연결 끊어짐, 재연결 시도")
        //연결
        _ = SubMQTT.client.connect()
    }
    
    //안쓰는 나머지
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    
    
    
}
