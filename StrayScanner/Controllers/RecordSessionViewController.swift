//
//  RecordSessionViewController.swift
//  Stray Scanner
//
//  Created by Kenneth Blomqvist on 11/28/20.
//  Copyright © 2020 Stray Robots. All rights reserved.
//

import Foundation
import UIKit
import Metal
import ARKit

let vertexData: [Float] = [
    -1.0, -1.0, 1.0, 1.0,
     1.0, -1.0, 1.0, 0.0,
    -1.0,  1.0, 0.0, 1.0,
     1.0,  1.0, 0.0, 0.0
]

let vertexIndices: [UInt16] = [
    0, 3, 1,
    0, 2, 3,
]

class RecordSessionViewController : UIViewController, ARSessionDelegate {
    private var timer: CADisplayLink!
    private let session = ARSession()
    private var renderer: CameraRenderer?

    override func viewDidLoad() {
        setViewProperties()
        session.delegate = self

        self.renderer = CameraRenderer(parentView: view)

        timer = CADisplayLink(target: self, selector: #selector(renderLoop))
        timer.add(to: RunLoop.main, forMode: .default)

        let arConfiguration = ARWorldTrackingConfiguration()
        if !ARWorldTrackingConfiguration.isSupported || !ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            print("AR is not supported.")
        } else {
            arConfiguration.frameSemantics.insert(.sceneDepth)
            session.run(arConfiguration)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        session.pause();
    }

    @objc func renderLoop() {
        autoreleasepool {
            guard let frame = session.currentFrame else { return }
            self.renderer!.render(frame: frame)
        }
    }
    private func setViewProperties() {
        view.backgroundColor = UIColor.black
        view.setNeedsDisplay()
    }
}
