//
//  ACWKWebVC.swift
//  InstaSlide
//
//  Created by ac_m1a on 2020/12/11.
//

import UIKit
import WebKit

open class ACWKWebVC: UIViewController {
    public static let barContentH: CGFloat = 56.0
    public static let barContentLeftRightSpace: CGFloat = 20.0

    public static let barButtonImageConfig: UIImage.Configuration = UIImage.SymbolConfiguration(pointSize: ACWKWebVC.barButtonIconEdge, weight: ACWKWebVC.barButtonWeight)
    public static let barButtonWeight: UIImage.SymbolWeight = .light
    public static let barButtonIconEdge: CGFloat = 24.0
    public static let barButtonFullEdge: CGFloat = 44.0
    public static let barButtonGap: CGFloat = 20.0

    // MARK: property
    public var webURL: URL?
    public let webView: WKWebView = WKWebView(frame: .zero)
    public var progressY: CGFloat = 0.0
    public let progressView: UIProgressView = UIProgressView(frame: .zero)
    
    public var showBottomBar: Bool = false {
        didSet {
            bottomBarWrapper.isHidden = !showBottomBar
            var currentWebContentInset = webView.scrollView.contentInset
            if showBottomBar {
                currentWebContentInset.bottom += ACWKWebVC.barContentH
            } else {
                currentWebContentInset.bottom -= ACWKWebVC.barContentH
            }
            webView.scrollView.contentInset = currentWebContentInset
            webView.scrollView.scrollIndicatorInsets = currentWebContentInset
        }
    }
    
    public let bottomBarWrapper: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        v.isHidden = true
        return v
    }()
    public let bottomBarContent: UIStackView = {
        let v = UIStackView()
        v.backgroundColor = .clear
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    public let backwardButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        let btnImg = UIImage(systemName: "chevron.left", withConfiguration: ACWKWebVC.barButtonImageConfig)
        btn.setImage(btnImg, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    public let forwardButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        let btnImg = UIImage(systemName: "chevron.right", withConfiguration: ACWKWebVC.barButtonImageConfig)
        btn.setImage(btnImg, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    public let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        let btnImg = UIImage(systemName: "square.and.arrow.up", withConfiguration: ACWKWebVC.barButtonImageConfig)
        btn.setImage(btnImg, for: .normal)
        return btn
    }()
    public let safariButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        let btnImg = UIImage(systemName: "safari", withConfiguration: ACWKWebVC.barButtonImageConfig)
        btn.setImage(btnImg, for: .normal)
        return btn
    }()
    
    public var moreButtonEven: (() -> Void)? {
        didSet {
            moreButton.isHidden = (moreButtonEven == nil)
        }
    }
    private let moreButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        let biConfig = UIImage.SymbolConfiguration(pointSize: 22.0)
        let btnImg = UIImage(systemName: "ellipsis", withConfiguration: biConfig)
        btn.setImage(btnImg, for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    public func openCurrentWebURLInSafari() {
        guard let url = self.webURL else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: Life Cycle
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(url: URL?) {
        webURL = url
        super.init(nibName: nil, bundle: nil)
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configVC()
        bindEvent()
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
}

// MARK: setup
extension ACWKWebVC {
    private func bindEvent() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if let url = webURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        moreButton.addTarget(self,
                             action: #selector(moreButtonTapped),
                             for: .touchUpInside)
        
        backwardButton.addTarget(self,
                                 action: #selector(backwardButtonTapped),
                                 for: .touchUpInside)
        forwardButton.addTarget(self,
                                action: #selector(forwardButtonTapped),
                                for: .touchUpInside)
        shareButton.addTarget(self,
                                action: #selector(shareButtonTapped),
                                for: .touchUpInside)
        safariButton.addTarget(self,
                                action: #selector(safariButtonTapped),
                                for: .touchUpInside)
    }
    
    private func configVC() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)

        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: progressY),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
        
        view.insertSubview(webView, belowSubview: progressView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(bottomBarWrapper)
        bottomBarWrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBarWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarWrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ACWKWebVC.barContentH),
            bottomBarWrapper.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        bottomBarWrapper.contentView.addSubview(bottomBarContent)
        bottomBarContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBarContent.leadingAnchor.constraint(equalTo: bottomBarWrapper.leadingAnchor, constant: ACWKWebVC.barContentLeftRightSpace),
            bottomBarContent.trailingAnchor.constraint(equalTo: bottomBarWrapper.trailingAnchor, constant: -ACWKWebVC.barContentLeftRightSpace),
            bottomBarContent.topAnchor.constraint(equalTo: bottomBarWrapper.topAnchor),
            bottomBarContent.heightAnchor.constraint(equalToConstant: ACWKWebVC.barContentH)
        ])
        
        bottomBarContent.addArrangedSubview(backwardButton)
        bottomBarContent.addArrangedSubview(forwardButton)
        bottomBarContent.addArrangedSubview(shareButton)
        bottomBarContent.addArrangedSubview(safariButton)
    }
}

// MARK: Delegate

extension ACWKWebVC: WKNavigationDelegate {
    public func webView(_ webView: WKWebView,
                        didFail navigation: WKNavigation!,
                        withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    public func webView(_ webView: WKWebView,
                        didFailProvisionalNavigation navigation: WKNavigation!,
                        withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    public func webView(_ webView: WKWebView,
                        didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        backwardButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    public func webView(_ webView: WKWebView,
                        didStartProvisionalNavigation navigation: WKNavigation!) {
    }
}

extension ACWKWebVC: WKUIDelegate {
    /*func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
     let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
     present(alert, animated: true, completion: nil)
     }
     
     func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
     let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
     present(alert, animated: true, completion: nil)
     }
     
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
     progressView.setProgress(0.0, animated: false)
     }*/
}

// MARK: Action

extension ACWKWebVC {
    @objc
    private func moreButtonTapped() {
        if let moreAction = moreButtonEven {
            moreAction()
        }
    }
    
    @objc
    private func backwardButtonTapped() {
        webView.goBack()
    }
    @objc
    private func forwardButtonTapped() {
        webView.goForward()
    }
    @objc
    private func shareButtonTapped() {
        guard let url = self.webURL else { return }
        let someText: String = self.webView.title ?? ""
        let objectsToShare: URL = url
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject, someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    @objc
    private func safariButtonTapped() {
        openCurrentWebURLInSafari()
    }
}
