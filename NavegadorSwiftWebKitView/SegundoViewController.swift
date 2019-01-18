//
//  SegundoViewController.swift
//  NavegadorSwiftWebKitView
//
//  Created by Daniel Queraltó Parra on 16/01/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class SegundoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db: OpaquePointer?
    var historial = [Histo]()

    @IBOutlet weak var histoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conectarDB()

        // Do any additional setup after loading the view.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (historial.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celda = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celdilla")
        for hi in historial{
            celda.textLabel?.text = hi.url
        }
        return (celda)
    }

    
    @IBAction func salir(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eliminar(_ sender: Any) {
        eliminarHistorial()
    }
    
    func conectarDB()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Historial.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Historial (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValores()
    }
    
    
    func leerValores(){
        
        //first empty the list of histo
        historial.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM Historial"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let url = String(cString: sqlite3_column_text(stmt, 1))
            
            
            //adding values to list
            historial.append(Histo(id: Int(id), url: String(describing: url)))

        }
        
    }
 
    func eliminarHistorial()
    {

        let queryString = "DELETE FROM Historial"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare(db, queryString, -1, &deleteStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_prepare_v2(db, queryString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
        
        histoTableView.reloadData()
        print(leerValores())
        

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
