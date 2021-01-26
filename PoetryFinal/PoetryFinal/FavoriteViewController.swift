//
//  FavoriteViewController.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 12/27/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//

import UIKit
import CoreData
class FavoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var detailViewController: DetailViewController? = nil
    //var secondDetailViewController:SecondDetailViewController? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var database: Database!
    var favoriteResult:[poemtry] = []
    var poemSearchId:Int64 = 0
    
    var favorPoem = [NSManagedObject]()
    
    let authorSection:Int = 1;
    let firstAuthor = 0
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("willappear")
        database = Database()
        favoriteResult = []
        loadFavortiePoem()
        self.tableView.reloadData()
    }

    func loadFavortiePoem(){
        //        步骤一：获取总代理和托管对象总管，上下文
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObectContext = appDelegate.persistentContainer.viewContext
        //        步骤二：建立一个获取的请求
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PoemEntity")
        //        步骤三：执行请求
                do {
                    let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
                    if let results = fetchedResults {
                        favorPoem = results
                    }
                } catch  {
                    fatalError("获取失败")
                }
        //favorPoem是一个NSObject类型的数组
        for single in favorPoem{
            //取出单个NSObject中的id属性
            let tmpId = single.value(forKey: "id")
           
            var tmpPoem = poemtry(i: 0, t: "", a: "", p: [""]);
            //用这个id查找对应的诗词并存储在结果数组中
            tmpPoem = database.SearchPoetryById(num: tmpId as! Int64)
            favoriteResult.append(tmpPoem)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "reDetail"){
            if let indexPath = self.tableView.indexPathForSelectedRow{

                let controller = segue.destination as! DetailViewController
                
                controller.detailItem = self.favoriteResult[indexPath.row].pid
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return authorSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == firstAuthor){
            return favoriteResult.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "favorCell", for: indexPath) as UITableViewCell
                //print("table view dodo")
                cell.textLabel!.text = favoriteResult[indexPath.row].ptitle;
                cell.detailTextLabel!.text = favoriteResult[indexPath.row].pauthor
        
                return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //如果用户左滑delete
        if editingStyle == UITableViewCell.EditingStyle.delete{
            removeFavorite(removeId: favoriteResult[indexPath.row].pid)
            
            favoriteResult = [] //清空结果数组
            loadFavortiePoem()  //重新加载收藏的结果数组
            self.tableView.reloadData()
        }
        
    }
    func removeFavorite(removeId:Int64){//参数是favorResult[IndexPath.row]的pid属性
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //获取上下文
        let managedObectContext = appDelegate.persistentContainer.viewContext
        //建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PoemEntity")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //设置查询条件
        let predicate = NSPredicate(format: "id=\(removeId)")
        fetchRequest.predicate = predicate
        //查询操作
        do {
            let fetchedObjects = try managedObectContext.fetch(fetchRequest)
            
            //遍历查询的结果
            for info in fetchedObjects{
                //删除对象
                managedObectContext.delete(info as! NSManagedObject)
            }
            //重新保存-更新到数据库
            try! managedObectContext.save()
            print("删除成功！")
        }
        catch {
            fatalError("查询失败：\(error)")
        }
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
