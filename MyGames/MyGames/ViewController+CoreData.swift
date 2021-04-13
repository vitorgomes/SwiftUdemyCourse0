//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Vitor Gomes on 23/06/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import CoreData

//Curiosidade: As primeiras duas letras de uma classe representam o framework que elas foram importadas "UI" vem de UIKit. NS significa "NextStep" que e a empresa que o Steve Jobs criou quando saiu da Apple, responsavel por criar o Objective C tambem

//E no persisten container que possui o contexto. Mas pra isso o arquivo AppDelegate toda hora vai precisar ser acessado. Entao criamos essa extension para facilitar a vida de todas as controllers que vao precisar acessar
extension UIViewController {
    
    //Criando uma variavel computada para representar o contexto
    var context: NSManagedObjectContext { //NSManagedObjectContext e a classe que representa um contexto no CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Criando uma constante que vai representar a classe AppDelegate. Chama-se a classe maior do app que e a UIAppliation, criancdo um singleton dela com o shared, e chamando um delegate generico que vai ser tratado (as!) como a classe AppDelegate
        return appDelegate.persistentContainer.viewContext //Retornando o contexto criado no CoreData Stack
    }
    

}
