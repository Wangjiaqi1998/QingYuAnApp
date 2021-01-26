//
//  database.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 11/23/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//

import Foundation
import SQLite
struct poemtry {
    var pid:Int64           //诗词id
    var ptitle:String       //诗词标题
    var pauthor:String      //诗词作者
    var pparagraph:[String] //诗词内容
    
    init(i:Int64,t:String,a:String,p:[String]) {
        self.pid = i
        self.ptitle = t
        self.pauthor = a
        self.pparagraph = [""]
    }
}
struct Database {

    var db: Connection!

    init() {
        connectDatabase()
    }
    
    let Shi_table = Table("shi_tangsong")
    let Shi_id = Expression<Int64>("id")
    let Shi_author = Expression<String>("author")
    let Shi_title = Expression<String>("title")
    let Shi_paragraphs = Expression<String>("paragraphs")
    
    // 与数据库建立连接
    mutating func connectDatabase(filePath: String = "/Documents") -> Void {

        let sqlFilePath = NSHomeDirectory() + filePath + "/tssc.db"

        do { // 与数据库建立连接
            db = try Connection(sqlFilePath)
            
            print("与数据库建立连接 成功")
        } catch {
            print("与数据库建立连接 失败：\(error)")
        }
    }
    func queryTable()->Void{
        for item in (try! db.prepare(Shi_table)){
            print("遍历 --- id: \(item[Shi_id])")
        }
    }
    func SearchPoetryById(num:Int64)->poemtry{
        var res = poemtry(i: 0, t: "", a: "", p:[""]);
        for item in try! db.prepare(Shi_table.filter(Shi_id == num)){   //执行SQL查询语句
            res.pid = (item[Shi_id])                //将数据库中的诗词信息变为poemtry
            res.ptitle = (item[Shi_title])
            res.pauthor = (item[Shi_author])
            
            let str = (item[Shi_paragraphs])
            //数据库中诗词含有多余的'['']'符号,利用replacingOccurrences()将多余的字符删去,并在每一句加逗号
            let newString = str.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\'", with: "")
            let arr = newString.components(separatedBy: ",")
            
            res.pparagraph = arr
        }
        return res
    }
    func SearchPoetryByTitle(srch:String)->[poemtry]{
        var res : [poemtry] = []
        var ans = poemtry(i: 0, t: "", a: "", p:[""]);
            for item in try!
                db.prepare(Shi_table.filter(Shi_title.like("%"+srch+"%"))){
                ans.ptitle = (item[Shi_title])
                ans.pauthor = (item[Shi_author])
                ans.pid = (item[Shi_id])
                ans.pparagraph = [""]
                    
                res.append(ans)
            }
            return res
    }

}
