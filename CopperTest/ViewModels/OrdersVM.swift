//
//  OrdersVM.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit

class OrdersVM: NSObject {
    
    lazy var coreDataStack = CoreDataStack()
    private lazy var orderHandler = OrdersHandler(coreDataStack.mainContext,
                                     coreDataStack: coreDataStack)
    let service:OrderLoader?
    
    var sectionIndexes = [String]()
//    var orders = [OrderModel]()
    var success: ()->() = {}
    var showAlert : (_ title: String, _ message: String) -> () = {_,_ in}
    
    init(service: OrderLoader) {
        
        self.service = service
    }
    
    //MARK:-
    func onViewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.fetch()
        }
    }
    
    func fetch() {

        service?.load(completion: { [weak self] (result) in
            switch result {
            
            case .success(let orders):
                
                Log.info("Fetched orders \(orders.count) ")
                self?.syncOrders(orders)
                DispatchQueue.main.async {
                    self?.success()
                }
            case .failure(_):
                self?.showAlert("", Constants.StringDef.somethingWentWrong)
            }
        })
    }
    
    func syncOrders(_ orderModels: [OrderModel]) {
        
        orderHandler.trasnformOrders(orderModels)
    }
    
}
