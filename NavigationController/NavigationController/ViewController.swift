//
//  ViewController.swift
//  NavigationController
//
//  Created by Vitor Gomes on 09/05/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    
    @IBAction func next(_ sender: UIButton) {
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
}

