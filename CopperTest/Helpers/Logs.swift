//
//  Logs.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 01/08/2021.
//

import UIKit
import os.log

class Log {

    class func info(_ message: String) {
        os_log(.info, log: .default, "\(message)")
    }
    
    class func error(_ message: String) {
        os_log(.error, log: .default, "\(message)")
    }
}
