//
//  SecondViewController.swift
//  NavigationController
//
//  Created by Vitor Gomes on 09/05/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func back(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        //dismiss e usado para sair, fechar uma tela que estava usando Segue, nao navigation controller
        
        
        //Jeito certo de trabalhar com navigation controller quando voce quer que ela saia da tela atual e volte para a anterior
        navigationController?.popViewController(animated: true)
    }

}
