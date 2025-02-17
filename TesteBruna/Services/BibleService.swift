//
//  BibleService.swift
//  TesteBruna
//
//  Created by Juliano on 10/02/25.
//

import Foundation

class BibleService {
    
    static let random = "random" //poderia ser um enum tb essas variaveis abaixo
    static let specific = "specific"
    
    private let urlRandomVerse = "https://www.abibliadigital.com.br/api/verses/acf/random" //acf nvi
    private let urlSpecificVerse = "https://www.abibliadigital.com.br/api/verses"
    
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHIiOiJUdWUgRmViIDExIDIwMjUgMTI6NDg6NDIgR01UKzAwMDAuanVsaWFub2N0dmF6QGdtYWlsLmNvbSIsImlhdCI6MTczOTI3ODEyMn0.P5Q2Gx0fHALW_6u0_ok3HvZXiY8fKiHjyADRCbbFqpM" // precisa atualizar aqui dps que cria o user
    
    func requestDataRandom(completion: @escaping (BibleResponse?, Error?) -> Void) {
        
        guard let request = createRequest(urlChoosen: urlRandomVerse) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de status:", httpResponse.statusCode)
            }
            
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Nenhum dado recebido.")
                completion(nil, nil)
                return
            }
            
            do {
                let verse = try JSONDecoder().decode(BibleResponse.self, from: data)
                completion(verse, nil)
            } catch {
                print("Erro ao decodificar JSON:", error.localizedDescription)
                completion(nil, error)
            }
        }
        .resume()
    }
    
    public func requestSpecificVerse(
        version: String,
        abbrev: String,
        chapter: Int,
        verse: Int,
        completion: @escaping (BibleResponse?, Error?) -> Void
    ) {
        
        let urlCreated = createSpecificURL(version: version, abbrev: abbrev, chapter: chapter, verse: verse)
        
        guard let request = createRequest(urlChoosen: urlCreated) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de status:", httpResponse.statusCode)
            }
            
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Nenhum dado recebido.")
                completion(nil, nil)
                return
            }
            
            do {
                let verse = try JSONDecoder().decode(BibleResponse.self, from: data)
                completion(verse, nil)
            } catch {
                print("Erro ao decodificar JSON:", error.localizedDescription)
                completion(nil, error)
            }
        }
        .resume()
    }
    
    private func createRequest(urlChoosen: String) -> URLRequest? {
        
        guard let url = URL(string: urlChoosen) else {
            print("URL inválida")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Adicionando o token
        
        return request
    }
    
    private func createSpecificURL(version: String,
                                   abbrev: String,
                                   chapter: Int,
                                   verse: Int) -> String {
        return "\(urlSpecificVerse)/\(version)/\(abbrev)/\(chapter)/\(verse)"
    }
}
