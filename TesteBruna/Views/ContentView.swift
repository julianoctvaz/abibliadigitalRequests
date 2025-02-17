//
//  ContentView.swift
//  TesteBruna
//
//  Created by Juliano on 10/02/25.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @State private var verseInfo: String? = "Ainda sem resposta especifica\n"
    @State private var verseInfo2: String? = "Ainda sem resposta aleatoria\n"
    @State private var token: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHIiOiJUdWUgRmViIDExIDIwMjUgMDA6MzM6NTUgR01UKzAwMDAuYnJ1bmF2ZWlnYWNoYWxlZ3JlMkBnbWFpbC5jb20iLCJpYXQiOjE3MzkyMzQwMzV9.s2SLSwc2A1STHxEcCxT-IG4eUt6BR_01ThbWUjpRq3I"
    //coloca depois de criar user!!!
    
    var body: some View {
        VStack {
            Button(
                action: {
                    //                    createUser(name: "Juliano Vaz",
                    //                               email: "julianoctvaz@gmail.com",
                    //                               password: "123456",
                    //                               notifications: true)
                    
                    getSpecificVerse(version: "nvi",
                                     abbrev: "sl",
                                     chapter: 23,
                                     verse: 1)
                    
                    getRandomVerse()
                },
                label: {
                    HStack(alignment: .top, spacing: 4) {
                        Text("me dê algo")
                    }
                }
            )
            .buttonStyle(.borderedProminent)
            
            Divider()
            
            VStack (alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "book.fill")
                    Text(verseInfo ?? "N/A")
                }
                
                Text("\n---------------------------------\n")
                
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "book.fill")
                    Text(verseInfo2 ?? "N/A")
                }
                
            }
            .frame(maxWidth: 300, minHeight: 20, alignment: .leading)
        }
    }
    
    private func createUser(name: String,
                            email: String,
                            password: String,
                            notifications: Bool) {
        
        AuthService().createUserToPerformRequests(
            name: name,
            email: email,
            password: password,
            notifications: notifications
        ) { token, error in
            
            if let token = token {
                print("Usuário criado com sucesso!")
                print("Seu token de autenticação:", token)
                print("\n---------------------------------\n")
                self.token = token
                
            } else if let error = error {
                print("Erro ao criar usuário ou usuário já existe, verifique a resposta do servidor antes de tentar novamente. Erro:", error.localizedDescription)
                print("\n---------------------------------\n")
            }
        }
    }
    
    private func getSpecificVerse(version: String,
                                  abbrev: String,
                                  chapter: Int,
                                  verse: Int) {
        
        BibleService().requestSpecificVerse(
            version: version,
            abbrev: abbrev,
            chapter: chapter,
            verse: verse
        ) {
            bibleResponse, error in
            
            if let bibleResponse = bibleResponse {
                printBibleResponse(bibleResponse, BibleService.specific)
                
            } else if let error = error {
                print("Erro:", error.localizedDescription)
            }
        }
    }
    
    private func getRandomVerse() {
        
        BibleService().requestDataRandom { bibleResponse, error in
            
            if let bibleResponse = bibleResponse {
                printBibleResponse(bibleResponse, BibleService.random)
                
            } else if let error = error {
                print("Erro:", error.localizedDescription)
            }
        }
    }
    
    private func printBibleResponse(_ bibleResponse: BibleResponse, _ function: String) {
        print("\n---------------------------------\n")
        print("📖 \(bibleResponse.book.name) \(bibleResponse.chapter):\(bibleResponse.number) - \(bibleResponse.text)")
        if function == "specific" {
            verseInfo = "\(bibleResponse.book.name) \(bibleResponse.chapter):\(bibleResponse.number) - \(bibleResponse.text)"
        } else if function == "random" {
            verseInfo2 = "\(bibleResponse.book.name) \(bibleResponse.chapter):\(bibleResponse.number) - \(bibleResponse.text)"
        }
        print("\n---------------------------------\n")
    }
    
}


#Preview {
    ContentView()
}
