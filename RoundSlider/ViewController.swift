//
//  ViewController.swift
//  RoundSlider
//
//  Created by v.sova on 12.04.18.
//  Copyright © 2018 v.sova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let slider = RoundSlider.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(slider)
        slider.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

