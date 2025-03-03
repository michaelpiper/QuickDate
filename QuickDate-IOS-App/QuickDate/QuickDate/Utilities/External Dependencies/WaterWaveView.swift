//
//  WaterWaveView.swift
//
//  Created by iMac on 08/08/23.
//

import UIKit

let LXDefaultFirstWaveColor = UIColor.PrimaryColor
let LXDefaultSecondWaveColor = UIColor.PrimaryColor.withAlphaComponent(0.3)
//UIColor(red: 34/255.0, green: 116/255.0, blue: 210/255.0, alpha: 0.3)

protocol WaveViewWeakDelegate: AnyObject {
    func waveAnimationStart()
}

class WeakTarget: NSObject, WaveViewWeakDelegate {
    weak var delegate: WaveViewWeakDelegate?

    func waveAnimationStart() {
        delegate?.waveAnimationStart()
    }
}

class WaterWaveView: UIView, WaveViewWeakDelegate {
    
    weak var delegate: WaveViewWeakDelegate?
    private var yHeight: CGFloat = 0
    private var offset: CGFloat = 0
    private var start = false
    private var timer: CADisplayLink?
    private var firstWaveLayer: CAShapeLayer = CAShapeLayer()
    private var secondWaveLayer: CAShapeLayer = CAShapeLayer()
    
    var waveHeight: CGFloat = 3.0
    var firstWaveColor: UIColor = LXDefaultFirstWaveColor
    var secondWaveColor: UIColor = LXDefaultSecondWaveColor
    var speed: CGFloat = 1.0
    var isShowSingleWave = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bounds = CGRect(x: 0, y: 0, width: min(frame.size.width, frame.size.height), height: min(frame.size.width, frame.size.height))
        self.layer.cornerRadius = min(frame.size.width, frame.size.height) * 0.5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.PrimaryColor.cgColor
        self.layer.borderWidth = 3.0

        self.yHeight = self.bounds.size.height
        self.speed = 1.0

