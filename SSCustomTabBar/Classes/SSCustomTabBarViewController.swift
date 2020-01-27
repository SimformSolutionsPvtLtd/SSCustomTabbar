//
//  SSCustomTabBarViewController.swift
//  SSCustomTabBar
//
//  Created by Sumit Goswami on 27/03/19.
//  Copyright © 2019 SimformSolutions. All rights reserved.
//

import UIKit


/// Default index value for priviousSelectedIndex
private let defaultIndexValue = -1

public class SSCustomTabBarViewController: UITabBarController {
    
    // MARK: - Overrides
    
    public override var selectedIndex: Int {
        didSet {
            guard let items = self.tabBar.items else { return }
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
        get{
            return self.kBarHeight ?? self.tabBar.frame.height
        }
        set{
            self.kBarHeight = newValue
        }
    }
    
    /// icon up animation point
    @IBInspectable var upAnimationPoint: CGFloat {
        get{
            return self.kUpAnimationPoint
        }
        set{
            self.kUpAnimationPoint = newValue
        }
    }
    
    private var kBarHeight: CGFloat?
    
    private var kUpAnimationPoint: CGFloat = 20
    
    private var priviousSelectedIndex: Int = defaultIndexValue
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setObserver()
        // Do any additional setup after loading the view.
    }
    
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    ///
    /// - Parameter animated: variable for namiation
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    func setup() {
        guard let count = tabBar.items?.count, count > 0 else { return }
        if self.priviousSelectedIndex == defaultIndexValue {
            if let item = self.tabBar.selectedItem {
                self.tabBar(self.tabBar, didSelect: item)
            }
        }
        self.applicationDidBecomeActive()
    }
    
    
    /// setObserver
    func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
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
            let view = uSelf.getUpView(index: uSelf.selectedIndex)
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
    ///
    /// - Parameters:
    ///   - tabBar: The tab bar that is being customized.
    ///   - item: The tab bar item that was selected.
    override public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let uSelf = self.tabBar as? SSCustomTabBar, let items = uSelf.items, let index = items.firstIndex(of: item), index != self.priviousSelectedIndex {
            
            let width = UIScreen.main.bounds.width/CGFloat(items.count)
            let changeValue = (width*CGFloat(index+1))-(width/2)
            uSelf.animating = true
            
            let orderedTabBarItemViews: [UIView] = {
                let interactionViews = tabBar.subviews.filter({ $0 is UIControl })
                return interactionViews.sorted(by: { $0.frame.minX < $1.frame.minX })
            }()
            
            orderedTabBarItemViews.forEach({ (objectView) in
                let objectIndex = orderedTabBarItemViews.firstIndex(of: objectView)
                if index ==  objectIndex {
                    print(index)
                }else if  objectIndex == priviousSelectedIndex {
                    UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                        objectView.frame = CGRect(x: objectView.frame.origin.x, y: objectView.frame.origin.y + self.kUpAnimationPoint, width: objectView.frame.width, height: objectView.frame.height)
                    }, completion: nil)
                }
            })
            self.priviousSelectedIndex = index
            performSpringAnimation(for: orderedTabBarItemViews[index], changeValue: changeValue)
        }
        
    }
    
    
    /// Get specific view from
    ///
    /// - Parameter index: view index
    /// - Returns: specific view
    func getUpView(index: Int) -> UIView {
        let orderedTabBarItemViews: [UIView] = {
            let interactionViews = tabBar.subviews.filter({ $0 is UIControl })
            return interactionViews.sorted(by: { $0.frame.minX < $1.frame.minX })
        }()
        return orderedTabBarItemViews[index]
    }
    
    
    /// Perform Animation
    ///
    /// - Parameters:
    ///   - view: going to up.
    ///   - changeValue: center location for wave.
    func performSpringAnimation(for view: UIView, changeValue: CGFloat) {
        
        if let uSelf = self.tabBar as? SSCustomTabBar {
            UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
                uSelf.setDefaultlayoutControlPoints(waveHeight: uSelf.minimalHeight, locationX: changeValue)
                
            }, completion: { _ in
                uSelf.animating = false
            })
            UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y - self.kUpAnimationPoint, width: view.frame.width, height: view.frame.height)
            }, completion: nil)
        }
    }
    
}
