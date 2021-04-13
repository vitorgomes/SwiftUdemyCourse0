//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Vitor Gomes on 09/06/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
}

class PlaceFinderViewController: UIViewController {

    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Criando um gesto que o usuario pode fazer no mapa (no nosso caso, segurar por 2 segundos). Gestures podem ser adicionados via mainstoryboard tambem.
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0 //Tanto de tempo que vai necessitar manter pressionado
        mapView.addGestureRecognizer(gesture) //Onde o gesto vai ser feito
    }
    
    //Funcao usada para recuperar a localizacao de onde o usuario tocou
    //Quando se usa #selector, ele obriga a reservervar para objective c tambem porque tem aplicacoes que trabalham com swift e objective c
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {  //Validacao pra ver se o usuario fez o gesto completo
            load(show: true)
            let point = gesture.location(in: mapView) //Pegando a localizacao que o usuario tocou da view tocada (no caso o mapView) e devolvendo em coordenadas x e y. X E Y ESTAO EM MEDIDAS DE TELA POR CAUSA DESSE METODO. PRECISAM SER CONVERTIDAS EM LATITUDE E LONGITUDE
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView) //Convertendo as coordenadas de point em latitude e longitude
            //Aqui esta se pegando uma localizacao e tentando converter para um placemark para o geocoder
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                //Aqui poderia ter sido criado um metodo pois o codigo se repete abaixo
                self.load(show: false)
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        //Erro comum de nao encontrar o nome
                        self.showMessage(type: .error("Nao foi encontrado nenhum local com esse nome digitado"))
                    }
                } else { //Se error nao vier nulo, algum erro desconhecido apareceu
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
        }
    }
    
    @IBAction func findCity(_ sender: UIButton) {
        tfCity.resignFirstResponder()
        let address = tfCity.text!
        load(show: true)
        let geoCorder = CLGeocoder()
        geoCorder.geocodeAddressString(address) { (placemarks, error) in
            self.load(show: false)
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                    //Erro comum de nao encontrar o nome
                    self.showMessage(type: .error("Nao foi encontrado nenhum local com esse nome digitado"))
                }
            } else { //Se error nao vier nulo, algum erro desconhecido apareceu
                self.showMessage(type: .error("Erro desconhecido"))
            }
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        //Mostrando a regiao pesquisada no mapView(mapinha)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        mapView.setRegion(region, animated: true)
        
        self .showMessage(type: .confirmation(place.name)) //Perguntando se o usuario deseja salvar a localidade pesquisada
        
        return true
    }
    
    func showMessage(type: PlaceFinderMessageType) {
        let tittle: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
            case .confirmation(let name):
                tittle = "Local encontrado"
                message = "Deseja adicionar \(name)"
                hasConfirmation = true
            case .error(let errorMessage):
                tittle = "Erro"
                message = errorMessage
        }
        
        //Criando um alerta
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil) //Criando botao cancel do alerta
        alert.addAction(cancelAction) // Adicionando o botao cancel ao alerta
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.delegate?.addPlace(self.place) // Criando botao de confirmacao
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(confirmAction) //Adicionando o botao de confirmacao do alerta
        }
        
        present(alert, animated: true, completion: nil) //Apresentando o alerta na tela
    }
    
    func load(show: Bool) {
        viLoading.isHidden = !show
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
