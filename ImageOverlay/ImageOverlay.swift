//
//  ImageOverlay.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVFoundation
import UIKit

extension UIImageView: NameSpaceCompatible { }

private struct AssociatedKeys {
    static var overlayContentView = "ImageOverlay.overlayContentView"
}

extension NameSpace where Base: UIImageView {
    public func clearOverlays() {
        if #available(tvOS 11.0, *) {
            base.overlayContentView.removeAllChildren()
            base.overlayContentView.layer.removeAllChildren()
            base.image = nil
        } else {
            base.image = nil
        }
    }
    public func addOverlays(with image: UIImage, overlays: [OverlayProtocol]) {
        let size = base.bounds.size
        if #available(tvOS 11.0, *) {
            let layersAsImage = overlays.filter { $0.needsRendering }.flatMap { $0.layers }
            let layersAsOverlay = overlays.filter { !$0.needsRendering }.flatMap { $0.layers }
            if layersAsImage.isEmpty {
                base.addOverlays(layers: layersAsOverlay, image: image)
            } else {
                DispatchQueue.global().async {
                    guard let packaged = image.packaged(layers: layersAsImage, size: size) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.base.addOverlays(layers: layersAsOverlay, image: packaged)
                    }
                }
            }
        } else {
            let layers: [CALayer] = overlays.flatMap { $0.layers }
            DispatchQueue.global().async {
                guard let packaged = image.packaged(layers: layers, size: size) else {
                    return
                }
                DispatchQueue.main.async {
                    self.base.image = packaged
                }
            }
        }
    }
    public var overlayContentView: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayContentView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let image = base.image, let view = newValue {
                addOverlays(with: image, overlays: [AnyViewAsOverlay(view: view)])
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayContentView) as? UIView
        }
    }
}

extension UIImageView {
    @available(tvOS 11.0, *)
    func addOverlays(layers: [CALayer], image: UIImage) {
        let v = self.overlayContentView
        self.image = image
        v.clipsToBounds = false
        layers.forEach {
            v.layer.addSublayer($0)
        }
    }
}

extension UIImage {
    fileprivate func packaged(layers: [CALayer], size _size: CGSize) -> UIImage? {
        let scaledSize = _size.scaled(2)
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: scaledSize))
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.draw(in: rect)
            for layer in layers {
                layer.bounds = layer.frame // for OverlayViewProtocol support
                layer.render(in: context)
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

