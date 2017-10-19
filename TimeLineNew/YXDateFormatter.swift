//
//  YXDateFormatter.swift
//  TodoList
//
//  Created by wyx on 2017/9/23.
//  Copyright © 2017年 wyx. All rights reserved.
//

import Foundation

extension Date {
    //获取格式为"yyyy-MM-dd"的日期字符串
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    //根据传入的日期格式获取日期字符串
    func getStringFrom(formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    //获取时间戳
    func getTimeStamp() -> Int32 {
        let timeStamp  = Int32(self.timeIntervalSince1970)
        return timeStamp
    }
    
    //根据日期字符串获取对应日期
    static func getDateFrom(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            return Date()
        }        
    }
}
