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
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
//    @State private var scoreTitle = ""
//    @State private var showingScore = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
                Section {
                    Text("Total score is: \(score)")
                        //.foregroundColor(.white)
                        .font(.title.weight(.medium))
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Restart", action: reset)
                    .font(.title2)
            }
        }

    }
    
    func addNewWord() {
        //lowercase and trim the word; to avoid duplicates
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Challenge #1
        guard answer != rootWord else {
            wordError(title: "Cannot use '\(rootWord)' as a start word", message: "Try again!")
            score -= 1
            return
        }
        //exit if remaining string is empty
        guard answer.count > 2 else {
            wordError(title: "Word is too short", message: "Try a longer word")
            score -= 1
            return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word has already been used!", message: "Get creative")
            score -= 1
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible!", message: "It's impossible to spell that word from '\(rootWord.uppercased())'")
            score -= 1
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized!", message: "This isn't an English word")
            score -= 1
            return
        }
        
        //animation
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        if answer.count >= 5 {
            score += 3
        } else if answer.count == 4 {
            score += 2
        } else {
            score += 1
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
    
    //Is the word original? Hasn't been used already...
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    //Is the word possible?
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
            
        }
        return true
    }
    
    //Is the word an actual English word?
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound //meaning its a valid English word
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    //Challenge
    func reset() {
        usedWords = [String]()
        score = 0
        startGame()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
