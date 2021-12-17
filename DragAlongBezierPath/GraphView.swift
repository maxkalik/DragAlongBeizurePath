//
//  GraphView.swift
//  DragViewAlongBezierPath
//
//  Created by Maksim Kalik on 12/16/21.
//

import UIKit

class GraphView: UIView {
    
    private lazy var startPoint: CGPoint = CGPoint(x: frame.width - 30, y: 60) // top
    private lazy var controlPoint1: CGPoint = CGPoint(x: frame.width - 200, y: 60)
    private lazy var controlPoint2: CGPoint = CGPoint(x: 200, y: 300)
    private lazy var endPoint: CGPoint = CGPoint(x: 30, y: 300) // bottom
    
    private lazy var bezierPath: UIBezierPath = {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        return path
    }()
    
    private let markerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    private var bezierPathYMax: CGFloat {
        endPoint.y - startPoint.y
    }

    var initialPosition: Float?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupGestuireRecongnizer()
        setupMarkerView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setupBezierPath()
        setupInitialPositionOfMarkerView()
    }
}

// MARK: - Setup

private extension GraphView {
    func setupGestuireRecongnizer() {
        let gesutre = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        addGestureRecognizer(gesutre)
    }

    func setupMarkerView() {
        addSubview(markerView)
        setupMarkerViewConstrains()
    }
    
    func setupInitialPositionOfMarkerView() {
        guard let position = self.initialPosition else {
            markerView.center = startPoint
            return
        }
        moveMarkerView(in: position)
    }

    func setupBezierPath() {
        UIColor.gray.setStroke()
        bezierPath.lineWidth = 2
        bezierPath.stroke()
    }
}

// MARK: - Calculations

private extension GraphView {
    
    // Get from: http://ericasadun.com/2013/03/25/calculating-bezier-points/
    func getPointAtPercent(t: Float, start: Float, c1: Float, c2: Float, end: Float ) -> Float {
        let t_: Float   = 1.0 - t
        let tt_: Float  = t_ * t_
        let ttt_: Float = t_ * t_ * t_
        let tt: Float   = t * t
        let ttt: Float  = t * t * t

        return start * ttt_
            + 3.0 * c1 * tt_ * t
            + 3.0 * c2 * t_ * tt
            + end * ttt
    }
    
    
    @objc func onPan(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self)
        let distanceY = point.y - startPoint.y
        var distanceYInRange = distanceY / bezierPathYMax
        distanceYInRange = distanceYInRange > 0 ? distanceYInRange : -distanceYInRange

        moveMarkerView(in: Float(distanceYInRange))
    }

    func moveMarkerView(in distance: Float) {
        if distance >= 1 || distance <= 0 { return }
        
        let xPosition = getPointAtPercent(t: distance, start: Float(startPoint.x), c1: Float(controlPoint1.x), c2: Float(controlPoint2.x), end: Float(endPoint.x))
        let yPosition = getPointAtPercent(t: distance, start: Float(startPoint.y), c1: Float(controlPoint1.y), c2: Float(controlPoint2.y), end: Float(endPoint.y))
        
        markerView.center = CGPoint(x: CGFloat(xPosition), y: CGFloat(yPosition))

        initialPosition = distance
        let actualIndex: Int = Int(Double(items.count - 1) * Double(distance))
        print(items[actualIndex])
    }
}

// MARK: - Constrains

private extension GraphView {
    func setupMarkerViewConstrains() {
        markerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            markerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            markerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            markerView.widthAnchor.constraint(equalToConstant: 30),
            markerView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
