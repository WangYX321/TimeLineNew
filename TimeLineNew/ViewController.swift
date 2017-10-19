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
        
        scrollView.contentSize = CGSize(width: (self.view.bounds.size.width/2 - 20) * 26, height: scrollView.bounds.size.height - 64)
        
        timeLineView = TimeLineView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height), type:.day)
//        view.backgroundColor = UIColor.blue
        scrollView.addSubview(timeLineView!)
        
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAction(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scollStateUnable), name: NSNotification.Name("UnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scollStateAble), name: NSNotification.Name("AbleScroll"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.becomeEditingState), name: NSNotification.Name("becomeEditingEvent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAddAlert), name: NSNotification.Name("ShowAddAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeleteAlert), name: NSNotification.Name("ShowDeleteAlert"), object: nil)
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
    
    @objc func showAddAlert() {
        let alert = UIAlertController(title: "新建日程", message: "请填写日程内容", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "请输入"
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
            if let content = alert.textFields![0].text {
                if content.characters.count > 0 {
                    self.timeLineView!.addEvent(content: content)                    
                } else {
                   self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showDeleteAlert() {
        let alert = UIAlertController(title: "删除日程", message: "确定要删除此日程吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "确定", style: .default) { action in
            self.timeLineView!.deleteEvent()
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
        
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
    
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        print("\(sender.scale)")
        var type: YXDateType
        var number : CGFloat
        if sender.state == .ended {
            if sender.scale < 1 {
                if timeLineView!.type.rawValue == 2 {
                    return
                }
                
                type = YXDateType(rawValue: timeLineView!.type.rawValue + 1)!
//                timeLineView!.reloadData()
            } else {
                if timeLineView!.type.rawValue == 0 {
                    return
                }
                type = YXDateType(rawValue: timeLineView!.type.rawValue - 1)!
//                timeLineView!.reloadData()
            }
            print("\(timeLineView!.type.rawValue)")
            
            switch type {
                case .day:
                    number = 26
                case .week:
                    number = 8
                case .month:
                    number = 33
            }
            
            timeLineView?.removeFromSuperview()
            timeLineView = nil
            scrollView.contentSize = CGSize(width: (self.view.bounds.size.width/2 - 20) * number , height: scrollView.bounds.size.height - 64)
            timeLineView = TimeLineView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height), type:type)
            scrollView.addSubview(timeLineView!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

