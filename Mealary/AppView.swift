//
//  AppView.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            DiaryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Diary")
                }
            Text("Here are the foods.")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Foods")
                }
            Text("Here is the profile.")
                .tabItem {
                    Image(systemName: "person")
                    Text("You")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
