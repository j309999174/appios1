//
//  ViewController.swift
//  appios1
//
//  Created by j309999174 on 2018/12/7.
//  Copyright © 2018 j309999174. All rights reserved.
//

import UIKit
import LeanCloud
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {
    
    var webView : WKWebView!
    
    var leancloudurl : String! = "https://applet.oushelun.cn/app/index.php?i=19&c=entry&m=ewei_shopv2&do=mobile&r=merch&merchid=101"

    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //webview部分
        url = URL(string: leancloudurl!)!

        webView.load(URLRequest(url : url))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goback = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let goforward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        let gohomepage = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.homepage))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.voidfunc))
        toolbarItems = [goback,space,goforward,space,refresh,space,gohomepage]
        
        
        //如果switch为1，则leancloudurl设为数据库的值，否则默认
        let query = LCQuery(className: "config")
        query.get("5c0f41b044d904005f420632") { result in
            switch result {
            case .success(let config):
                
                if config.get("switch")?.intValue! == 1 {
                    self.leancloudurl = config.get("url")?.stringValue
                    self.url = URL(string: self.leancloudurl!)!
                    self.webView.load(URLRequest(url : self.url))
                    self.navigationController?.isToolbarHidden = false
                }
                print(config.get("url")?.stringValue ?? "https://leancloud.cn")
                
                print(config.get("switch")?.intValue ?? "0")
                
            case .failure(let error):
                print(error)
            }
        }
        
        //隐藏导航条
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    @objc
    func homepage(){
        webView.load(URLRequest(url : url))
    }
    
    @objc
    func voidfunc(){
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //跳转appstore
        let policy : WKNavigationActionPolicy = WKNavigationActionPolicy.allow
        
        if navigationAction.request.url?.host == "itunes.apple.com" {
            UIApplication.shared.openURL(navigationAction.request.url ?? url)
        }
        
        if (navigationAction.request.url?.absoluteString.contains("itms-services"))! {
            UIApplication.shared.openURL(navigationAction.request.url ?? url)
        }
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(policy)
    }
   
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let url = navigationAction.request.url
            if url?.description.lowercased().range(of: "http://") != nil || url?.description.lowercased().range(of: "https://") != nil || url?.description.lowercased().range(of: "mailto:") != nil  {
                webView.load(URLRequest(url: url!))
            }
        }
        return nil
    }

}

