//
//  ViewController.swift
//  NavegadorSwiftWebKitView
//
//  Created by Daniel Queraltó Parra on 16/01/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!

    
    @IBOutlet weak var barraDeBusqueda: UISearchBar!
    @IBOutlet weak var webKitView: WKWebView!
    
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
    
    /*override func loadView()//Navegador a pantalla completa
     {
        let webConfiguration = WKWebViewConfiguration()
        webKitView = WKWebView(frame: .zero, configuration: webConfiguration)
        webKitView.uiDelegate = self
        view = webKitView
    }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        barraDeBusqueda.resignFirstResponder()
        
        if let url = URL(string: barraDeBusqueda.text!)
        {
            
            //let myURL = URL(string: barraDeBusqueda.text!)
            //let myRequest = URLRequest(url: myURL!)
            //webKitView.load(myRequest)
            
            let myRequest = URLRequest(url: url)
            webKitView.load(myRequest)
        }
        else
        {
            print("ERROR")
        }
    }
    
/*
    func deshabilitaritems(objeto: Int, estado: Bool )
    {
        var items = (navigationController?.toolbar.items)!
        for item: UIBarButtonItem in items {
            if item.tag == objeto {
                item.isEnabled = estado
            }
        }
    }
*/
    func didStartLoad(_ webKitView: WKWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if webKitView.canGoBack {
            //deshabilitaritems(objeto:1, estado: true)
        }
        else
        {
           //deshabilitaritems(objeto:1, estado: false)
        }
        
        if webKitView.canGoForward
        {
            //deshabilitaritems(objeto:3, estado: true)
        }
        else
        {
            //deshabilitaritems(objeto:3, estado: false)
        }
    }

    func didFinishNavigation(_ webKitView: WKWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    

    /*
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myURL = URL(string:"https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        webKitView.load(myRequest)
        //deshabilitaritems(objeto:1, estado: false)
    }


}

