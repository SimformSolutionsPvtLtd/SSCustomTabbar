//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by Ketan Chopda on 31/12/19.
//  Copyright © 2019 Simform. All rights reserved.
//

import SwiftUI
import SSCustomTabbar

struct PushedView: View {
    
    @Binding var isTabBarHidden: Bool
    @Binding var showPushedView: Bool
    
    var body: some View {
        Text("This is pushed view").onAppear {
            self.isTabBarHidden = true
        }
    }
    
}

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
        let tabBarView = SwiftUITabBarController(tabItems: [vc1, vc2, vc3, vc4, vc5], configuration: .constant(SSTabConfiguration(reverseCurve:true)), isTabBarHidden: self.$isTabBarHidden)
        return tabBarView
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
