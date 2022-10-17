//
//  SSCustomTabBarViewController.swift
//  SSCustomTabBar
//
//  Created by Sumit Goswami on 27/03/19.
//  Copyright © 2019 SimformSolutions. All rights reserved.
//

import UIKit


public class SSCustomTabBarViewController: UITabBarController {
    
    // MARK: - Overrides
    public override var selectedIndex: Int {
        didSet {
            guard let items = self.tabBar.items else { return }
            currentIndex = selectedIndex
            if items.indices.contains(selectedIndex) {
                let item = items[selectedIndex]
                self.tabBar(tabBar, didSelect: item)
            }
        }
    }
    
    public override var viewControllers: [UIViewController]? {
        didSet {
            setup()
        }
    }
    
    /// Tabbar height
    @IBInspectable var barHeight: CGFloat {
        get {
            return self.kBarHeight ?? self.tabBar.frame.height
        } set {
            self.kBarHeight = newValue
        }
    }
    
    /// icon up animation point
    @IBInspectable var upAnimationPoint: CGFloat {
        get {
            return self.kUpAnimationPoint
        } set {
            self.kUpAnimationPoint = newValue
        }
    }
    
    private var kBarHeight: CGFloat?
    private var kUpAnimationPoint: CGFloat = 20
    private var previousSelectedIndex: Int = 0
    
    var orderedTabBarItemViews: [UIView] {
        get {
            return tabBar.subviews.filter({ $0 is UIControl })
                .sorted(by: { $0.frame.minX < $1.frame.minX })
        }
    }
    
    private var currentIndex = 0
    private let animationDuration = 0.9
    private let animationSpring: CGFloat = 0.57
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setObserver()
        // Do any additional setup after loading the view.
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    /// - Parameter animated: variable for namiation
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    func setup() {
        guard let count = tabBar.items?.count, count > 0 else { return }
        if self.previousSelectedIndex == 0 {
            if let item = self.tabBar.selectedItem {
                self.tabBar(self.tabBar, didSelect: item)
            }
        }
        self.applicationDidBecomeActive()
    }
    
    /// setObserver
    func setObserver() {
        NotificationCenter.default.addObserver(self,selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: Notification.Name(rawValue: SSConstants.updateViewNotification), object: nil)
    }
    
    /// removeObserver
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// call when application become active
    @objc func applicationDidBecomeActive() {
        DispatchQueue.main.async { [weak self] in
            guard let uSelf = self else { return }
            let view = uSelf.getUpView(index: uSelf.currentIndex)
            if view.frame.origin.y > 0 {
                view.frame.origin.y -= uSelf.kUpAnimationPoint
            }
        }
    }
    
    deinit {
        self.removeObserver()
    }

}


// MARK: - set bar height
extension SSCustomTabBarViewController {

    override public func viewWillLayoutSubviews() {
        guard var height = kBarHeight else { return }
        height += self.view.safeAreaInsets.bottom
        var tabBarFrame = self.tabBar.frame
        tabBarFrame.size.height = height
        tabBarFrame.origin.y = UIScreen.main.bounds.height - height
        self.tabBar.frame = tabBarFrame
        self.tabBar.clipsToBounds = false
    }

}


// MARK: - Tabbar Delegate
extension SSCustomTabBarViewController {
    /// Sent to the delegate when the user selects a tab bar item.
    /// - Parameters:
    ///   - tabBar: The tab bar that is being customized.
    ///   - item: The tab bar item that was selected.
    override public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let uSelf = self.tabBar as? SSCustomTabBar,
              let items = uSelf.items,
              let index = items.firstIndex(of: item),
              index != self.previousSelectedIndex else { return }
        
        let width = UIScreen.main.bounds.width/CGFloat(items.count)
        let changeValue = (width*CGFloat(index+1))-(width/2)
        uSelf.animating = true
        
        orderedTabBarItemViews.forEach({ (objectView) in
            let objectIndex = orderedTabBarItemViews.firstIndex(of: objectView)
            if index == objectIndex {
                print(index)
            } else if objectIndex == previousSelectedIndex {
                UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: animationSpring, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                    objectView.frame = CGRect(x: objectView.frame.origin.x, y: objectView.frame.origin.y + self.kUpAnimationPoint, width: objectView.frame.width, height: objectView.frame.height)
                }, completion: nil)
            }
        })
        self.previousSelectedIndex = index
        performSpringAnimation(for: orderedTabBarItemViews[index], changeValue: changeValue)
        
        for (viewIndex, subViews) in self.tabBar.subviews.enumerated() {
            for badgeView in subViews.subviews {
                repositionBadgeView(badgeView, viewIndex == index ? -kUpAnimationPoint : 0)
            }
        }
    }
    
    /// Get specific view from
    /// - Parameter index: view index
    /// - Returns: specific view
    func getUpView(index: Int) -> UIView {
        return orderedTabBarItemViews[index]
    }
    
    /// Perform Animation
    /// - Parameters:
    ///   - view: going to up.
    ///   - changeValue: center location for wave.
    func performSpringAnimation(for view: UIView, changeValue: CGFloat) {
        guard let uSelf = self.tabBar as? SSCustomTabBar else { return }
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: animationSpring, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            if(uSelf.reverseCurveShape) {
                uSelf.setReverselayoutControlPoints(waveHeight: uSelf.minimalHeight, locationX: changeValue)
            } else {
                uSelf.setDefaultlayoutControlPoints(waveHeight: uSelf.minimalHeight, locationX: changeValue)
            }
            
        }, completion: { _ in
            uSelf.animating = false
        })
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: animationSpring, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y - self.kUpAnimationPoint, width: view.frame.width, height: view.frame.height)
        }, completion: nil)
    }
    
}

// MARK: - Badge related functions
extension SSCustomTabBarViewController {
    
    /// Reposition the badge view for tabbar item
    ///
    /// - Parameters:
    ///   - badgeView: The view of the badge
    ///   - yPosition: The change value in y axis
    func repositionBadgeView(_ badgeView: UIView, _ yPosition: CGFloat) {
        if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
            badgeView.layer.transform = CATransform3DIdentity
            badgeView.layer.transform = CATransform3DMakeTranslation(1.0, yPosition, 1.0)
        }
    }
    
    /// Add a badge value at provided index
    ///
    /// - Parameters:
    ///    - index: index of the tabbar item to set badge
    ///    - value: value to set as a badge
    open func addOrUpdateBadgeValueAtIndex(index: Int, value: String) {
        guard let item = getTabBarItemAtIndex(index) else { return }
        item.badgeValue = value
    }
    
    
    /// Remove a badge value at provided index
    ///
    /// - Parameters:
    ///    - index: index of the tabbar item to remove badge
    open func removeBadgeValueAtIndex(index: Int) {
        guard let item = getTabBarItemAtIndex(index) else { return }
        item.badgeValue = nil
    }
    
    
    /// Remove all badge values
    open func removeAllBadges() {
        guard let numberOfItems = self.tabBar.items?.count else { return }
        for index in 0...numberOfItems - 1 {
            getTabBarItemAtIndex(index)?.badgeValue = nil
        }
    }
    
    
    /// Provide a tabbar item at required index if present
    ///
    /// - Parameters:
    ///    - index: index of the tabbar item to get
    ///  - Return:TabBar item at the required index if present, otherwise returns nil
    private func getTabBarItemAtIndex(_ index: Int) -> UITabBarItem? {
        guard let items = self.tabBar.items else {
            return nil
        }
        guard items.indices.contains(index) else {
            return nil
        }
        return items[index]
    }
    
}
