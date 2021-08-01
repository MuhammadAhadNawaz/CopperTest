//
//  LocalOrderTests.swift
//  CopperTestTests
//
//  Created by Muhammad Ahad on 01/08/2021.
//

import XCTest
@testable import CopperTest

class LocalOrderTests: XCTestCase {
  
    // MARK: - Properties
  var orderHandler: OrdersHandler!
  var coreDataStack: CoreDataStack!

  override func setUp() {
    super.setUp()
    coreDataStack = TestCoreDataStack()
    orderHandler = OrdersHandler(coreDataStack.mainContext,
                                     coreDataStack: coreDataStack)
    
  }

  override func tearDown() {
    super.tearDown()
    orderHandler = nil
    coreDataStack = nil
  }

  func testAddReport() {
    let orderModel = OrderModel(orderId: UUID().uuidString,
                                currency: "BTC",
                                amount: "123.456",
                                orderType: "deposit",
                                orderStatus: "approved",
                                createdAt: "1523456789875")
                         
    let order = orderHandler.add(orderModel)

    XCTAssertNotNil(order, "Order should not be nil")
    XCTAssertTrue(order.currency == "BTC")
    XCTAssertTrue(order.amount == "123.456")
    XCTAssertTrue(order.orderType == "deposit")
    XCTAssertTrue(order.orderStatus == "approved")
    XCTAssertTrue(order.createdAt == "1523456789875")
    
  }

  func testRootContextIsSavedAfterAddingReport() {
    let derivedContext = coreDataStack.newDerivedContext()
    orderHandler = OrdersHandler(derivedContext, coreDataStack: coreDataStack)

    expectation(
      forNotification: .NSManagedObjectContextDidSave,
      object: coreDataStack.mainContext) { _ in
        return true
    }

    derivedContext.perform {
        let orderModel = OrderModel(orderId: UUID().uuidString,
                                    currency: "BTC",
                                    amount: "44.46",
                                    orderType: "withdraw",
                                    orderStatus: "approved",
                                    createdAt: "1623456789875")
                             
        let order = self.orderHandler.add(orderModel)

      XCTAssertNotNil(order)
    }

    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }
}
