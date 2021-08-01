//
//  LandingVC.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit

class LandingVC: BaseVC {

    @IBOutlet weak var btnDownload: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func downloadAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: OrdersVC.self)) as? OrdersVC {
            self.navigationController?.pushViewController(vc, animated: true)
//            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
}
