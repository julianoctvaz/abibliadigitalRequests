//
//  AuthService.swift
//  TesteBruna
//
//  Created by Juliano on 10/02/25.
//

import Foundation

class AuthService {
    
    private let signUpURL = "https://www.abibliadigital.com.br/api/users"
    
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHIiOiJUdWUgRmViIDExIDIwMjUgMDA6MzM6NTUgR01UKzAwMDAuYnJ1bmF2ZWlnYWNoYWxlZ3JlMkBnbWFpbC5jb20iLCJpYXQiOjE3MzkyMzQwMzV9.s2SLSwc2A1STHxEcCxT-IG4eUt6BR_01ThbWUjpRq3I"
    
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
    
    private func createUserModel(name: String,
                                 email: String,
                                 password: String,
                                 notifications: Bool) -> UserRequest? {
        
        // Validação de senha mínima
        guard password.count >= 6 else {
            print("Erro: A senha deve ter pelo menos 6 caracteres.")
            return nil
        }
        
        return UserRequest(name: name,
                           email: email,
                           password: password,
                           notifications: notifications)
    }
    
    private func createRequest(userModel: UserRequest) -> URLRequest? {
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
            print("Erro ao codificar JSON")
            return nil
        }
        
        // Verificar JSON antes de enviar
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON Enviado:", jsonString)
        }
        
        guard let url = URL(string: signUpURL) else {
            print("URL inválida")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("MySwiftApp/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = jsonData
        
        return request
    }
    
    func createUserToPerformRequests(name: String,
                            email: String,
                            password: String,
                            notifications: Bool,
                            completion: @escaping (String?, Error?) -> Void) {
        
        
        guard let userModel = createUserModel(
            name: name,
            email: email,
            password: password,
            notifications: notifications
        ) else {
            print("Não foi possivel criar modelo de usuario")
            return
        }
        
        guard let request = createRequest(userModel: userModel) else {
            print("Não foi possivel criar request para criar usuario")
            return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de status:", httpResponse.statusCode)
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Resposta do servidor:", responseString)
            }
            
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                print("Erro completo:", error)
                completion(nil, error)
                return
            }
            
            guard let data else {
                print("Nenhum dado recebido.")
                completion(nil, nil)
                return
            }
            
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(userResponse.token, nil)
            } catch {
                completion(nil, error)
            }
        }
        .resume()
    }
}
