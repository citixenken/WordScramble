//
//  ContentView.swift
//  WordScramble
//
//  Created by Ken Muyesu on 23/12/2021.
//

import SwiftUI

struct ContentView: View {
    let series = ["The Wire", "WestWorld", "Mr. Robot", "Billions", "Game Of Thrones"]
    
    var body: some View {
        //        List {
        //            Section("Section 1") {
        //                Text("Static row 1")
        //                Text("Static row 2")
        //            }
        //
        //            Section("Section 2") {
        //                ForEach(0..<5) {
        //                    Text("Dynamic row \($0)")
        //                }
        //            }
        //
        //            Section("Section 3") {
        //                Text("Static row 3")
        //                Text("Static row 4")
        //            }
        //
        //
        //        }
        //        .listStyle(.grouped)
        
        //        List(0..<7) {
        //            Text("Number: \($0)")
        //        }
        
        List {
            Text("A Static Row")
            
            Spacer()
            
            ForEach(series, id: \.self) {
                Text($0)
            }
            
            Spacer()
            
            Text("Another Static Row")
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
