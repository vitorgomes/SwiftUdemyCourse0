//
//  REST.swift
//  Carangas
//
//  Created by Vitor Gomes on 28/07/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false // Nao deixar a API ser usada enquanto estiver no plano de dados
        config.httpAdditionalHeaders = ["Content-type": "application/json"] // Colocando no cabecalho da sua request ao servidor que tipo de informacao vai ser requisitada
        config.timeoutIntervalForRequest = 30.0 // Significa que sua request vai ter 30 segundos para receber uma resposta, senao sera cancelada.
        config.httpMaximumConnectionsPerHost = 5 // Voce consegue fazer 5 tarefas de requisicoes nessa sessao.
        return config // Retornando para o configuration la de cima
    }() //Default e o tipo de sessao padrao. Ephemeral e quando e uma requisicao privada. E background e quando seu app faz uma sessao silenciosa, geralmente quando o app esta em segundo plano, nao esta sendo requisitado (Ex: Notificacoes, updates de informacoes, etc).
    
    private static let session = URLSession(configuration: configuration) // A sessao poderia ser configurada com o URLSession.shared, que o sistema configura de um jeito padrao. Esse outro jeito que fizemos e uma configuracao mais completa (criada do 0).
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        guard let url = URL(string: "https://fipeapi.appspot.com/api/1/carros/marcas.json") else {
            onComplete(nil)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("Algum status invalido pelo servidor")
                    onComplete(nil)
                }
            } else {
                onComplete(nil)
            }
        }
        dataTask.resume() // Metodo que executa
    }
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) { // Metodo de classe. E executado sem precisar estanciar a classe
        guard let url = URL(string: basePath) else {
            onError(.url) //Mandando os erros do enum para a closure do tableview (caso ocorra)
            return
        }
        
        // Quando se faz uma requisicao ao servidor e necessario usar uma dataTask. Ele nao EXECUTA a tarefa, ele CRIA.
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                } else {
                    print("Algum status invalido pelo servidor")
                    onError(.responseStatusCode(code: response.statusCode))
                }
            } else {
                // Isso e um erro do app, nao do servidor. Erros do servidor seram recebidos no URLResponse
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume() // Metodo que executa
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func applyOperation(car: Car, operation: RESTOperation, onComplete: @escaping (Bool) -> Void) {
        
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        var httpMethod: String = ""
        var request = URLRequest(url: url)
        
        switch operation {
            case .save:
                httpMethod = "POST"
            case .update:
                httpMethod = "PUT"
            case .delete:
                httpMethod = "DELETE"
        }
        
        request.httpMethod = httpMethod
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }// Esse metodo devolve um data, logo a constante "json" e um Data
        
        request.httpBody = json //Alimentando o corpo do request com o json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
