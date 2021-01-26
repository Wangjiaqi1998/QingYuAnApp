//
//  DetailViewController.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 12/25/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var database: Database!
    
    @IBOutlet weak var detailTitle: UITextView!
    
    @IBOutlet weak var detailAuthor: UITextView!
    
    @IBOutlet weak var detailContent: UITextView!
    
    
    var detailPoetry = poemtry(i: 0, t: "", a: "", p:[""])
    var detailItem: Int64? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    func configureView() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        //按ID查询并显示在界面上
        detailPoetry = database.SearchPoetryById(num: (self.detailItem)!)

        detailTitle.text = detailPoetry.ptitle
        detailAuthor.text = detailPoetry.pauthor
        var kk = String()
        
        for a in detailPoetry.pparagraph {
            kk += (a.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        detailContent.text = kk
        self.configureView()
        
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
