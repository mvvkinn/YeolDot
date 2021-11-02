//
//  ViewController.swift
//  YeolDot
//
//  Created by 김민우 on 24/05/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import UIKit
import CocoaMQTT //MQTT라이브러리

class ViewController: UIViewController {
    
    @IBOutlet weak var temperature: UILabel! //온도 표시
    @IBOutlet weak var location: UILabel! //위치 표시
    @IBOutlet weak var sky: UILabel! //날씨 표시
    @IBOutlet weak var f_dust: UILabel! //미세먼지 표시
    @IBOutlet weak var uf_dust: UILabel! //초미세먼지 표시
    @IBOutlet weak var dust_status: UILabel! //종합 먼지상태 표시
    @IBOutlet weak var lastUpdatedTime: UILabel! //API 마지막 업데이트 시간
    
    @IBOutlet weak var auto_openStat: UISwitch! //자동계폐 상태 표시
    @IBOutlet weak var windowStat: UISwitch! //창문 상태 표시
    
    
    let local_place = "송파구" //GPS를 지원하지 않으므로, 행정구 임의 지정 변수
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavigationBar() //네비게이션 바 투명 함수
        
        msgLabelUpdate() //라벨 업데이트
        self.location.text = local_place //위치 라벨 변경(임의 지정한 행정구)
        
        //자동개폐가 활성 상태일때 수동개폐 비활성화
        if(auto_openStat.isOn == true){
            windowStat.isEnabled = false
        }
        
