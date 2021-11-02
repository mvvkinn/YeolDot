//
//  BringDeviceData.swift
//  YeolDot
//
//  Created by 김민우 on 14/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import CocoaMQTT

class BringDeviceData{
    //기기상태 구독 함수 (county = 행정구)
    static func subToDevice(dev_name: String){ //서버 유저등록 아직 불가능.
        //창문 자동개폐 on/off 상태 구독
        SubMQTT.client.subscribe("YeolDot/user/"+dev_name+"/window/auto", qos: CocoaMQTTQOS.qos2)
        SubMQTT.client.subscribe("YeolDot/user/"+dev_name+"/window/status", qos: CocoaMQTTQOS.qos2)
        
        
        //자동개폐 parameter 구독
        SubMQTT.client.subscribe("YeolDot/user/dev1/window/PM10Param", qos: CocoaMQTTQOS.qos2) //미세먼지 파라미터
        SubMQTT.client.subscribe("YeolDot/user/dev1/window/PM25Param", qos: CocoaMQTTQOS.qos2) //초미세먼지 파라미터
    }
    
    //메시지 받았을때 알림 함수, SubMQTT의 message부에 삽입됨
    static func bringMsg(_ mqtt: CocoaMQTT, message: CocoaMQTTMessage){
        if let msg = message.string {
            if(message.topic == "YeolDot/user/dev1/window/auto"){ //받은 메시지가 "YeolDot/user/dev1/window/auto" 토픽일때
                //MQTT 창문 자동상태 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_auto"), object: msg)
            }
        }
        
        if let msg = message.string {
            if(message.topic == "YeolDot/user/dev1/window/status"){ //받은 메시지가 "YeolDot/user/dev1/window/status" 토픽일때
                //MQTT 창문 상태 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_windowStatus"), object: msg)
            }
        }
        
        if let msg = message.string {
            if(message.topic == "YeolDot/user/dev1/window/PM10Param"){ //받은 메시지가 "YeolDot/user/dev1/window/PM10Param" 토픽일때
                //MQTT 미세먼지 파라미터 토픽 구독 이벤트(메시지받음) 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_PM10Param"), object: msg)
            }
        }
        
        if let msg = message.string {
            if(message.topic == "YeolDot/user/dev1/window/PM25Param"){ //받은 메시지가 "YeolDot/user/dev1/window/PM25Param" 토픽일때
                //MQTT 시간 토픽 구독 이벤트 발생 알림
                NotificationCenter.default.post(name: NSNotification.Name.init("post_PM25Param"), object: msg)
            }
        }
    }
    
    //메시지 받고, 동작하는 함수. 라벨을 받은 메시지로 변경. (라벨 있는 경우 사용)
    static func actToMsg(autoSwitch: UISwitch, manualSwitch: UISwitch){
        //MQTT 창문 자동 토픽 메시지 받음 이벤트 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_auto"), object: nil, queue: OperationQueue.main) {(notification) in
            if(notification.object as? String ?? "" == "true"){ //받은 메시지에 따라 스위치 상태 변경
                autoSwitch.isOn = true
            }else if(notification.object as? String ?? "" == "false"){
                autoSwitch.isOn = true
            }
        }
        
        //MQTT 창문 상태 토픽 메시지 받음 이벤트 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_windowStatus"), object: nil, queue: OperationQueue.main) {(notification) in
            if(notification.object as? String ?? "" == "true"){ //받은 메시지에 따라 스위치 상태 변경
                autoSwitch.isOn = true
            }else if(notification.object as? String ?? "" == "false"){
                autoSwitch.isOn = true
            }
        }
    }
    
    //메시지 받고, 동작하는 함수. 라벨을 받은 메시지로 변경.
    static func actToMsg(fine_label: UILabel, uf_label: UILabel){
        //MQTT 초미세먼지 토픽 메시지 받음 이벤트 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_PM10Param"), object: nil, queue: OperationQueue.main) {(notification) in
            //미세먼지 파라미터 토픽에서 받은 메시지로 라벨 변경
            if(notification.object as? String ?? "" == "기본"){ //받은 메시지가 "기본" 이면 단위 붙이지 않음.
                fine_label.text = "\(notification.object as? String ?? "")"
            }else {
                fine_label.text = "\(notification.object as? String ?? "")㎍/m³"
            }
        }
        
        //MQTT 초미세먼지 토픽 메시지 받음 이벤트 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_PM25Param"), object: nil, queue: OperationQueue.main) {(notification) in
            //초미세먼지 파라미터 토픽에서 받은 메시지로 라벨 변경
            if(notification.object as? String ?? "" == "기본"){ //받은 메시지가 "기본" 이면 단위 붙이지 않음.
                uf_label.text = "\(notification.object as? String ?? "")"
            }else {
                uf_label.text = "\(notification.object as? String ?? "")㎍/m³"
            }
        }
    }
}
