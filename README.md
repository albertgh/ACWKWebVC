# ACWKWebVC
Simple WKWebViewController

## Installing

Xcode > File > Swift Packages > Add Package Dependency

`https://github.com/albertgh/ACWKWebVC.git`


## Usage

```swift
import ACWKWebVC
```


```swift
let webVC: YourCustomizedWebVC = YourCustomizedWebVC(url: url)
webVC.overrideUserInterfaceStyle = .dark
webVC.title = ncTitle
webVC.progressY = 56.0
webVC.moreButtonEven = {
}
webVC.showBottomBar = true

let webNC = UINavigationController(rootViewController: webVC)
webNC.navigationBar.tintColor = .white
webNC.overrideUserInterfaceStyle = .dark
webNC.modalPresentationStyle = .pageSheet
webNC.modalTransitionStyle = .coverVertical
webNC.isModalInPresentation = isModalInPresentation
present(webNC, animated: true) { }
```


# Example Project

There's an example project available to try. Simply open the `ACWKWebVCExample-iOS.xcodeproj` from within the `Example` directory.


## Requirements

- iOS 13.0+
- Swift 5.0 or higher


## License
[**MIT**](https://github.com/albertgh/ACWKWebVC/blob/main/LICENSE)
