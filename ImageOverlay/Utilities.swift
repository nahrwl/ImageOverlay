//
//  Utilities.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit

extension CGSize {
    var isAspectRatio16_9: Bool {
        func gcd(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
            let r = a.truncatingRemainder(dividingBy: b)
            if r != 0 {
                return gcd(b, r)
            } else {
                return b
            }
        }
        let _gcd = gcd(self.width, self.height)
        return (self.width / _gcd, self.height / _gcd) == (16, 9)
    }
    func scaled(_ scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}

extension CGPoint {
        func scaled(_ scale: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * scale, y: self.y * scale)
    }
}

extension CGRect {
    func scaled(_ scale: CGFloat) -> CGRect {
        return CGRect(origin: origin.scaled(scale), size: size.scaled(scale))
    }
}

extension UIView {
    func removeAllChildren() {
        UIView.performWithoutAnimation {
            subviews.forEach { $0.removeAllChildren() }
            removeFromSuperview()
        }
    }
}

extension CALayer {
    func removeAllChildren() {
        UIView.performWithoutAnimation {
            if let sublayers = sublayers {
                sublayers.forEach { $0.removeAllChildren() }
            }
            removeFromSuperlayer()
        }
    }
}
