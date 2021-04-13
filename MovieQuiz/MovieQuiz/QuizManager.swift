//
//  QuizManager.swift
//  MovieQuiz
//
//  Created by Vitor Gomes on 04/07/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation

typealias Round = (quiz: Quiz, options: [QuizOption])

class QuizManager {
    let quizes: [Quiz]
    let quizOptions: [QuizOption]
    var round: Round?
    var score: Int
    
    init() {
        score = 0
        let quizesURL = Bundle.main.url(forResource: "quizes", withExtension: "json")! //Recuperando a URL do arquivo
        do {
            let quizesData = try Data(contentsOf: quizesURL) // Criando o data
            quizes = try JSONDecoder().decode([Quiz].self, from: quizesData) //Decodificando o data num array de quiz
            let quizOptionsURL = Bundle.main.url(forResource: "options", withExtension: "json")!
            let quizOptionsData = try! Data(contentsOf: quizOptionsURL)
            quizOptions = try! JSONDecoder().decode([QuizOption].self, from: quizOptionsData)
        } catch {
            print(error.localizedDescription)
            quizes = []
            quizOptions = []
        }
    }
    
    func generateRandomQuiz() -> Round {
        let quizIndex = Int(arc4random_uniform(UInt32(quizes.count)))
        let quiz = quizes[quizIndex]
        var indexes: Set<Int> = [quizIndex] //Lembrando set e uma colecao nao ordenada de items do mesmo tipo que nao podem ser repetidos
        while indexes.count < 4 {
            let index = Int(arc4random_uniform(UInt32(quizes.count)))
            indexes.insert(index)
        }
        let options = indexes.map({quizOptions[$0]})
        round = (quiz, options)
        return round!
    }
    
    func checkAnswer(_ answer: String) {
        guard let round = round else {return}
        if answer == round.quiz.name {
            score += 1
        }
    }
}

struct Quiz: Codable {
    let name: String
    let number: Int
}

struct QuizOption: Codable {
    let name: String
}
