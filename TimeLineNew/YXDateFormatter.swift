//
//  YXDateFormatter.swift
//  TodoList
//
//  Created by wyx on 2017/9/23.
//  Copyright © 2017年 wyx. All rights reserved.
//

import Foundation

extension Date {
    func getString() -> String {
        let dateFormatter = DateFormatter()
//        if let format = formatter {
//            dateFormatter.dateFormat = format
//        } else {
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func getStringFrom(formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
//    func getTimeStamp(fromString str: String) -> Int32 {
    func getTimeStamp() -> Int32 {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let timeStamp = 0
//        if let date = dateFormatter.date(from: str) {
//           timeStamp  = Int(date.timeIntervalSince1970)
//        }
        let timeStamp  = Int32(self.timeIntervalSince1970)
        return timeStamp
    }
    
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
