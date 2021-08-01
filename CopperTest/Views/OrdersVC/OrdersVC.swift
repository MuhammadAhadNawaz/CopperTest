//
//  OrdersVC.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit
import CoreData

class OrdersVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    let httpClient = URLSessionHTTPClient()
    var serviceLoader:RemoteOrderLoader!
    var ordersVM: OrdersVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVM()
        setupUI()
    }
    
    //MARK:- Setup view model
    func setupVM() {
        self.serviceLoader = RemoteOrderLoader(url: URL(string: Constants.API.getOrders)!,
                                                 client: httpClient)
        self.ordersVM = OrdersVM(service: serviceLoader)
        
        self.showProgressHUD()
        ordersVM.onViewDidLoad()
        
        ordersVM.showAlert = { [weak self] title, message in
            guard let self = self else {return}
            self.showAlert(title, message: message)
        }
        
        ordersVM.success = { [weak self] in
            self?.hideProgressHUD()
            guard let self = self else {return}

            self.fetchOrdersFromDB()
        }
    }
    //MARK:- Setup UI
    func setupUI() {
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func fetchOrdersFromDB() {
        Log.info("loading orders from local storage")
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            Log.info("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Orders> = {
        
        let moc = ordersVM.coreDataStack.mainContext
        let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "orderId", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController<Orders>(fetchRequest: fetchRequest,
                                                                          managedObjectContext: moc,
                                                                          sectionNameKeyPath: nil,
                                                                          cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
}

extension OrdersVC: NSFetchedResultsControllerDelegate {
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.reloadData()
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.tableView.reloadData()
    }
}