        //MQTT에서 창문 상태 받아 스위치에 상태 반영
        BringDeviceData.actToMsg(autoSwitch: auto_openStat, manualSwitch: windowStat)
    }
    
    
    func setNavigationBar(){ //네비게이션 바 투명설정 함수
        let bar:UINavigationBar! =  self.navigationController?.navigationBar //네비게이션 바 변수
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear //네비게이션바 투명 적용
    }
    
    
    @IBAction func auto_stat(_ sender: UISwitch) { //창문 자동 스위치 작동 함수
        let state = sender.isOn //자동개폐 상태 스위치
        SubMQTT.client.publish("YeolDot/user/devName/window/auto", withString: "\(state)", qos: .qos2, retained: true) //자동개폐 상태를 토픽 "YeolDot/user/devName/window/auto" 에 전송
        
    }
    
    @IBAction func window_stat(_ sender: UISwitch) { //창문 상태 스위치 작동 함수
        let state = sender.isOn //창문 상태 스위치
        SubMQTT.client.publish("YeolDot/user/devName/window/status", withString: "\(state)", qos: .qos2, retained: true) //창문 상태를 토픽 "YeolDot/user/devName/window/status" 에 전송
    }
    
    func msgLabelUpdate(){
        var dustStat : Int = 0 //미세먼지 수치 전역변수
        var uf_dustStat : Int = 0 //초미세먼지 수치 전역변수
        
        //MQTT 시간 토픽 구독 이벤트(메시지받음) 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_time"), object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            //업데이트 시간 토픽에서 받은 메시지로 라벨 변경
            self?.lastUpdatedTime.text = "날씨 마지막 업데이트 : \(notification.object as? String ?? "")"
        }
        
        //MQTT 미세먼지 토픽 구독 이벤트(메시지받음) 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_fineDust"), object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            //받은 미세먼지 수치 메시지 계산(1,2,3,4) 위해  Int 로 변수 저장
            let dust = Int(notification.object as? String ?? "")!
            //미세먼지 토픽에서 받은 메시지로 라벨 변경
            self?.f_dust.text = "\(notification.object as? String ?? "")㎍/m³"
            
            /* 미세먼지
             좋음 : 0~30 : 1
             보통 : 31~50 : 2
             나쁨 : 51~100 : 3
             매우나쁨 : 101~ : 4
             */
            
            if(dust <= 30){
                dustStat = 1
            }else if(Int(dust) > 30 && Int(dust) <= 50){
                dustStat = 2
            }else if(Int(dust) > 50 && Int(dust) <= 100){
                dustStat = 3
            }else if(Int(dust) > 100){
                dustStat = 4
            }
            
            self!.paramInit(fine: dustStat, ultrafine: uf_dustStat)
        }
        
        //MQTT 초미세먼지 토픽 구독 이벤트(메시지받음) 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_ultrafineDust"), object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            //받은 초미세먼지 수치 메시지 계산(1,2,3,4) 위해  Int 로 변수 저장
            let ultra_dust = Int(notification.object as? String ?? "")!
            //초미세먼지  토픽에서 받은 메시지로 라벨 변경
            self?.uf_dust.text = "\(notification.object as? String ?? "")㎍/m³"
            
            /* 초미세먼지
             좋음 : 0~15 : 1
             보통 : 16~25 : 2
             나쁨 : 26~50 : 3
             매우나쁨 : 51~ : 4
             */
            
            if(Int(ultra_dust) <= 15){
                uf_dustStat = 1
            }else if(Int(ultra_dust) > 15 && Int(ultra_dust) <= 25){
                uf_dustStat = 2
            }else if(Int(ultra_dust) > 25 && Int(ultra_dust) <= 50){
                uf_dustStat = 3
            }else if(Int(ultra_dust) > 50){
                uf_dustStat = 4
            }
            self!.paramInit(fine: dustStat, ultrafine: uf_dustStat)
        }
        
        //MQTT 온도 토픽 구독 이벤트(메시지받음) 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_temperature"), object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            //온도 토픽에서 받은 메시지로 라벨 변경
            self?.temperature.text = notification.object as? String ?? ""
        }
        
        //MQTT 기상 토픽 구독 이벤트(메시지받음) 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_sky"), object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            //기상 토픽에서 받은 메시지로 라벨 변경
            self?.sky.text = notification.object as? String ?? ""
        }
        
    }
    
    //fine: 미세먼지 변수, ultrafine: 초미세먼지 변수
    func paramInit(fine: Int, ultrafine: Int){ //미세먼지 수치와 초미세먼지 수치 중 더 높은 수치 택1
        if(fine == ultrafine){ //미세먼지 수치 == 초미세먼지 수치
            //변수로 미세먼지 수치 씀
            dustSetText(param: fine, label: dust_status)
        }else if(fine > ultrafine){ //미세먼지 수치 > 초미세먼지 수치
            //변수로 미세먼지 수치 씀
            dustSetText(param: fine, label: dust_status)
        }else if(fine < ultrafine){ //미세먼지 수치 < 초미세먼지 수치
            //변수로 초미세먼지 수치 씀
            dustSetText(param: ultrafine, label: dust_status)
        }
    }
    
    func dustSetText(param: Int, label: UILabel){ //param: 미세먼지 수치, //label: 설정할 라벨
        switch param{
        case 1: //1일때
            label.text = "먼지가 별로 없어요!" //먼지 상태 라벨 지정
            label.textColor = UIColor.init(red: 0.38, green: 0.72, blue: 0.85, alpha: 1) //색지정
        case 2: //2일때
            label.text = "보통이에요" //먼지 상태 라벨 지정
            label.textColor = UIColor.init(red: 0.32, green: 0.85, blue: 0.39, alpha: 1) //색지정
        case 3: //3일때
            label.text = "먼지가 많아요!" //먼지 상태 라벨 지정
            label.textColor = UIColor.init(red: 0.85, green: 0.52, blue: 0.36, alpha: 1) //색지정
        case 4: //4일때
            label.text = "먼지가 매우 많아요!" //먼지 상태 라벨 지정
            label.textColor = UIColor.init(red: 0.9, green: 0.24, blue: 0.3, alpha: 1) //색지정
        default:
            label.text = "로딩중" //먼지 상태 라벨 지정
        }
    }
}



