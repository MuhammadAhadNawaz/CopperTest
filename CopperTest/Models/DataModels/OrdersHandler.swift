//
//  OrdersHandler.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import Foundation
import CoreData

public final class OrdersHandler {
    // MARK: - Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    // MARK: - Initializers
    public init(_ managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK: - Public
extension OrdersHandler {
    
    func trasnformOrders(_ orderModles: [OrderModel]) {
        Log.info("transforming orders \(Date())")
        coreDataStack.storeContainer.performBackgroundTask { context in
            let batchInsert = self.ordersBatchInsertion(with: orderModles)
            do {
                try context.execute(batchInsert)
                Log.info("Finished batch insertion\(orderModles.count)")
            } catch {
                let nsError = error as NSError
                Log.error("Error batch inserting orders \(nsError.userInfo)")
            }
        }

    }
    
    private func ordersBatchInsertion(with orderModels: [OrderModel]) -> NSBatchInsertRequest {
      var index = 0
      let total = orderModels.count
      let batchInsert = NSBatchInsertRequest(
        entity: Orders.entity()) { (managedObject: NSManagedObject) -> Bool in
        guard index < total else { return true }

        if let order = managedObject as? Orders {
            let orderModel = orderModels[index]
            order.orderId = orderModel.orderId
            order.currency = orderModel.currency
            order.amount = orderModel.amount
            order.orderStatus = orderModel.orderStatus
            order.orderType = orderModel.orderType
            order.createdAt = orderModel.createdAt
        }

        index += 1
        return false
      }
      return batchInsert
    }

}

extension OrdersHandler {
    
    //MARK:- Test Additions
    func add(_ orderModel: OrderModel) ->Orders{
        let order = Orders(context: managedObjectContext)
        order.orderId = orderModel.orderId
        order.currency = orderModel.currency
        order.amount = orderModel.amount
        order.orderStatus = orderModel.orderStatus
        order.orderType = orderModel.orderType
        order.createdAt = orderModel.createdAt
        
        coreDataStack.saveContext(managedObjectContext)
        return order
    }
}
