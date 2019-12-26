//
//  ViewController.swift
//  SSCustomTabbar
//
//  Created by simformsolutions on 03/29/2019.
//  Copyright (c) 2019 simformsolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onTappedPush(_ sender: UIButton) {
        let newVC = UIViewController()
        newVC.view.backgroundColor = .red
        newVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newVC, animated: true)
    }

}

