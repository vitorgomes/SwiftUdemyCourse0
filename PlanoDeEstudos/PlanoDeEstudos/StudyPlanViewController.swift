//
//  StudyViewController.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.

import UIKit
import UserNotifications

class StudyPlanViewController: UIViewController {

    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    let sm = StudyManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dpDate.minimumDate = Date()
    }

    @IBAction func schedule(_ sender: UIButton) {
        let id = String(Date().timeIntervalSince1970)
        let studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        // Trabalhando de fato com notificacoes. OBS: Biblioteca UserNotifications deve ser importada
        let content = UNMutableNotificationContent()
        content.title = "Lembrete"
        content.subtitle = "Materia: \(studyPlan.course)"
        content.body = "Estudar \(studyPlan.section)"
        
        //content.sound = UNNotificationSound(named: "arquivo.caf")    Como se incluir sons nas notificacoes. Arquivos de extensoes .caf sao os mais recomendados. O arquivo deve estar no projeto do app.
        
        content.categoryIdentifier = "Lembrete"
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dpDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        sm.addPlan(studyPlan)
        navigationController!.popViewController(animated: true)
    }
    
}
