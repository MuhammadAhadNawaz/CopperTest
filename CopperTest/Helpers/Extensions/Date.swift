//
//  Date.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 01/08/2021.
//

import Foundation

extension Date {
    
    static func fromatedDateString(_ timeStamp: Double, toFormat:String? = "dd/MM/yy")-> String {
        
        if let date = Date(timeIntervalSince1970: timeStamp) as Date?{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = toFormat!
            let convertedDateString = dateFormatter.string(from: date)
            return convertedDateString
        }
        return ""
    }
    
    static func fromatedDateString(_ strDate: String, toFormat:String? = "dd/MM/yy")-> String {
        let dateFormatter = DateFormatter()
        if let date = fromatedDate(strDate, toFormat: toFormat) {
            dateFormatter.dateFormat = toFormat!
            let convertedDateString = dateFormatter.string(from: date)
            return convertedDateString
        }
        return ""
    }
    
    static func fromatedDate(_ strDate: String, toFormat:String? = "dd/MM/yy")-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat//
        let date = dateFormatter.date(from: strDate)
        return date
    }

}
