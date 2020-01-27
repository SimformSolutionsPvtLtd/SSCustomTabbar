# SSCustomTabbar

> Simple Animated tabbar with native control.

[![Version](https://img.shields.io/cocoapods/v/SSCustomTabbar.svg?style=flat)](https://cocoapods.org/pods/SSCustomTabbar)
[![License](https://img.shields.io/cocoapods/l/SSCustomTabbar.svg?style=flat)](https://cocoapods.org/pods/SSCustomTabbar)
[![Platform](https://img.shields.io/cocoapods/p/SSCustomTabbar.svg?style=flat)](https://cocoapods.org/pods/SSCustomTabbar)
[![Swift Version][swift-image]][swift-url]
[![PRs Welcome][PR-image]][PR-url]

![Example](https://raw.githubusercontent.com/simformsolutions/SSCustomTabbar/master/SSCustomTabBar/Screenshots/customTabbar.gif)

## Requirements

- iOS 11.0+
- Xcode 10.0+

## Installation
SSCustomTabbar doesn't contain any external dependencies.

It is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SSCustomTabbar'
```

## UIKit Usage example

### Set UITabbarController to SSCustomTabBarViewController
![alt text](https://raw.githubusercontent.com/simformsolutions/SSCustomTabbar/master/SSCustomTabBar/Screenshots/SSCustomTabBarViewController.png)

### Set UITabBar to SSCustomTabBar
![alt text](https://raw.githubusercontent.com/simformsolutions/SSCustomTabbar/master/SSCustomTabBar/Screenshots/SSCustomTabBar.png)

## SwiftUI Usage example

    struct TabItem: View {
    
      var text: String
      @State var isNextActive: Bool = false
      @Binding var isTabBarHidden: Bool
    
      var body: some View {
         NavigationView {
               ZStack {
                  NavigationLink(destination: PushedView(isTabBarHidden: self.$isTabBarHidden, showPushedView: self.$isNextActive), isActive: self.$isNextActive) {
                       EmptyView()
                  }
                
                  VStack(spacing: 30) {
                    
                       Button(action: {
                           self.isNextActive = true
                       }) {
                           Text("Tap to Push")
                       }
                   }
               }.onAppear {
                   self.isTabBarHidden = false
               }
           }
      }
    
    }


    struct ContentView: View {
    
       @State var isTabBarHidden: Bool = false
    
       var body: some View {
           tabView
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                SwiftUITabBarController.refreshViews()
           }
       }
    
       var tabView: some View {
           let vc1 = SwiftUITabView(content: UIHostingController(rootView: TabItem(text: "Home", isTabBarHidden: self.$isTabBarHidden)), title: "Home", selectedImage: "iconHomeSelected", unSelectedImage: "iconHome")
           let vc2 = SwiftUITabView(content: UIHostingController(rootView: TabItem(text: "Favorite", isTabBarHidden: self.$isTabBarHidden)), title: "Favorite", selectedImage: "iconFavoriteSelected", unSelectedImage: "iconFavorite")
           let vc3 = SwiftUITabView(content: UIHostingController(rootView: TabItem(text: "Video", isTabBarHidden: self.$isTabBarHidden)), title: "Video", selectedImage: "iconVideoSelected", unSelectedImage: "iconVideo")
           let vc4 = SwiftUITabView(content: UIHostingController(rootView: TabItem(text: "Profile", isTabBarHidden: self.$isTabBarHidden)), title: "Profile", selectedImage: "iconProfileSelected", unSelectedImage: "iconProfile")
           let vc5 = SwiftUITabView(content: UIHostingController(rootView: TabItem(text: "Chat", isTabBarHidden: self.$isTabBarHidden)), title: "Chat", selectedImage: "iconChatSelected", unSelectedImage: "iconChat")
        
           let tabBarView = SwiftUITabBarController(tabItems: [vc1, vc2, vc3, vc4, vc5], configuration: .constant(SSTabConfiguration()), isTabBarHidden: self.$isTabBarHidden)
           return tabBarView
      }
    
    }

# Customization

You can change:
   - BarHeight
   - UnSelected item tint color
   - Wave Height
   - Animation point(Position)
   - Layer background color
   
![alt text](https://raw.githubusercontent.com/simformsolutions/SSCustomTabbar/master/SSCustomTabBar/Screenshots/barHeightAndUpanimationpoint.png)

![alt text](https://raw.githubusercontent.com/simformsolutions/SSCustomTabbar/master/SSCustomTabBar/Screenshots/layerColorWaveHightUnselectedTintColor.png)

![alt text](https://raw.githubusercontent.com/simformsolutions/SSCustomTabbar/master/SSCustomTabBar/Screenshots/Description.png)

## Contribute

We would love you for the contribution to SSCustomTabMenu, check the LICENSE file for more info.

## License

SSCustomTabbar is available under the MIT license. See the LICENSE file for more info.


[PR-image]:https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square
[PR-url]:http://makeapullrequest.com
[swift-image]:https://img.shields.io/badge/swift-4.2-orange.svg
[swift-url]: https://swift.org/
