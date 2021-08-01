//
//  OrderModel.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 01/08/2021.
//

import Foundation

public struct OrderModel: Decodable, Equatable {

    var orderId:String
    var currency:String?
    var amount:String?
    var orderType:String?
    var orderStatus:String?
    var createdAt:String?
    
}

internal class OrderResultMapper {
    
    private struct Root: Decodable {
        let orders: [OrderModel]
    }

    private static let OK_200 = 200
    
    internal static func map(data: Data, response: HTTPURLResponse) throws -> [OrderModel] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteOrderLoader.Error.invalidData
            
        }
        return root.orders
    }
}
