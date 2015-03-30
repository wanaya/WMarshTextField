//
//  ViewController.swift
//  WMarshTextField
//
//  Created by Guillermo Anaya Magallón on 30/03/15.
//  Copyright (c) 2015 wanaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let field = WMarshTextField(frame: CGRectMake(10, 100, 300, 40))
        field.wmInactiveColor = UIColor.whiteColor()
        field.wmActiveColor = UIColor.greenColor()
        field.placeholder = "User"
        self.view.addSubview(field)
        
    }

    
}

