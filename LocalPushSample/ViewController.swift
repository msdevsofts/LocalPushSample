//
//  ViewController.swift
//  LocalPushSample
//
//  Created by M.S. on 2018/06/03.
//  Copyright © 2018年 M.S. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushTriggerTapped(_ sender: Any) {
        LocalNotificationController.notification(title: "タイトル", message: "内容", additionalData: ["data": "追加データ"])
    }
}

