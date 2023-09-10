//
//  BrowserViewController.swift
//  Gululu
//
//  Created by Wei on 6/9/16.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

enum BrowerButton: Int {
    case close      = 0
    case goBack     = 1
    case goForward  = 2
    case refresh    = 3
}

class BrowserViewController: UIViewController, UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var webURL = String()
    let webView = UIWebView()
    let previousButton = UIButton(type: .custom)
    let advanceButton = UIButton(type: .custom)
    let refreshButton = UIButton(type: .custom)
    var progressTimer: Timer! = nil
    var progressBar = UIProgressView()
    var loadDone: Bool = false
    var dissMissSelectView = false
    var addParamUserSn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutBrowserView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dissMissSelectView = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
        dissMissSelectView = false
        DispatchQueue.main.async{
            self.progressBar.removeFromSuperview()
        }
    }
    
    func layoutBrowserView() {
        view.backgroundColor = UIColor(red: (70.0/255.0), green: (188.0/255.0), blue: (174.0/255.0), alpha: 1.0)
        
        let closeImage = UIImage(named: "closeWeb")
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(closeImage, for: .normal)
        leftButton.frame = CGRect(x: 0.0, y: 0.0, width: (closeImage?.size.width)!, height: (closeImage?.size.height)!)
        leftButton.addTarget(self, action: #selector(webActionEvent(_:)), for: .touchUpInside)
        leftButton.tag = BrowerButton.close.hashValue
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let controlView = UIView()
        controlView.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0)
        controlView.backgroundColor = .clear
        
        let refreshImage = UIImage(named: "refresh")
        refreshButton.setImage(refreshImage, for: .normal)
        refreshButton.addTarget(self, action: #selector(webActionEvent(_:)), for: .touchUpInside)
        refreshButton.tag = BrowerButton.refresh.hashValue
        controlView.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(controlView)
            ConstraintMaker.centerY.equalTo(controlView).offset(-1.0)
            ConstraintMaker.size.equalTo(CGSize(width: (refreshImage?.size.width)!, height: (refreshImage?.size.height)!))
        }
        
        let previousImage = UIImage(named: "previous")
        previousButton.setImage(previousImage, for: .normal)
        previousButton.addTarget(self, action: #selector(webActionEvent(_:)), for: .touchUpInside)
        previousButton.tag = BrowerButton.goBack.hashValue
        controlView.addSubview(previousButton)
        previousButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(controlView)
            ConstraintMaker.right.equalTo(refreshButton.snp.left).offset(-31.0)
            ConstraintMaker.size.equalTo(CGSize(width: (previousImage?.size.width)!, height: (previousImage?.size.height)!))
        }
        
        let advanceImage = UIImage(named: "advance")
        advanceButton.setImage(advanceImage, for: .normal)
        advanceButton.addTarget(self, action: #selector(webActionEvent(_:)), for: .touchUpInside)
        advanceButton.tag = BrowerButton.goForward.hashValue
        controlView.addSubview(advanceButton)
        advanceButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(controlView)
            ConstraintMaker.left.equalTo(refreshButton.snp.right).offset(31.0)
            ConstraintMaker.size.equalTo(CGSize(width: (advanceImage?.size.width)!, height: (advanceImage?.size.height)!))
        }
        
        let naviBar = UINavigationBar()
        naviBar.backgroundColor = .clear
        naviBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        view.addSubview(naviBar)
        naviBar.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(view)
            ConstraintMaker.left.right.equalTo(view)
            ConstraintMaker.top.equalTo(view).offset(20.0)
            ConstraintMaker.height.equalTo(44.0)
        }
        
        let naviItem = UINavigationItem()
        naviBar.pushItem(naviItem, animated: true)
        naviItem.setLeftBarButton(UIBarButtonItem(customView: leftButton), animated: true)
        naviItem.titleView = controlView
        
        webView.backgroundColor = .clear
        webView.delegate = self
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.bottom.equalTo(view)
            ConstraintMaker.top.equalTo(naviBar.snp.bottom)
        }
        
        progressBar = UIProgressView(progressViewStyle:UIProgressViewStyle.bar)
        progressBar.tintColor = UIColor(red: (0.0/255.0), green: (159.0/255.0), blue: (223.0/255.0), alpha: 1.0)
        progressBar.progress = 0
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(view)
            ConstraintMaker.top.equalTo(naviBar.snp.bottom)
            ConstraintMaker.height.equalTo(2.0)
        }
        webView.loadRequest(URLRequest(url: URL(string: webURL)!))
    }
    
    
    
    @objc func webActionEvent(_ button: UIButton) {
        switch button.tag {
        case BrowerButton.close.hashValue:
            dismiss(animated: true, completion: nil)
            break
        case BrowerButton.refresh.hashValue:
            if webView.isLoading
            {
                webView.stopLoading()
                progressBar.progress = 0
                progressBar.isHidden = true
            }
            else
            {
                webView.reload()
                loadDone = false
                progressBar.isHidden = false
                progressTimer = Timer.scheduledTimer(timeInterval: 0.2, target:self ,selector: #selector(BrowserViewController.loadProgress), userInfo: nil, repeats: true)
            }
            break
        case BrowerButton.goBack.hashValue:
            if webView.canGoBack
            {
                webView.goBack()
            }
            break
        case BrowerButton.goForward.hashValue:
            if webView.canGoForward
            {
                webView.goForward()
            }
            break
        default:
            webView.reload()
            loadDone = false
            progressBar.isHidden = false
            progressTimer = Timer.scheduledTimer(timeInterval: 0.2, target:self ,selector: #selector(BrowserViewController.loadProgress), userInfo: nil, repeats: true)
        }
    }
    
    @objc func loadProgress() {
        if loadDone
        {
            if(progressBar.progress >= 1.0)
            {
                progressTimer.invalidate()
                progressBar.progress = 0
                progressBar.isHidden = true
            }
            else
            {
                progressBar.setProgress(progressBar.progress + 0.1, animated:true)
            }
        }
        else
        {
            progressBar.setProgress(progressBar.progress + 0.01, animated:true)
            if progressBar.progress >= 0.9
            {
                progressBar.progress = 0.9
            }
        }
    }
    
    // MARK: - UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        loadDone = false
        progressBar.isHidden = false
        progressTimer = Timer.scheduledTimer(timeInterval: 0.2, target:self ,selector: #selector(BrowserViewController.loadProgress), userInfo: nil, repeats: true)
        checkCanGoBackOrForward()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        loadDone = true
        checkCanGoBackOrForward()
    }
    
    func checkCanGoBackOrForward()
    {
        advanceButton.isEnabled  = webView.canGoForward
        previousButton.isEnabled = webView.canGoBack
    }
    
    override func dismiss(animated flag:Bool, completion: (() ->Void)?) {
        if !dissMissSelectView{
            dissMissSelectView = true
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    
}
