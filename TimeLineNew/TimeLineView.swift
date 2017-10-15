//
//  TimeLineView.swift
//  TimeLineNew
//
//  Created by wyx on 2017/9/29.
//  Copyright © 2017年 wyx. All rights reserved.
//

import UIKit
import AudioToolbox

//struct YXDateType {
//    public init(rawValue: UInt)
//}

enum YXDateType: Int {
    case day = 0
    case week
    case month
}

class TimeLineView: UIView {
    
    private var dateType : YXDateType = .day
    var type : YXDateType {
        get {
            return dateType
        }
        set(value) {
            dateType = value
        }
    }
    
    var currentDate = Date()
    
    var points = [CGPoint]()//时间线的所有点
    var startPoint = CGPoint()//长按手势画线的起点
    var endPoint = CGPoint()//长按手势画线的终点
    
//    var isAddedPoint = false//是否添加过点
    
    var tipLabel : UILabel?//提示时间
    var gesView : UIView?
    var focusLabel : UILabel?
    
    var allWidth = UIScreen.main.bounds.size.width * 12//TimeLineView总宽度
//    let allHeight = self.bounds.size.height
    var allHeight = UIScreen.main.bounds.size.height - 20.0//TimeLineView总高度
    var width = UIScreen.main.bounds.size.width / 2 - 20//时间线每个点的间隔宽度
    
    init(frame: CGRect, type: YXDateType) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        allWidth = frame.size.width
//        switch type {
//        case .day:
//            allWidth = (UIScreen.main.bounds.size.width/2 - 20) * 12
//        case .week:
//            allWidth = (UIScreen.main.bounds.size.width/2 - 20) * 4
//        case .month:
//            allWidth = (UIScreen.main.bounds.size.width/2 - 20) * 16
//        }
        
        
        self.dateType = type
        self.configureTimePoints()
        
        let margin = (allWidth - width * CGFloat(points.count - 1)) / 2
        gesView = UIView(frame: CGRect(x: margin - 10, y: allHeight/2 - 20, width: allWidth - margin*2 + 20, height: 40))
//        gesView.backgroundColor = UIColor.yellow
        self.addSubview(gesView!)
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(TimeLineView.longPressAction(_:)))
        longGes.allowableMovement = 999
        longGes.minimumPressDuration = 2
        gesView!.addGestureRecognizer(longGes)                
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func longPressAction(_ sender:UILongPressGestureRecognizer) {
        let location = sender.location(in: self)
        if sender.state == .began {
            NotificationCenter.default.post(name: NSNotification.Name("UnableScroll"), object: nil)
            
            if fabsf(Float(location.y - allHeight/2)) < 20 {
                if tipLabel == nil {
                    tipLabel = UILabel(frame: CGRect(x: location.x - 20, y: allHeight/2 - 40, width: 40, height: 20))
                    tipLabel?.font = UIFont.systemFont(ofSize: 13)
                    tipLabel?.textAlignment = .center
                    tipLabel?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                    tipLabel?.textColor = UIColor.white
                    tipLabel?.layer.cornerRadius = 3
                    tipLabel?.layer.masksToBounds = true
                    self.addSubview(tipLabel!)
                } else {
                    tipLabel?.isHidden = false
                }
                tipLabel?.center = CGPoint(x: location.x, y: allHeight/2 - 30)
                tipLabel?.text = self.getTimeString(point: location)
            }
            
            
//            startPoint = sender.location(in: self)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)//触发震动（前提条件是“响铃震动和静音震动”都开启）
        } else if sender.state == .ended {
            print("已结束")
            NotificationCenter.default.post(name: NSNotification.Name("AbleScroll"), object: nil)
            tipLabel?.isHidden = true
            
            if fabsf(Float(location.y - allHeight/2)) < 20 {//如果上下范围在手势区域内，则画线位置增加偏移量
                endPoint = CGPoint(x: location.x, y: location.y<allHeight/2 ? location.y - 20 : location.y + 20)
            } else {
                endPoint = location
                
                NotificationCenter.default.post(name: NSNotification.Name("ShowAlert"), object: nil)
                
            }
//            endPoint = sender.location(in: self)
//            self.drawLine(start: startPoint, end: endPoint)
        } else if sender.state == .changed {
            if fabsf(Float(location.y - allHeight/2)) < 20 {//如果上下范围在手势区域内，则更新tipLabel的位置
                let margin = (allWidth - width * 24) / 2
                if location.x < margin || location.x > allWidth - margin {//如果左右范围在手势区域内，则限制tipLabel的位置不能超越时间轴
                    tipLabel?.isHidden = true
                    startPoint = CGPoint(x: location.x < margin ? margin : (allWidth - margin), y: allHeight/2)
                } else {
                    tipLabel?.isHidden = false
                    startPoint = location
                }
                
                tipLabel?.center = CGPoint(x: location.x, y: allHeight/2 - 30)
                tipLabel?.text = self.getTimeString(point: location)
            }
            print("进行中")
            //            endPoint = sender.location(in: self)
            //            let newLayer = self.drawLineWithoutAnimation(start: startPoint, end: endPoint)
            //            if isAddedPoint == true {
            //                self.layer.replaceSublayer((self.layer.sublayers?.last)!, with: newLayer)
            //            }
        }
    }
    
