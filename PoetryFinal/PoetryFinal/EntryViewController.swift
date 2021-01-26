//
//  EntryViewController.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 11/29/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//

import UIKit

class EntryViewController: UITabBarController {

    var database: Database!
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
