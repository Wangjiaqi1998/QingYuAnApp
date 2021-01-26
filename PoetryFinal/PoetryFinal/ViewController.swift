//
//  ViewController.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 11/23/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var poetryTitle: UITextView!
    @IBOutlet weak var poetryAuthor: UITextView!
    @IBOutlet weak var poetryText: UITextView!
    
    var PoemId :Int64 = 0
    //收藏
    @IBAction func favoritePoem(_ sender: UIButton) {
        self.saveName(num: PoemId)  //将该诗的ID保存进PoemEntity
        //提示框
        let alert = UIAlertController(title: "收藏成功!", message: "收藏成功", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel) { (action: UIAlertAction) in
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    //换一首
    @IBAction func changePoem(_ sender: Any) {
        self.viewDidLoad()
    }
    //分享(功能未实现)
    @IBAction func sharePoem(_ sender: Any) {
        
    }

    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        
        var DailyNum = arc4random_uniform(300000) + 1;
        dailyDisplay(num: Int64(DailyNum))
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //随机显示一首诗的函数，参数为一个随机数
    func dailyDisplay(num:Int64){
        var getPoetry = poemtry(i: 0, t: "", a: "", p: [""]);
        
        //将随机数当作id去数据库中查找，并返回一个poemtry
        getPoetry = database.SearchPoetryById(num: Int64(num))
        
        //诗的信息显示在ViewController中
        poetryTitle.text = getPoetry.ptitle
        poetryAuthor.text = getPoetry.pauthor
        PoemId = getPoetry.pid

        var content = String()
        
        for a in getPoetry.pparagraph {
            content += (a.trimmingCharacters(in: .whitespacesAndNewlines))
            content += "\n"
        }
        
        poetryText.text = content
    }
    private func saveName(num: Int64) {
        //        步骤一：获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("delegate")
        let managedObectContext = appDelegate.persistentContainer.viewContext
        print("context")
        //        步骤二：建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: "PoemEntity", in: managedObectContext)
        print("entity")
        let poemObject = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        print("manage")
        //        步骤三：保存文本框中的值到person
        poemObject.setValue(num, forKey: "id")
        
        //        步骤四：保存entity到托管对象中。如果保存失败，进行处理
        do {
            try managedObectContext.save()
            print("保存成功！")
        } catch  {
            fatalError("无法保存")
        }
    }

}

