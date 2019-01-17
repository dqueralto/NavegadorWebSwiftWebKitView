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
    //var webView: WKWebView!

    
    @IBOutlet weak var barraDeBusqueda: UISearchBar!
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var retroceder: UIBarButtonItem!
    @IBOutlet weak var avanzar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myURL = URL(string:"https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        webKitView.load(myRequest)
        print(barraDeBusqueda.text!)
        
        //barraDeBusqueda.delegate = self
        //webKitView.navigationDelegate = self
        
        retroceder.isEnabled = false
        avanzar.isEnabled = false
        
        //deshabilitaritems(objeto:1, estado: false)
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

    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        let urlString:String = "https://www.google.com"
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webKitView.load(urlRequest)
        
        barraDeBusqueda.text = urlString
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(_ searchBar: UISearchBar) -> Bool {
        let urlString:String = barraDeBusqueda.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webKitView.load(urlRequest)
        
        searchBar.resignFirstResponder()
        
        return true

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        retroceder.isEnabled = webView.canGoBack
        avanzar.isEnabled = webView.canGoForward
        
        barraDeBusqueda.text = webView.url?.absoluteString
    }*/

    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            //barraDeBusqueda.resignFirstResponder()
            
           // if (!barraDeBusqueda.text!.contains("https://www."))
            //{
              //  barraDeBusqueda.text="https://www."+barraDeBusqueda.text!
            //}
            let url = URL(string: barraDeBusqueda.text!)
            let request = URLRequest(url: url!)
            webKitView.load(request)
            
        }
    
    
    
    
    
    
    
    
    

    /*
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        barraDeBusqueda.resignFirstResponder()

        if let url = URL(string: barraDeBusqueda.text!)
        {
            //let myURL = URL(string: barraDeBusqueda.text!)
            //let myRequest = URLRequest(url: myURL!)
            //webKitView.load(myRequest)
            
            //let myRequest = URLRequest(url: url)
            //webKitView.load(myRequest)

        }
        else
        {
            print("ERROR")
        }
    }
    */
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

   /*
    func didStartLoad(_ webKitView: WKWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if webKitView.canGoBack
        {
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


    
    func webView(_ webKitView: WKWebView, didFinish navigation: WKNavigation!) {
        retroceder.isEnabled = webKitView.canGoBack
        avanzar.isEnabled = webKitView.canGoForward
        
        barraDeBusqueda.text = webKitView.url?.absoluteString
    }
    */

    



    }
    

