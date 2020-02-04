//
//  SwiftUITabbar.swift
//  SSCustomTabbar
//
//  Created by Ketan Chopda on 31/12/19.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
/// Tab bar configuartion
public class SSTabConfiguration {
    
    /// Bar height
    public var barHeight: CGFloat?
    
    /// Up Animation point
    public var upAnimationPoint: CGFloat?
    
    /// Layer fill color
    public var layerFillColor: UIColor
    
    /// Wave Height
    public var waveHeight: CGFloat
    
    /// Selected tab tint color
    public var selectedTabTintColor: UIColor
    
    /// UnSelected tab tint color
    public var unselectedTabTintColor: UIColor
    
    /// Shadow Color
    public var shadowColor: UIColor
    
    /// Shadow Radius
    public var shadowRadius: CGFloat
    
    /// Shadow Offset
    public var shadowOffset: CGSize
    
    /// Initializer for Tabbar configuration
    /// - Parameters:
    ///   - barHeight: Bar height
    ///   - upAnimationPoint: Up Animation Point
    ///   - layerFillColor: Layer Fill Color
    ///   - waveHeight: Wave Height
    ///   - selectedTabTintColor: Selected Tab TintColor
    ///   - unselectedTabTintColor: Unselected Tab TintColor
    ///   - shadowColor: Shadow Color
    ///   - shadowRadius: Shadow Radius
    ///   - shadowOffset: Shadow Offset
    public init(barHeight: CGFloat? = nil, upAnimationPoint: CGFloat? = nil, layerFillColor: UIColor = .white, waveHeight: CGFloat = 17, selectedTabTintColor: UIColor = UIColor.orange, unselectedTabTintColor: UIColor = .black, shadowColor: UIColor = .black, shadowRadius: CGFloat = .zero, shadowOffset: CGSize = CGSize(width: 0, height: -1)) {
        self.barHeight = barHeight
        self.upAnimationPoint = upAnimationPoint
        self.layerFillColor = layerFillColor
        self.waveHeight = waveHeight
        self.selectedTabTintColor = selectedTabTintColor
        self.unselectedTabTintColor = unselectedTabTintColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
    
}

@available(iOS 13.0, *)
/// SwiftUI Tab View
public struct SwiftUITabView {
    
    /// Content View controller
    let contentVC: UIViewController
    
    /// Title
    let title: String
    
    /// Selected image name
    let selectedImage: String
    
    /// UnSelected image name
    let unSelectedImage: String
    
    /// SwiftUI Tabview initializer
    /// - Parameters:
    ///   - content: Content View controller
    ///   - title: Title
    ///   - selectedImage: Selected image name
    ///   - unSelectedImage: Unselected Image name
    public init(content: UIViewController, title: String, selectedImage: String, unSelectedImage: String) {
        self.contentVC = content
        self.title = title
        self.selectedImage = selectedImage
        self.unSelectedImage = unSelectedImage
    }
    
}

@available(iOS 13.0, *)
/// SwiftUI TabBarController
public struct SwiftUITabBarController: UIViewControllerRepresentable {
    
    /// Tab Items
    private var tabItems: [SwiftUITabView]
    
    /// Configuration
    @Binding private var configuration: SSTabConfiguration
    
    /// Should hide tab bar
    @Binding private var isTabBarHidden: Bool
    
    // MARK: - Private declration
    private let tabBarVC: SSCustomTabBarViewController
    private let tabBar: SSCustomTabBar
    
    static private let bundle: Bundle = {
        return Bundle(for: SwiftUITabBarController.SSBundle.self)
    }()
    
    private class SSBundle {}
    
    // MARK: - Initializers
    
    /// SwiftUI Tabbar view controller
    /// - Parameters:
    ///   - tabItems: Array of TabItems of type SwiftUITabView
    ///   - configuration: Tabbar configuration
    ///   - isTabBarHidden: Should show tab bar
    public init(tabItems: [SwiftUITabView], configuration: Binding<SSTabConfiguration>, isTabBarHidden: Binding<Bool>) {
        self.tabItems = tabItems
        let storyboard = UIStoryboard(name: SSConstants.swiftUISupportStoryboard, bundle: SwiftUITabBarController.bundle)
        if let tabVC = storyboard.instantiateViewController(withIdentifier: SSConstants.swiftUISupportVC) as? SSCustomTabBarViewController {
            let viewControllers: [UIViewController] = tabItems.map {
                let vc = $0.contentVC
                vc.tabBarItem = UITabBarItem(title: $0.title, image: UIImage(named: $0.unSelectedImage), selectedImage: UIImage(named: $0.selectedImage))
                return vc
            }
            tabVC.viewControllers = viewControllers
            self.tabBarVC = tabVC
            self.tabBar = tabVC.tabBar as? SSCustomTabBar ?? SSCustomTabBar()
        } else {
            let tabBarController = SSCustomTabBarViewController()
            self.tabBarVC = tabBarController
            self.tabBar = tabBarController.tabBar as? SSCustomTabBar ?? SSCustomTabBar()
        }
        self._configuration = configuration
        self._isTabBarHidden = isTabBarHidden
    }
    
    public func makeUIViewController(context: Context) -> UITabBarController {
        return tabBarVC
    }
    
    public func updateUIViewController(_ tabBarConroller: UITabBarController, context: Context) {
        if let barHeight = configuration.barHeight {
            tabBarVC.barHeight = barHeight
        }
        if let upAnimationPoint = configuration.upAnimationPoint {
            tabBarVC.upAnimationPoint = upAnimationPoint
        }
        tabBar.layerFillColor = configuration.layerFillColor
        tabBar.waveHeight = configuration.waveHeight
        tabBar.unselectedTabTintColor = configuration.unselectedTabTintColor
        tabBar.shadowColor = configuration.shadowColor
        tabBar.shadowRadius = configuration.shadowRadius
        tabBar.shadowOffset = configuration.shadowOffset
        tabBar.tintColor = configuration.selectedTabTintColor
        tabBar.isHidden = isTabBarHidden
    }
    
    public static func refreshViews() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: SSConstants.updateViewNotification), object: nil))
        }
    }
    
}
