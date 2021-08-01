//
//  Constants.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit

struct Constants {
    
    //MARK:- Constants
    struct StringDef {
        static let unknown = "Unknown"
        static let pleaseWait = "Please wait..."
        static let somethingWentWrong = "Something went wrong."
    }
    
    //MARK:- APIs constants
    struct API {
        static let baseURL = "https://assessments.stage.copper.co"
        static let getOrders = "\(baseURL)/ios/orders"
    }
    
}

//MARK:- Order type
enum OrderType: String {
    case deposit
    case withdraw
    case buy
    case sell
}

//MARK:- Order status
enum OrderStatus: String {
    case executed
    case canceled
    case approved
    case processing
}

