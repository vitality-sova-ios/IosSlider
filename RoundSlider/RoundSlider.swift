//
//  RoundSlider.swift
//  RoundSlider
//
//  Created by v.sova on 12.04.18.
//  Copyright © 2018 v.sova. All rights reserved.
//

import UIKit

class RoundSliderThumb: CALayer {
    
    var slider: RoundSlider?
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        
        if let slider = self.slider {
            
            ctx.saveGState()
            
            let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.bounds.size.width / 2)
            
            ctx.setFillColor(slider.colorThumb.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            ctx.restoreGState()
        }
    }
}

class RoundSliderTrack: CALayer {
    
    var slider: RoundSlider?

    override func draw(in ctx: CGContext) {
        
        if let slider = self.slider {
            
            ctx.saveGState()
            let oval = UIBezierPath(arcCenter: CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2), radius: self.bounds.size.width / 2 - slider.sizeTrack / 2, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2) - CGFloat.pi / 2, clockwise: true)
            ctx.setStrokeColor(slider.colorTrackBack.cgColor)
            ctx.addPath(oval.cgPath)
            ctx.setLineWidth(slider.sizeTrack)
            ctx.strokePath()
            
            let ovalPath = UIBezierPath(arcCenter: CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2), radius: self.bounds.size.width / 2 - slider.sizeTrack / 2, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2) * slider.value - CGFloat.pi / 2, clockwise: true)
            ovalPath.lineCapStyle = .round
            ctx.setStrokeColor(slider.colorTrack.cgColor)
            ctx.addPath(ovalPath.cgPath)
            ctx.setLineWidth(slider.sizeTrack - 4)
            ctx.setLineCap(.round)
            ctx.strokePath()
            ctx.restoreGState()
        }
    }
}

class RoundSlider: UIControl {

    var minValue: CGFloat = 0
    var maxValue: CGFloat = 1
    var value: CGFloat = 0.2 {
        
        didSet {
            
            updateFrames()
        }
    }
    
    var colorTrackBack: UIColor = UIColor.lightGray {
        
        didSet { track.setNeedsDisplay() }
    }
    var colorTrack: UIColor = UIColor.darkGray {
        
        didSet { track.setNeedsDisplay() }
    }
    var colorThumb: UIColor = UIColor.red {
        
        didSet { thumb.setNeedsDisplay() }
    }
    
    var sizeTrack: CGFloat = 10 {
        
        didSet { track.setNeedsDisplay() }
    }
    var sizeThumb: CGFloat = 10 {
        
        didSet { thumb.setNeedsDisplay() }
    }
    
    let track = RoundSliderTrack.init()
    let thumb = RoundSliderThumb.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sizeTrack = frame.size.width / 8
        sizeThumb = frame.size.width / 8

        track.slider = self
        track.frame = self.bounds
        track.contentsScale = UIScreen.main.scale
        layer.addSublayer(track)
        track.setNeedsDisplay()
        
        thumb.slider = self
        thumb.frame = CGRect.init(x: 0, y: 0, width: sizeThumb - 4, height: sizeThumb - 4)
        thumb.contentsScale = UIScreen.main.scale
        thumb.shadowOpacity = 0.3
        thumb.shadowRadius = 2
        layer.addSublayer(thumb)
        thumb.setNeedsDisplay()
        
        updateFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        print("begin \(touch.location(in: self))")
        
        if thumb.frame.contains(touch.location(in: self)) {
            
            thumb.highlighted = true
        }
        
        return thumb.highlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        print("continue \(touch.location(in: self))")
        
        let location = touch.location(in: self)

        var a = angle(CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.width / 2), CGPoint.init(x: self.bounds.size.width / 2, y: 0), location)
        print("angle \(a)")
        
        a = self.bounds.size.width / 2 <= location.x ? a : 360 - a
        
        value = a / 360
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        if let t = touch {
            
            print("end \(t.location(in: self))")
        } else {
            print("end")
        }
        
        thumb.highlighted = false
    }
    
    func updateFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let x = self.bounds.size.width / 2 + (self.bounds.size.width / 2 - sizeThumb / 2) * cos(CGFloat.pi * 2 * value - CGFloat.pi / 2)
        let y = self.bounds.size.height / 2 + (self.bounds.size.height / 2 - sizeThumb / 2) * sin(CGFloat.pi * 2 * value - CGFloat.pi / 2)
        print("frame = \(value) \(x) \(y)")
        thumb.frame = CGRect.init(x: x - thumb.frame.size.width / 2, y: y - thumb.frame.size.height / 2, width: thumb.frame.size.width, height: thumb.frame.size.height)
        
        track.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func radToDegrees(_ rad: CGFloat) -> CGFloat {
        
        return rad * (180 / CGFloat.pi)
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func angle(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
        
        let ang = acos( (pow(distance(a, b), 2) + pow(distance(a, c), 2) - pow(distance(b, c), 2)) / ( 2 * distance(a, b) * distance(a, c)))
        
        return radToDegrees(ang)
    }
}























