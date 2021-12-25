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
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
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
    
    func startGame() {
        // 1. Find the url for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            //2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                //3. Split the string into an array of string, using line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                //4. Pick a random word, or use "paternal" as default
                rootWord = allWords.randomElement() ?? "paternal"
                
                //if we're here, it means everything has worked, so exit
                return
            }
        }
        
        //if we're here, then there is a problem - trigger crash and report error
        fatalError("Could not load start.txt from bundle.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
