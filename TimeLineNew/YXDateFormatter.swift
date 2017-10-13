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
}
