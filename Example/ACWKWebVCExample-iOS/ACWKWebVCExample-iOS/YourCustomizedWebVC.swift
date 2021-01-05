//
//  YourCustomizedWebVC.swift
//  ACWKWebVCExample-iOS
//
//  Created by ac_m1a on 2020/12/23.
//

import UIKit

import ACWKWebVC


public struct CommonEvent {
    public static func webVCMoreEvent(from webVC: ACWKWebVC) -> (() -> Void) {
        let moreButtonEven = { [weak webVC] in
            guard let webVC = webVC else { return }
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Open in safari", style: .default, handler: { (alertAction) in
                webVC.openCurrentWebURLInSafari()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            }))
            webVC.present(alert, animated: true, completion: nil)
        }
        return moreButtonEven
    }
}

class YourCustomizedWebVC: ACWKWebVC {

    // MARK: property
    public var didClose: (() -> Void)?
    public let closeButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        btn.backgroundColor = .clear
        //btn.tintColor = .systemBlue
//        let biConfig = UIImage.SymbolConfiguration(pointSize: 24.0)
//        let btnImg = UIImage(systemName: "chevron.down", withConfiguration: biConfig)
        let btnImg = UIImage(named: "chevron_down")
        btn.setImage(btnImg, for: .normal)
        return btn
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        bindEvent()
    }
}

// MARK: setup

extension YourCustomizedWebVC {
    private func bindEvent() {
        closeButton.addTarget(self,
                              action: #selector(closeButtonTapped),
                              for: .touchUpInside)
    }
}

// MARK: Action

extension YourCustomizedWebVC {
    @objc
    private func closeButtonTapped() {
        self.dismiss(animated: true) {
            if let didDismiss = self.didClose {
                didDismiss()
            }
        }
    }
}

// MARK: convenience

extension UIViewController {
    public func ace_presentWebNC(with url: URL?,
                                 ncTitle: String?,
                                 isModalInPresentation: Bool = false,
                                 needBottomToolBar: Bool = false) {
        let webVC: YourCustomizedWebVC = YourCustomizedWebVC(url: url)
        //webVC.overrideUserInterfaceStyle = .dark
        webVC.title = ncTitle
        webVC.progressY = 56.0
        webVC.moreButton.tintColor = .darkGray
        webVC.moreButtonEven = CommonEvent.webVCMoreEvent(from: webVC)
        webVC.showBottomBar = needBottomToolBar
        let webNC = UINavigationController(rootViewController: webVC)
        //webNC.navigationBar.tintColor = .white
        //webNC.overrideUserInterfaceStyle = .dark
        webNC.modalPresentationStyle = .pageSheet
        webNC.modalTransitionStyle = .coverVertical
        if #available(iOS 13.0, *) {
            webNC.isModalInPresentation = isModalInPresentation
        } else {
            // Fallback on earlier versions
        }
        present(webNC, animated: true) {
            
        }
    }
}
