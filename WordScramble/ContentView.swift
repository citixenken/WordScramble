//
//  ContentView.swift
//  WordScramble
//
//  Created by Ken Muyesu on 23/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords: [String] = []
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle("rootWord")
            .onSubmit(addNewWord)
     }
    }
    
    func addNewWord() {
        //lowercase and trim the word; to avoid duplicates
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //exit if remaining string is empty
        guard answer.count > 0 else { return }
        
        //more validation here
        
        //animation
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
