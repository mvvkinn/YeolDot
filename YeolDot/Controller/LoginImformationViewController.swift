//
//  LoginImformationViewController.swift
//  YeolDot
//
//  Created by 김민우 on 15/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import UIKit

class LoginImformationViewController: UITableViewController {
    //로그인 정보 테이블 뷰 출력용 저장 배열 변수
    var imfor:[[String:String]] = []
    
    //로그인 정보 테이블뷰
    @IBOutlet weak var LoginImformationView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginImformationView.delegate = self
        LoginImformationView.dataSource = self
        
        loadData() //값 로드
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //재사용셀
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //imfor배열에서 해당하는 키의 값 불러오기
        cell.textLabel?.text = imfor[indexPath.row]["name"]
        cell.detailTextLabel?.text = imfor[indexPath.row]["id"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imfor.count
    }
    
    //값 로드 함수
    func loadData() {
        //파일 매니저
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPath[0] as NSString
        let dataFilePath = docsDir.appendingPathComponent("loginData")
        
        if fileMgr.fileExists(atPath: dataFilePath) { //파일이 있을때
            let user = NSKeyedUnarchiver.unarchiveObject(withFile: dataFilePath) as! SaveLoginData //유저데이터 저장 상수
            
            var newImfor = [String:String]() //저장한 변수 테이블 뷰 값 변수에 저장 위한 임시 변수
            newImfor["name"] = user.deviceName //기기이름 저장
            newImfor["id"] = user.userID //아이디 저장
            imfor.append(newImfor) //출력 배열에 추가
            
            tableView.reloadData()
        }
    }
    
    //뒤로가기 세그 발생 함수
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //뒤로가기 세그가 발생했을때 값 로드
        if segue.identifier == "unwindToBack"{
            loadData()
        }
    }
}