        self.layer.addSublayer(self.firstWaveLayer)
        if !self.isShowSingleWave {
            self.layer.addSublayer(self.secondWaveLayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progress: CGFloat = 0.0 {
        didSet {
            yHeight = bounds.size.height * (1 - progress)
            let top = progress * bounds.size.height
            firstWaveLayer.setValue(bounds.size.height - top, forKeyPath: "position.y")
            secondWaveLayer.setValue(bounds.size.height - top, forKeyPath: "position.y")
            if !start {
                startWaveAnimation()
            }
        }
    }
    
    func startWaveAnimation() {
        start = true
        waveAnimationForCoreAnimation()
    }
    
    func stopWaveAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    func waveAnimationForCoreAnimation() {
        let bezierFirstWave = UIBezierPath()
        let waveHeight = self.waveHeight
        //let pathRef = CGMutablePath()
        let startOffY = waveHeight * sin(offset * .pi * 2 / bounds.size.width)
        var orignOffY: CGFloat = 0.0

//        CGPathMoveToPoint(pathRef, nil, 0, startOffY)
        bezierFirstWave.move(to: CGPoint(x: 0, y: startOffY))

        for i in stride(from: 0, to: bounds.size.width * 1000, by: 1) {
            orignOffY = waveHeight * sin(2 * .pi / bounds.size.width * i + offset * .pi * 2 / bounds.size.width)
            bezierFirstWave.addLine(to: CGPoint(x: i, y: orignOffY))
        }

        bezierFirstWave.addLine(to: CGPoint(x: bounds.size.width * 1000, y: orignOffY))
        bezierFirstWave.addLine(to: CGPoint(x: bounds.size.width * 1000, y: bounds.size.height))
        bezierFirstWave.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        bezierFirstWave.addLine(to: CGPoint(x: 0, y: startOffY))
        bezierFirstWave.close()

        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2
        anim.fromValue = -frame.size.width * 0.5
        anim.toValue = -frame.size.width - frame.size.width * 0.5
        anim.repeatCount = .greatestFiniteMagnitude
        anim.fillMode = .forwards

        firstWaveLayer.fillColor = firstWaveColor.cgColor
        firstWaveLayer.path = bezierFirstWave.cgPath
        firstWaveLayer.add(anim, forKey: "translate")

        if !isShowSingleWave {
            let bezierSecondWave = UIBezierPath()
            let startOffY1 = waveHeight * sin(offset * .pi * 2 / bounds.size.width)
            var orignOffY1: CGFloat = 0.0
            bezierSecondWave.move(to: CGPoint(x: 0, y: startOffY1))

            for i in stride(from: 0, to: bounds.size.width * 1000, by: 1) {
                orignOffY1 = waveHeight * cos(2 * .pi / bounds.size.width * i + offset * .pi * 2 / bounds.size.width)
                bezierSecondWave.addLine(to: CGPoint(x: i, y: orignOffY1))
            }

            bezierSecondWave.addLine(to: CGPoint(x: bounds.size.width * 1000, y: orignOffY1))
            bezierSecondWave.addLine(to: CGPoint(x: bounds.size.width * 1000, y: bounds.size.height))
            bezierSecondWave.addLine(to: CGPoint(x: 0, y: bounds.size.height))
            bezierSecondWave.addLine(to: CGPoint(x: 0, y: startOffY1))
            bezierSecondWave.close()

            secondWaveLayer.path = bezierSecondWave.cgPath
            secondWaveLayer.fillColor = secondWaveColor.cgColor
            secondWaveLayer.add(anim, forKey: "translate")
        }
    }
    
    func waveAnimationStart() {
        var waveHeight = self.waveHeight
        if progress == 0.0 || progress == 1.0 {
            waveHeight = 0.0
        }

        offset += speed

        let pathRef = CGMutablePath()
        let startOffY = waveHeight * sin(offset * .pi * 2 / bounds.size.width)
        var orignOffY: CGFloat = 0.0
        
        pathRef.move(to: .init(x: 0, y: startOffY))
        
        for i in stride(from: 0, to: bounds.size.width, by: 1) {
            orignOffY = waveHeight * sin(2 * .pi / bounds.size.width * i + offset * .pi * 2 / bounds.size.width) + yHeight
            pathRef.addLine(to: .init(x: i, y: orignOffY))
        }

        pathRef.addLine(to: .init(x: bounds.size.width, y: orignOffY))
        pathRef.addLine(to: .init(x: bounds.size.width, y: bounds.size.height))
        pathRef.addLine(to: .init(x: 0, y: bounds.size.height))
        pathRef.addLine(to: .init(x: 0, y: startOffY))
        
        pathRef.closeSubpath()

        firstWaveLayer.path = pathRef
        firstWaveLayer.fillColor = firstWaveColor.cgColor
        
//        CGPathRelease(pathRef)

        if !isShowSingleWave {
            let pathRef1 = CGMutablePath()
            let startOffY1 = waveHeight * sin(offset * .pi * 2 / bounds.size.width)
            var orignOffY1: CGFloat = 0.0
            
            pathRef.move(to: .init(x: 0, y: startOffY1))

            for i in stride(from: 0, to: bounds.size.width, by: 1) {
                orignOffY1 = waveHeight * cos(2 * .pi / bounds.size.width * i + offset * .pi * 2 / bounds.size.width) + yHeight
                pathRef.addLine(to: .init(x: i, y: orignOffY1))
            }

            pathRef.addLine(to: .init(x: bounds.size.width, y: orignOffY1))
            pathRef.addLine(to: .init(x: bounds.size.width, y: bounds.size.height))
            pathRef.addLine(to: .init(x: 0, y: bounds.size.height))
            pathRef.addLine(to: .init(x: 0, y: startOffY1))
            pathRef1.closeSubpath()

            secondWaveLayer.path = pathRef1
            secondWaveLayer.fillColor = secondWaveColor.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        firstWaveLayer.frame = bounds
        firstWaveLayer.anchorPoint = .zero
        secondWaveLayer.frame = bounds
        secondWaveLayer.anchorPoint = .zero
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        
        firstWaveLayer.removeFromSuperlayer()
        secondWaveLayer.removeFromSuperlayer()
    }
}
