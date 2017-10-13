//
//  TimeLineView.swift
//  TimeLineNew
//
//  Created by wyx on 2017/9/29.
//  Copyright © 2017年 wyx. All rights reserved.
//

import UIKit
import AudioToolbox

class TimeLineView: UIView, UITextFieldDelegate {
    
    var points = [CGPoint]()
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    var isAddedPoint = false
    
    var tipLabel : UILabel?
    
    
    let allWidth = UIScreen.main.bounds.size.width * 12
//    let allHeight = self.bounds.size.height
    let allHeight = UIScreen.main.bounds.size.height - 20.0
    let width = UIScreen.main.bounds.size.width / 2 - 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureTimePoints()
        
        let margin = (allWidth - width * 24) / 2
        let gesView = UIView(frame: CGRect(x: margin - 10, y: allHeight/2 - 20, width: allWidth - margin*2 + 20, height: 40))
//        gesView.backgroundColor = UIColor.yellow
        self.addSubview(gesView)
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(TimeLineView.longPressAction(_:)))
        longGes.allowableMovement = 999
        longGes.minimumPressDuration = 2
        gesView.addGestureRecognizer(longGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func longPressAction(_ sender:UILongPressGestureRecognizer) {
//        let location = sender.location(in: self)
//        if fabsf(Float(location.y - allHeight/2)) < 20 {
//            if sender.state == .began {
//                tipLabel = UILabel(frame: CGRect(x: location.x - 20, y: allHeight/2 - 40, width: 40, height: 20))
//                tipLabel?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//                tipLabel?.layer.cornerRadius = 3
//                tipLabel?.layer.masksToBounds = true
//                self.addSubview(tipLabel!)
//            } else if sender.state == .changed {
//
//            }
//        } else {
            if sender.state == .began {
                NotificationCenter.default.post(name: NSNotification.Name("UnableScroll"), object: nil)
                
                startPoint = sender.location(in: self)
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)//触发震动（前提条件是“响铃震动和静音震动”都开启）
            } else if sender.state == .ended {
                print("已结束")
                NotificationCenter.default.post(name: NSNotification.Name("AbleScroll"), object: nil)
                
                endPoint = sender.location(in: self)
                self.drawLine(start: startPoint, end: endPoint)
            } else {
                print("进行中")
                //            endPoint = sender.location(in: self)
                //            let newLayer = self.drawLineWithoutAnimation(start: startPoint, end: endPoint)
                //            if isAddedPoint == true {
                //                self.layer.replaceSublayer((self.layer.sublayers?.last)!, with: newLayer)
                //            }
            }
//        }
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
    func addLayerAnimationPosition(layer: CALayer) {
        let animation = CABasicAnimation(keyPath: "position")
        //开始的位置
        animation.fromValue = NSValue(cgPoint: CGPoint(x: 120, y: 200))
        //移动到的位置
        animation.toValue = NSValue(cgPoint: CGPoint(x: 220, y: 200))
        //持续时间
        animation.beginTime = CACurrentMediaTime() + 3
        animation.duration = 0.1
        //运动后的位置保持不变（layer的最后位置是toValue）
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        //添加动画
        layer.add(animation, forKey: "addLayerAnimationPosition2")
    }
    
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
        
        let textField = UITextField(frame: CGRect(x: xPoint, y: yPoint, width: 100, height: 34))
        textField.delegate = self
        self.addSubview(textField)
        textField.becomeFirstResponder()
    }
    
    func configureTimePoints() {
        let margin = (allWidth - width * 24) / 2
        for item in 0...24 {
            let point = CGPoint(x: margin + CGFloat(item)*width, y: allHeight / 2)
            points.append(point)
            
            let timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: point.x - 25, y: point.y), size: CGSize(width: 50, height: 20)))
            timeLabel.text = "\(item):00"
            timeLabel.textAlignment = .center
            self.addSubview(timeLabel)
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let allWidth = UIScreen.main.bounds.size.width * 12
//        let allHeight = self.bounds.size.height
//        let width = UIScreen.main.bounds.size.width / 2 - 20
        let margin = (allWidth - width * 24) / 2
        
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
    
    //MARK UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name("becomeEditingEvent"), object: nil)
        return true
    }
}
