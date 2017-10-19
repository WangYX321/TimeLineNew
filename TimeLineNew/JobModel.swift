//
//  JobModel.swift
//  TimeLineNew
//
//  Created by wyx on 2017/10/15.
//  Copyright © 2017年 wyx. All rights reserved.
//

import Foundation
import UIKit

class JobModel {
    var name : String
    var endPoint : CGPoint
    var date : Date
    var createTime : Int32//每个对象的唯一值（相当于ID）
    
    init() {
        name = ""
        endPoint = CGPoint()
        date = Date()
        createTime = 0
    }
}
