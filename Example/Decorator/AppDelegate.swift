import Decorator
import UIKit
import QuartzCore

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    lazy var labels: [UILabel]  = Array<Int>([0,1,2,3]).map({ self.getLabel(UIScreen.main.bounds.rectForLabel($0)) })
}

extension NSObject: DecorationCompatible {}

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
        view.prepare(look: 0, decoration: Look.backgroundLight + Look.fontTitle + Look.corners(rounded: false))
        view.prepare(look: 1, decoration: Look.backgroundLight + Look.fontTitle + Look.corners(rounded: true))
        view.prepare(look: 2, decoration: Look.backgroundLight + Look.fontNormal + Look.corners(rounded: false))
        view.prepare(look: 3, decoration: Look.backgroundLight + Look.fontNormal + Look.corners(rounded: true))
        view.prepare(look: 4, decoration: Look.backgroundDark + Look.fontTitle + Look.corners(rounded: false))
        view.prepare(look: 5, decoration: Look.backgroundDark + Look.fontTitle + Look.corners(rounded: true))
        view.prepare(look: 6, decoration: Look.backgroundDark + Look.fontNormal + Look.corners(rounded: false))
        view.prepare(look: 7, decoration: Look.backgroundDark + Look.fontNormal + Look.corners(rounded: true))
        view.text = "Some title"
        view.textAlignment = .center
        view.textColor = UIColor.orange
        view.frame = frame
        window?.rootViewController?.view.addSubview(view)
        return view
    }
    
    func prepareLabels() {
        Set<UILabel>(labels).decorator
            + Look.alpha
            + Look.backgroundDark
            + Look.fontNormal
        labels.forEach({ $0.look = Int(arc4random_uniform(8)) })
    }
}

struct Look {
    
    static var alpha: Decoration<UIView> {
        return { (view: UIView) -> Void in
            view.alpha = 0.8
        }
    }
    
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
                let rect = view.bounds
                let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: size)
                mask.path = path.cgPath
                view.layer.mask = mask
            default:
                view.layer.mask = nil
            }
        }
    }
}
