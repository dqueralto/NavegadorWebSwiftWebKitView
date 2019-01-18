//
//  ViewController.swift
//  NavegadorSwiftWebKitView
//
//  Created by Daniel Queraltó Parra on 16/01/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKUIDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var barraDeBusqueda: UISearchBar!
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var retroceder: UIBarButtonItem!
    @IBOutlet weak var avanzar: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webKitView.load(URLRequest(url: URL(string: "http://www.google.com")!))
        print(barraDeBusqueda.text!)
        
        //barraDeBusqueda.delegate = self
        //webKitView.navigationDelegate = self
        
        retroceder.isEnabled = false
        avanzar.isEnabled = false
        
        let str = barraDeBusqueda.text!
        let index: String.Index = str.index(str.startIndex, offsetBy: 8)
        let newStr = String(str[..<index])
        print(newStr)
    }
    
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

    //---------------------------------------------------------------------------------------------------------------
    @IBAction func eliminarHistorial(_ sender: Any) {
        
    }
    
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
            //barraDeBusqueda.resignFirstResponder()

        let str = barraDeBusqueda.text!
        let index: String.Index = str.index(str.startIndex, offsetBy: 8)
        //var result = str.substring(to: index)
        let newStr = String(str[..<index])
        if newStr == String(!barraDeBusqueda.text!.contains("https://"))
        {
            barraDeBusqueda.text="https://"+barraDeBusqueda.text!

        }
        webKitView.load(URLRequest(url: URL(string: barraDeBusqueda.text!)!))

        //let url = URL(string: barraDeBusqueda.text!)
        //let request = URLRequest(url: url!)
        //webKitView.load(request)
        //webKitView.load(URLRequest(url: URL(string: barraDeBusqueda.text!)!))
    }

}
    