//    func drawLineWithoutAnimation(start: CGPoint, end: CGPoint) -> (CALayer) {
//        isAddedPoint = true
//
//        let bezierPath = UIBezierPath()
//        bezierPath.move(to: CGPoint(x: start.x, y: allHeight / 2))
//        bezierPath.addLine(to: CGPoint(x: start.x, y: end.y))
//        bezierPath.addLine(to: CGPoint(x: end.x, y: end.y))
//
//        //画线
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 2
//        shapeLayer.lineJoin = kCALineJoinRound
//        shapeLayer.lineCap = kCALineCapRound
//        shapeLayer.path = bezierPath.cgPath
////        self.layer.addSublayer(shapeLayer)
//
//        return shapeLayer
//    }
    
//    func addLayerAnimationPosition(layer: CALayer, start : CGPoint, end: CGPoint) {
//        let animation = CABasicAnimation(keyPath: "position")
//        //开始的位置
//        animation.fromValue = NSValue(cgPoint: start)
//        //移动到的位置
//        animation.toValue = NSValue(cgPoint: end)
//        //持续时间
////        animation.beginTime = CACurrentMediaTime() + 3
//        animation.duration = 0.1
//        //运动后的位置保持不变（layer的最后位置是toValue）
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = kCAFillModeForwards
//
//        //添加动画
//        layer.add(animation, forKey: "addLayerAnimationPosition")
//    }
    
    //MARK 画线操作
    func drawLine(start: CGPoint, end: CGPoint) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: start.x, y: allHeight / 2))
        bezierPath.addLine(to: CGPoint(x: start.x, y: end.y))
        bezierPath.addLine(to: CGPoint(x: end.x, y: end.y))
        
        //画线
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.path = bezierPath.cgPath
        self.layer.addSublayer(shapeLayer)
//        print("\(self.layer.sublayers)")
        
        let pathAnim = CABasicAnimation(keyPath: "strokeEnd")
        pathAnim.duration = 5.0
        pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnim.fromValue = 0//开始
        pathAnim.toValue = 1//到100%
//        pathAnim.autoreverses = true// 动画按原路径返回
        pathAnim.fillMode = kCAFillModeForwards
        //        pathAnim.isRemovedOnCompletion = false
//        pathAnim.repeatCount = Float.infinity
        shapeLayer.add(pathAnim, forKey: "strokeEndAnim")
        
        
        //视图沿路径移动
//        let moveV = UIImageView.init(image: UIImage.init(named: ""))
//        moveV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        moveV.backgroundColor = UIColor.red
//        moveV.center = CGPoint(x: 50, y: 100)
//        self.addSubview(moveV)
//
//        let keyAnima = CAKeyframeAnimation.init(keyPath: "position")
//        //        keyAnima.delegate = self
//        keyAnima.duration = 5.0
//        keyAnima.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
//        keyAnima.path = bezierPath.cgPath
//        keyAnima.fillMode = kCAFillModeForwards//动画开始之后layer的状态将保持在动画的最后一帧，而removedOnCompletion的默认属性值是 YES，所以为了使动画结束之后layer保持结束状态，应将removedOnCompletion设置为NO
//        keyAnima.isRemovedOnCompletion = false
//        moveV.layer.add(keyAnima, forKey: "moveAnimation")
        
        let xPoint = start.x < end.x ? start.x : end.x
        let yPoint = end.y - 34

        let label = UILabel(frame:  CGRect(x: xPoint, y: yPoint, width: 100, height: 34))
        label.numberOfLines = 0
        self.addSubview(label)
        focusLabel = label
