//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
var str = "Hello, playground"

var roundRect = UIBezierPath(roundedRect:CGRect(x: 0, y: 0, width: 20, height: 100), byRoundingCorners:.allCorners, cornerRadii: CGSize(width: 5, height: 5))
var roundRect2 = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: 16, height: 96), byRoundingCorners:.allCorners, cornerRadii: CGSize(width: 5, height: 5))


let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
//XCPShowView("Container View", containerView)

let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
circle.center = containerView.center
circle.layer.cornerRadius = 25.0

let startingColor = UIColor(red: (253.0/255.0), green: (159.0/255.0), blue: (47.0/255.0), alpha: 1.0)
circle.backgroundColor = startingColor

containerView.addSubview(circle);

let rectangle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
rectangle.center = containerView.center
rectangle.layer.cornerRadius = 5.0

rectangle.backgroundColor = .white

containerView.addSubview(rectangle)

//UIView.animateWithDuration(2.0, animations: { () -> Void in
//    let endingColor = UIColor(red: (255.0/255.0), green: (61.0/255.0), blue: (24.0/255.0), alpha: 1.0)
//    circle.backgroundColor = endingColor
//    
//    let scaleTransform = CGAffineTransformMakeScale(5.0, 5.0)
//    
//    circle.transform = scaleTransform
//    
//    let rotationTransform = CGAffineTransformMakeRotation(3.14)
//    
//    rectangle.transform = rotationTransform
//})



//var ovalPath = UIBezierPath(ovalInRect: CGRectMake(160, 160, 240, 320))
//UIColor.redColor().setFill()
//ovalPath.fill()
//
//
//
//let path = UIBezierPath()
//let start=CGPoint(x: 0, y: 0)
//let end=CGPoint(x: 300, y: 300)
//// Move the "cursor" to the start
//path.moveToPoint(start)
//
//// Calculate the control points
//let c1 = CGPoint(x: start.x + 64, y: start.y)
//let c2 = CGPoint(x: end.x, y: end.y - 128)
//
//// Draw a curve towards the end, using control points
//path.addCurveToPoint(end, controlPoint1:c1, controlPoint2:c2)
//UIColor.redColor().setFill()
//path.stroke()
//





import UIKit

class PolyImageView: UIView {
    
    private let count = 8
    private let inset: CGFloat = 10
    private let lineWidth: CGFloat = 10
    private let lineColor = UIColor.lightGray
    
    private var bezierPath: UIBezierPath?
    let imageView = UIImageView();
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
    }
    
    override func draw(_ rect: CGRect) {
        if let path = bezierPath {
            lineColor.setStroke()
            path.stroke()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let rect = bounds;
        
        let insetRect = rect.insetBy(dx: inset, dy: inset)
        let radius = (insetRect.width > insetRect.height ? insetRect.height : insetRect.width) / 2.0
        let center = CGPoint(x: insetRect.midX, y: insetRect.midY)
        let radian = CGFloat(M_PI * 2) / CGFloat(count)
        let subRadius = radius * 0.4
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        let startPoint = CGPoint(x:center.x,y:center.y - radius)
        path.move(to: startPoint)
        
        // first curve
        let firstControlPoint = CGPoint(x: startPoint.x, y: startPoint.y + subRadius)
        path.addArc(withCenter: firstControlPoint,
            radius: subRadius,
            startAngle: CGFloat(3 * M_PI_2),
            endAngle: CGFloat(3 * M_PI_2) - radian / 2,
            clockwise: false)
        
        for i in 1...count  {
            let θ = CGFloat(3*M_PI/2) - CGFloat(i) * radian
            
            let point = CGPoint(
                x: center.x + radius * cos(θ),
                y: center.y + radius * sin(θ)
            )
            
            let controlPoint = CGPoint(
                x: center.x + (radius * 0.6) * cos(θ),
                y: center.y + (radius * 0.6) * sin(θ)
            )
            
            let deltaY = point.y - controlPoint.y
            let deltaX = point.x - controlPoint.x
            
            let radianDelta = atan2(deltaY, deltaX)
            
            let startAngle = radianDelta + (radian / 2)
            let endAngle = radianDelta - (radian / 2)
            
            path.addArc(withCenter: controlPoint,
                radius: subRadius,
                startAngle: startAngle,
                endAngle: endAngle, clockwise: false)
            
        }
        
        imageView.frame = bounds
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        imageView.layer.mask = maskLayer
        
        bezierPath = path
        setNeedsDisplay()
    }
    
}
let view=PolyImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))


let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)

//let date = NSDate()
//let calendar = NSCalendar.current
//let components = calendar.components([.hour, .minute], fromDate: date)
//let hour = components.hour
//let minutes = components.minute

