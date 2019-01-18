//
//  ViewController.swift
//  NavegadorSwiftWebKitView
//
//  Created by Daniel Queraltó Parra on 16/01/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import WebKit
import SQLite3


class ViewController: UIViewController, WKUIDelegate, UISearchBarDelegate {
    var db: OpaquePointer?
    var historial = [Histo]()
    
    @IBOutlet weak var barraDeBusqueda: UISearchBar!
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var retroceder: UIBarButtonItem!
    @IBOutlet weak var avanzar: UIBarButtonItem!
    //---------------------------------------------------------------------------------------------------------------
    //INICIO
    //---------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webKitView.load(URLRequest(url: URL(string: "http://www.google.com")!))
        print(barraDeBusqueda.text!)
        
        //barraDeBusqueda.delegate = self
        //webKitView.navigationDelegate = self
        
        //retroceder.isEnabled = false
        //avanzar.isEnabled = false
        activarBotones()
        
        let str = barraDeBusqueda.text!
        let index: String.Index = str.index(str.startIndex, offsetBy: 8)
        let newStr = String(str[..<index])
        print(newStr)
        crearBD()
    }
    //---------------------------------------------------------------------------------------------------------------
    //BUSCADOR
    //---------------------------------------------------------------------------------------------------------------
    @IBAction func atras(_ sender: Any)
    {
        if webKitView.canGoBack
        {
            webKitView.goBack()
        }
    }
    
    @IBAction func recargar(_ sender: Any)
    {
        webKitView.reload()
    }
    
    @IBAction func siguiente(_ sender: Any)
    {
        if webKitView.canGoForward
        {
            webKitView.goForward()
        }
    }
  
    
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let str = barraDeBusqueda.text!
        let index: String.Index = str.index(str.startIndex, offsetBy: 8)
        let newStr = String(str[..<index])
        
        if newStr == String(!barraDeBusqueda.text!.contains("https://"))
        {
            barraDeBusqueda.text="https://"+barraDeBusqueda.text!

        }
        activarBotones()
        insertar()
        webKitView.load(URLRequest(url: URL(string: barraDeBusqueda.text!)!))
        
        
    }
    //---------------------------------------------------------------------------------------------------------------
    //FUNCIONALIDADES
    //---------------------------------------------------------------------------------------------------------------
    
    func activarBotones()
    {
        if webKitView.canGoForward
        {
            avanzar.isEnabled = true
        }
        else
        {
            avanzar.isEnabled = false
        }
        if webKitView.canGoBack
        {
            retroceder.isEnabled = true
        }
        else
        {
            retroceder.isEnabled = false
        }
    }
    
    
    @IBAction func eliminar(_ sender: Any)
    {
        print(leerValores())
        eliminarHistorial()
        print(leerValores())
    }
    //---------------------------------------------------------------------------------------------------------------
    //GESTION DE BASE DE DATOS
    //---------------------------------------------------------------------------------------------------------------
    func crearBD()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        insertar()
        leerValores()
        for hi in historial {
            print(hi.url!)
        }
    }
        
    func insertar()  {
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Historial (url) VALUES ("+"'"+String(barraDeBusqueda.text!)+"')"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fallo al insertar en historial: \(errmsg)")
            return
        }
        //  readValues()
        
        //displaying a success message
        print("Herro saved successfully")
        print(leerValores())
    }
    
    func leerValores(){
        
        //first empty the list of heroes
        //historial.removeAll()
        
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
        
        historial.removeAll()
    }
    
        
}
//---------------------------------------------------------------------------------------------------------------
//BASE DE DATOS
//---------------------------------------------------------------------------------------------------------------

class Histo{
    
    var id: Int
    var url: String?

    init (id: Int, url: String?)
    {
        self.id = id
        self.url = url
    }
    
}
