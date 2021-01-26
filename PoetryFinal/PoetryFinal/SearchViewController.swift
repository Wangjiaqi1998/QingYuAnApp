//
//  SearchViewController.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 12/6/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,
UITableViewDataSource,UITableViewDelegate{
    
    var database: Database!
    
    var detailViewController: DetailViewController? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchResult:[poemtry] = []
    
    var flag = 0
    
    let rSection:Int = 1;   //如果列表分组，这里仅1组
    let rs = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
        //输入框无内容时，默认全部显示
        searchResult = database.SearchPoetryByTitle(srch:"")
        
        //设置代理
        self.searchBar.delegate = self
        self.searchBar.placeholder = "搜索标题"
        
        //隐藏键盘
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode(rawValue: 1)!
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //模态为showDetail时执行代码
        if(segue.identifier == "showDetail"){
            if let indexPath = self.tableView.indexPathForSelectedRow{
                //隐藏键盘
                searchBar.resignFirstResponder()
                //将选中行的诗词ID传给DetailViewController
                let controller = segue.destination as! DetailViewController
                controller.detailItem = self.searchResult[indexPath.row].pid
            
            }
        }
    }
    
    //配置表视图数据源
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return rSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == rs){
            return searchResult.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "结果共"+(String)(searchResult.count)+"条"
    }
    //cell显示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as UITableViewCell
        //只显示标题和作者
        cell.textLabel!.text = searchResult[indexPath.row].ptitle;
        cell.detailTextLabel!.text = searchResult[indexPath.row].pauthor
        
        return cell

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            self.searchResult = database.SearchPoetryByTitle(srch: "")
        }else{
            self.searchResult = database.SearchPoetryByTitle(srch: searchText)
        }
        self.tableView.reloadData()
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
