//
//  ViewController.swift
//  TimeLineNew
//
//  Created by wyx on 2017/9/29.
//  Copyright © 2017年 wyx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var timeLineView : TimeLineView?
    var isEditingEvent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = Date().getString()
        self.configureNavigationItem()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width * 12, height: scrollView.bounds.size.height - 64)
        
        timeLineView = TimeLineView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
//        view.backgroundColor = UIColor.blue
        scrollView.addSubview(timeLineView!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scollStateUnable), name: NSNotification.Name("UnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scollStateAble), name: NSNotification.Name("AbleScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.becomeEditingState), name: NSNotification.Name("becomeEditingEvent"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.resignEditingState), name: NSNotification.Name("resignEditingEvent"), object: nil)
    }

    @objc func scollStateUnable() {
        scrollView.isScrollEnabled = false
    }
    
    @objc func scollStateAble() {
        scrollView.isScrollEnabled = true
    }
    
    @objc func configureNavigationItem() {
        if isEditingEvent {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelEditEvent))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneEditEvent))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.showSettingView))
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func becomeEditingState() {
        isEditingEvent = true
        self.configureNavigationItem()
    }
    
//    @objc func resignEditingState() {
//        isEditingEvent = false
//        self.configureNavigationItem()
//    }
    
    @objc func showSettingView() {
        print("setting")
    }
    
    @objc func cancelEditEvent() {
        print("cancel")
        isEditingEvent = false
        self.configureNavigationItem()
        self.timeLineView?.endEditing(true)
    }
    
    @objc func doneEditEvent() {
        print("done")
        self.timeLineView?.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

