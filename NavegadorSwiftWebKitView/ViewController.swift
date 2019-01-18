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


class ViewController: UIViewController, WKUIDelegate, UISearchBarDelegate, WKNavigationDelegate {
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
        barraDeBusqueda.delegate = self
        webKitView.navigationDelegate = self
        webKitView.load(URLRequest(url: URL(string: "http://www.google.com")!))
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
        let barraBusqueda = barraDeBusqueda.text!
        
        let com: String = ".com"
        let es: String = ".es"
        let net: String = ".net"
        let http: String = "https://"
        let www: String = "www."
        let google: String = "https://www.google.com/search?q="
        
        var barraBusquedafinal = barraBusqueda.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)

        barraDeBusqueda.resignFirstResponder()
        barraBusquedafinal = barraBusquedafinal.lowercased()
        
        print("0")

        if !barraBusquedafinal.contains(com) && !barraBusquedafinal.contains(es) && !barraBusquedafinal.contains(net)
        {
            barraBusquedafinal = google + barraBusquedafinal
            print(barraBusquedafinal)
            print("4")
            
            if let url = URL(string: barraBusquedafinal)
            {
                print("siiiiiiiiii")
                
                let myRequest = URLRequest(url: url)
                webKitView.load(myRequest)
                
                
            }
            
        }
        else
        {
            print("1")
            if !barraBusquedafinal.contains(www)
            {
                barraBusquedafinal = www + barraBusquedafinal
                print(barraBusquedafinal)
                print("2")
            }
            if !barraBusquedafinal.contains(http)
            {
                barraBusquedafinal = http + barraBusquedafinal
                print(barraBusquedafinal)
                print("3")
                
            }
            
            if let url = URL(string: barraBusquedafinal)
            {
                print("siiiiiiiiii")
                
                let myRequest = URLRequest(url: url)
                webKitView.load(myRequest)
            }

            
            
        }

    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        barraDeBusqueda.text = webKitView.url?.absoluteString
        insertar()
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
        //insertar()
        //leerValores()
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
        
        
        //displaying a success message
        print("Histo saved successfully")
        //print(leerValores())
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
