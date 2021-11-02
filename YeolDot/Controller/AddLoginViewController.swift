//
//  AddLoginViewController.swift
//  YeolDot
//
//  Created by 김민우 on 15/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation
import UIKit

class AddLoginViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField! //기기 이름 라벨 변수
    @IBOutlet weak var idTextField: UITextField!  //사용자 이름 라벨 변수
    @IBOutlet weak var pwTextField: UITextField! //비밀번호 라벨 변수
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    var data: [String] = []
    
    @IBAction func saveData(_sender: Any){
        let user = SaveLoginData(deviceName: nameTextField.text!,userID: idTextField.text!, password: pwTextField.text! ) //저장할 생성자 사용하여 상수에 저장
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true) //저장경로 상수
        let docsDir = dirPath[0] as NSString
        let dataFilePath = docsDir.appendingPathComponent("loginData") //저장경로 이름 추가된 상수
        
        NSKeyedArchiver.archiveRootObject(user, toFile: dataFilePath) //파일에 저장
        
        performSegue(withIdentifier: "unwindToBack", sender: self) //뒤로가기 세그 발생
    }
    
    
    
   
}
