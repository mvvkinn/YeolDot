//
//  SettingViewController.swift
//  YeolDot
//
//  Created by 김민우 on 17/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController{
    @IBOutlet weak var fineDust_details: UILabel! //미세먼지 파라미터값 세부 라벨
    @IBOutlet weak var ultrafineDust_details: UILabel! //초미세먼지 파라미터값 세부 라벨
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BringDeviceData.subToDevice(dev_name: "dev1") //장치 데이터 가져오기
        BringDeviceData.actToMsg(fine_label: fineDust_details, uf_label: ultrafineDust_details) //메시지를 받았을때, 세부 라벨, 스위치 상태 변경
        
    }

}
