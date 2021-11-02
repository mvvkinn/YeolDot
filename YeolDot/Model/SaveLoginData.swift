//
//  SaveLoginData.swift
//  YeolDot
//
//  Created by 김민우 on 21/06/2019.
//  Copyright © 2019 김민우. All rights reserved.
//

import Foundation

class SaveLoginData: NSObject, NSCoding {
    var deviceName: String //기기이름
    var userID: String //유저아이디
    var password: String //유저 비밀번호
    
    //생성자로 아이디 비밀번호 기기이름 받아서 저장
    init(deviceName: String, userID: String, password: String) {
        self.deviceName=deviceName
        self.userID=userID
        self.password=password
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        //값을 해당하는 오브젝트에 디코딩
        self.deviceName=aDecoder.decodeObject(forKey:"deviceName") as! String
        self.userID=aDecoder.decodeObject(forKey:"userID") as! String
        self.password=aDecoder.decodeObject(forKey:"password") as! String
        
    }
    
    func encode(with aCoder: NSCoder) {
        //값을 해당하는 오브젝트에 인코딩
        aCoder.encode(self.deviceName, forKey: "deviceName")
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.password, forKey: "password")

    }
    
}
