//
//  LoadingViewController.swift
//  YeolDot
//
//  Created by 김민우 on 11/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController{
    let mqtt_class = SubMQTT() //MQTT연결 클래스 인스턴스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mqtt_class.connectionSetting() //연결 설정
        mqtt_class.connect() //연결
        
        //MQTT 시간 토픽 구독 이벤트(메시지받음) 발생 확인
        NotificationCenter.default.addObserver(forName: NSNotification.Name("post_time"), object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            //메인화면으로 세그 발생
            self!.performSegue(withIdentifier: "loadingSegue", sender: nil)
        }
    }
}
