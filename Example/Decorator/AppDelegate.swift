import Decorator
import UIKit
import QuartzCore

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    lazy var labels: [UILabel]  = Array<Int>([0,1,2,3]).map({ self.getLabel(UIScreen.main.bounds.rectForLabel($0)) })
}

extension UILabel: DecoratorCompatible {}

extension CGRect {
    
    func rectForLabel(_ index: Int) -> CGRect {
        return CGRect(x: 40, y: CGFloat(index) * 60 + 30.0, width: width - 80, height: 40)
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        defer {
            prepareLabels()
        }
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        return true
    }
    
    func getLabel(_ frame: CGRect) -> UILabel {
        let view = UILabel()
        view.text = "Some title"
        view.textAlignment = .center
        view.textColor = UIColor.orange
        view.frame = frame
        window?.rootViewController?.view.addSubview(view)
        return view
    }
    
    func prepareLabels() {
        for index in 0 ... 3 {
            let label = labels[index]
            switch index {
            case 0:     label.decorator.apply(Style.backgroundDark, Style.fontNormal, Style.corners(rounded: false))
            case 1:     label.decorator.apply(Style.backgroundLight, Style.fontNormal, Style.corners(rounded: true))
            case 2:     label.decorator.apply(Style.backgroundDark, Style.fontTitle, Style.corners(rounded: true))
            case 3:     label.decorator.apply(Style.backgroundLight, Style.fontTitle, Style.corners(rounded: false))
            default:    break
            }
        }
    }
}

struct Style {
    
    static var backgroundDark: Decoration<UIView> {
        return { (view: UIView) -> Void in
            view.backgroundColor = UIColor.darkGray
        }
    }
    
    static var backgroundLight: Decoration<UIView> {
        return { (view: UIView) -> Void in
            view.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    static var fontNormal: Decoration<UILabel> {
        return { (view: UILabel) -> Void in
            view.font = UIFont.systemFont(ofSize: 14.0)
        }
    }
    
    static var fontTitle: Decoration<UILabel> {
        return { (view: UILabel) -> Void in
            if #available(iOS 8.2, *) {
                view.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold)
            } else {
                view.font = UIFont.boldSystemFont(ofSize: 17.0)
            }
        }
    }
    
    static func corners(rounded: Bool) -> Decoration<UIView> {
        return { [rounded] (view: UIView) -> Void in
            switch rounded {
            case true:
                let mask = CAShapeLayer()
                let size = CGSize(width: 10, height: 10)
                let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: size).cgPath
                mask.path = path
                view.layer.mask = mask
            default:
                view.layer.mask = nil
            }
        }
    }
}
