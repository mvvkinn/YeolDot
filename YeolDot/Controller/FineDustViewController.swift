//
//  FineDustSettingViewController.swift
//  YeolDot
//
//  Created by 김민우 on 14/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import UIKit

class FineDustViewController: UITableViewController{
    //선택 테이블 셀 열 저장 변수
    fileprivate var selectedIndexPath: IndexPath?
    
    //셀에 출력할 문자열 변수
    var settingTitles : [String] = ["기본"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addValue()
    }
    
    //뷰에 표시할 목록 표시
    func addValue(){
        for i in 30...150{
            if(i % 10 == 0){
                //30~150, 10씩 배열에 추가
                settingTitles.append(String(i))
            }
        }
    }
    
    //배열 수 테이블 수로 리턴
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitles.count
    }
    
    //테이블 뷰에 배열 값 추가
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //재사용 테이블 셀
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if(settingTitles[indexPath.row] != "기본"){ //배열 값이 "기본" 이 아닐때 뒤에 ㎍/m³ 단위 추가
            cell.textLabel?.text = "\(settingTitles[indexPath.row])㎍/m³"
        }else {
            cell.textLabel?.text = settingTitles[indexPath.row]
        }
        
        cell.accessoryType = self.selectedIndexPath == indexPath ? .checkmark : .none //checkmark이면 none으로
        
        //문자열 리턴
        return cell
    }
    
    //셀을 선택했을때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        //현재 선택된 라벨 경로 저장
        self.selectedIndexPath = indexPath
        
        //MQTT 서버에 선택된 파라미터 전송
        SubMQTT.client.publish("YeolDot/user/dev1/window/PM10Param", withString: settingTitles[indexPath.row], qos: .qos2, retained: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.reloadData()
    }
}
