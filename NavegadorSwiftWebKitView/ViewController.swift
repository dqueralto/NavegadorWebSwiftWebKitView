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
            let myRequest = URLRequest(url: url)
            webKitView.load(myRequest)
        }
        else
        {
            print("ERROR")
        }
    }
    
    func didStartLoad(_ webKitView: WKWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
    }


}