//        let textField = UITextField(frame: CGRect(x: xPoint, y: yPoint, width: 100, height: 34))
//        textField.delegate = self
//        self.addSubview(textField)
//        textField.becomeFirstResponder()
    }
    
    func addEvent(content: String) {
        self.drawLine(start: startPoint, end: endPoint)
        focusLabel?.text = content
        
        let model = JobModel()
        model.date = Date.getDateFrom(string: "\(currentDate.getString()) \(String(describing: tipLabel!.text))")
        model.name = content
        model.endPoint = endPoint
        CDOption.insertData(model: model)
    }
    
    //MARK 配置时间轴的所有时间点位置
    func configureTimePoints() {
        points.removeAll()
        
        switch dateType {
        case .day:
            let margin = (allWidth - width * 24) / 2
            for item in 0...24 {
                let point = CGPoint(x: margin + CGFloat(item)*width, y: allHeight / 2)
                points.append(point)
                
                let timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: point.x - 25, y: point.y), size: CGSize(width: 50, height: 20)))
                let str = item<10 ? "0\(item)" : "\(item)"
                timeLabel.text = "\(str):00"
                timeLabel.textAlignment = .center
                self.addSubview(timeLabel)
            }
            
            let fromDate = Date.getDateFrom(string: "\(currentDate.getString()) 00:00")
            let toDate = Date.getDateFrom(string: "\(currentDate.getString()) 24:00")
            let dataArray = CDOption.fetch(between: fromDate, toDate: toDate)
            for item in dataArray {
                let start = self.getEventStartPoint(time: item.date)
                let end = item.endPoint
                self.drawLine(start: start, end: end)
            }
            
        case .week:
            let margin = (allWidth - width * 6) / 2
            for item in 0...6 {
                let point = CGPoint(x: margin + CGFloat(item)*width, y: allHeight / 2)
                points.append(point)
                
                let timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: point.x - 25, y: point.y), size: CGSize(width: 50, height: 20)))
                timeLabel.text = "\(item + 1)"
                timeLabel.textAlignment = .center
                self.addSubview(timeLabel)
            }
            
        case .month:
            let margin = (allWidth - width * 30) / 2
            for item in 0...30 {
                let point = CGPoint(x: margin + CGFloat(item)*width, y: allHeight / 2)
                points.append(point)
                
                let timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: point.x - 25, y: point.y), size: CGSize(width: 50, height: 20)))
                timeLabel.text = "\(item + 1)"
                timeLabel.textAlignment = .center
                self.addSubview(timeLabel)
            }
        }
        
    }
    
    //MARK 获取时间轴上的时间提示
    func getTimeString(point: CGPoint) -> String {
        let minuteWidth = Int(width/12)
        let hourWidth = Int(width)
        let timeLineStartPoint = Int((allWidth - width * 24) / 2)
        let hour = (Int(point.x) - timeLineStartPoint) / hourWidth
        let minute = Int(point.x) - timeLineStartPoint - hour*hourWidth
        let minutesNum = minute/minuteWidth > 11 ? 11 : minute/minuteWidth
        let timeStr = "\(hour):\(minutesNum*5)"
        print(timeStr)
        return timeStr
    }
    
    //MARK 获取时间轴上的时间提示的开始位置
//    func getEventStartPoint(timeStr: String) -> CGPoint {
    func getEventStartPoint(time: Date) -> CGPoint {
        let timeStr = time.getStringFrom(formatter: "yyyy-MM-dd HH:mm")
        let timeArr = timeStr.components(separatedBy: [" ",":"])
        let minuteWidth = Int(width/12)
        let hourWidth = Int(width)
        let timeLineStartPoint = Int((allWidth - width * 24) / 2)
        let hours = hourWidth * Int(timeArr[1])!
        let minutes = minuteWidth * Int(timeArr[2])!
        let startPoint = CGPoint(x: CGFloat(timeLineStartPoint + hours + minutes), y: allHeight/2)
        return startPoint
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let allWidth = UIScreen.main.bounds.size.width * 12
//        let allHeight = self.bounds.size.height
//        let width = UIScreen.main.bounds.size.width / 2 - 20
        let margin = (allWidth - width * CGFloat(points.count - 1)) / 2
        
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: margin, y: allHeight / 2))
        context?.addLine(to: CGPoint(x: allWidth - margin, y: allHeight / 2))
        context?.setLineWidth(2)
        context?.setLineCap(.round)
        context?.strokePath()
        
        for item in points {
            context?.move(to: CGPoint(x: item.x, y: item.y))
            context?.addLine(to: CGPoint(x: item.x, y: item.y - 10))
            context?.setLineWidth(2)
            context?.setLineCap(.round)
            context?.strokePath()
//            context?.addArc(center: item, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//            context?.fillPath()
//            context?.fillEllipse(in: CGRect(origin: item, size: CGSize(width: 30, height: 30)))
//            context?.strokePath()
        }
        
    }
    
    func reloadData() {
        self.setNeedsDisplay()
        self.configureTimePoints()
    }
    //MARK UITextFieldDelegate
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        NotificationCenter.default.post(name: NSNotification.Name("becomeEditingEvent"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("UnableScroll"), object: nil, userInfo: nil)
//        gesView?.isUserInteractionEnabled = false
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        NotificationCenter.default.post(name: NSNotification.Name("AbleScroll"), object: nil, userInfo: nil)
//        gesView?.isUserInteractionEnabled = true
//    }
}
