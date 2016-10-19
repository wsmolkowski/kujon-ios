//
// Created by Wojciech Maciejewski on 10/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SpinnerView : UIView {

    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }

    override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 3
        setPath()
    }

    override func didMoveToWindow() {
        animate()
    }

    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                    Pose(0.0, 0.000, 0.7),
                    Pose(0.6, 0.500, 0.5),
                    Pose(0.6, 1.000, 0.3),
                    Pose(0.6, 1.500, 0.1),
                    Pose(0.2, 1.875, 0.1),
                    Pose(0.2, 2.250, 0.3),
                    Pose(0.2, 2.625, 0.5),
                    Pose(0.2, 3.000, 0.7),
            ]
        }
    }

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let totalSeconds = type(of: self).poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in type(of: self).poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * CGFloat(M_PI))
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath("strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath("transform.rotation", duration: totalSeconds, times: times, values: rotations)

        animateStrokeHueWithDuration(totalSeconds * 5)
    }

    func animateKeyPath(_ keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = kCAAnimationLinear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

    func animateStrokeHueWithDuration(_ duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { keyTime in
            let keyTimeInterval = CFTimeInterval(keyTime)
            let countInterval = CFTimeInterval(count)
            return NSNumber(value:keyTimeInterval/countInterval)
        }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).cgColor
        }
        animation.duration = duration
        animation.calculationMode = kCAAnimationLinear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

}
