//
//  Configuration.swift
//  Pensamentos
//
//  Created by Vitor Gomes on 24/05/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation

//Enum para ter certeza que nao vai errar a digitacao
enum UserDefaultKeys: String {
    case timeInterval = "timeInterval"
    case colorScheme = "colorScheme"
    case autorefresh = "autorefresh"
}

class Configuration {
    
    //Declaracao do userdefaults para salvar configuracoes quando abrir o app novamente
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    //Criando uma variavel computada para a pagina configuracoes
    var timeInterval: Double{
        get {
            //Aqui ele pega a informacao usando o metodo da classe UserDefaults, precisa de uma chave e informacao (substituida pelo enum nesse caso), como um dicionario
            return defaults.double(forKey: UserDefaultKeys.timeInterval.rawValue)
        }
        set {
            //Para inserir o valor, usa-se outro metodo da classe UserDetaults, "newValue" sera o valor pego
            defaults.set(newValue, forKey: UserDefaultKeys.timeInterval.rawValue)
        }
    }
    
    var colorScheme: Int{
        get {
            return defaults.integer(forKey: UserDefaultKeys.colorScheme.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.colorScheme.rawValue)
        }
    }
    
    var autorefresh: Bool{
        get {
            return defaults.bool(forKey: UserDefaultKeys.autorefresh.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultKeys.autorefresh.rawValue)
        }
    }
    
    private init() {
        //colorScheme por ser um inteiro ja retorna 0 caso nao tenha nenhum valor
        //Mesma coisa o autorefresh que e um double, ele ja retorna false caso nao tenha valores
        if defaults.double(forKey: UserDefaultKeys.timeInterval.rawValue) == 0 {
            defaults.set(8.0, forKey: UserDefaultKeys.timeInterval.rawValue)
        }
    }
}
