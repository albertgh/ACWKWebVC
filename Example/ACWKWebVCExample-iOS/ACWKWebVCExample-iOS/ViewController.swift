//
//  ViewController.swift
//  ACWKWebVCExample-iOS
//
//  Created by ac_m1a on 2020/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showEvent(_ sender: Any) {
        let testURL = URL(string: "https://github.com/albertgh/ACWKWebVC")
        self.ace_presentWebNC(with: testURL,
                              ncTitle: "Test",
                              isModalInPresentation: true,
                              needBottomToolBar: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

