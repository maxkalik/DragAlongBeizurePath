//
//  ViewController.swift
//  DragAlongbezierPath
//
//  Created by SA on 7/8/17.
//  Copyright © 2017 Sris. All rights reserved.
//

import UIKit

let items: [Int] = [
    2700,
    1800,
    1600,
    1543,
    1000,
    800,
    600,
    400,
    200
]


class MainViewController: UIViewController {
    
    let graphView: GraphView = {
        let view = GraphView()
        view.initialPosition = 0.3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(graphView)
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
}
