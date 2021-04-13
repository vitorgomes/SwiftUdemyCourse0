//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by Vitor Gomes on 09/06/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    enum MapMessageType {
        case routeError
        case authorizationWarning
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var places: [Place]!
    var poi: [MKAnnotation] = []
    lazy var locationManager = CLLocationManager() // Com o uso de "lazy" o objeto so vai ser instanciado no momento em que ele for utilizado
    var btUserLocation: MKUserTrackingButton!
    var selectedAnnotation: PlaceAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.isHidden = true
        mapView.mapType = .mutedStandard
        viInfo.isHidden = true
        mapView.delegate = self
        locationManager.delegate = self
        
        //Mudando o titulo da area de pesquisa
        if places.count == 1 {
            title = places[0].name
        } else {
            title = "Meus lugares"
        }
        
        for place in places {
            addToMap(place)
        }
        
        configureLocationButton()
        
        showPlaces()
        requestUserLocationAuthorization()
    }
    
    func configureLocationButton() {
        btUserLocation = MKUserTrackingButton(mapView: mapView)
        btUserLocation.backgroundColor = .white
        btUserLocation.frame.origin.x = 10
        btUserLocation.frame.origin.y = 10
        btUserLocation.layer.cornerRadius = 5
        btUserLocation.layer.borderWidth = 1
        btUserLocation.layer.borderColor = UIColor(named: "main")?.cgColor
    }
    
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() { //CLLocationManager e a classe do corelocation que devolve um objeto da localizacao atual do device. Esse if esta avaliando se esta habilidado os servicos de localizacoes
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    //Mostrar o botao de localizacao no mapa
                    mapView.addSubview(btUserLocation)
                case .denied:
                    showMessage(type: .authorizationWarning)
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    break
            }
        } else {
            //nao daaaaa
        }
    }
    
    func addToMap(_ place: Place) {
        //Criando aqueles "pinos" que mostram os lugares no mapa
        let annotation = PlaceAnnotation(coordinate: place.coordinate, type: .place) //criando uma anotacao do tipo pino da classe PlaceAnnotation
        annotation.title = place.name //colocando um titulo
        annotation.address = place.address
        mapView.addAnnotation(annotation) //mostrando no mapa
    }
    
    //Metodo para mostrar todas as anotacoes. O mapView tenta criar uma area no mapa que engloba todas as anotacoes existentes
    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true) //mapView.annotations faz com que ele mostre todas anotacoes que ele mesmo possui
    }
    
    // Metodo para mostrar as informacoes da annotation
    func showInfo() {
        lbName.text = selectedAnnotation!.title
        lbAddress.text = selectedAnnotation!.address
        viInfo.isHidden = false
    }
    
    //Action para tracar a rota de onde ele esta ate uma annotation que ele clicar
    @IBAction func showRoute(_ sender: UIButton) {
        //Se o recurso de locazacao nao estiver autorizado no iPhone, ele manda mensagem de erro de autorizacao e encerra a action
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            showMessage(type: .authorizationWarning)
            return
        }
        //Como tracar a rota
        let request = MKDirections.Request() //Cria um objeto de request para os servidores da apple
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation!.coordinate)) //Pega o destino
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate)) //Coordenadas de onde o usuario se encontra
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                if let response = response {
                    self.mapView.removeOverlays(self.mapView.overlays)// Overlays sao informacoes que voce coloca em cima do mapa, pode ser ate imagens!!
                    
                    let route = response.routes.first!
                    print("Nome: ", route.name) //Nome da rota
                    print("Distancia: ", route.distance)
                    print("Duracao: ", route.expectedTravelTime)
                    print("==========")
                    
                    // Tambem e possivel coletar as instrucoes da rota para o usuario
                    for step in route.steps {
                        print("Em \(step.distance) metros, \(step.instructions)")
                    }
                    
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads) //Polyline e uma propriedade de uma linha poligonal do desenho da rota
                    var annotations = self.mapView.annotations.filter({!($0 is PlaceAnnotation)}) //Gambiarra para pegar todas as annotations, filtrar, e devolver as que nao sao placeannotations
                    annotations.append(self.selectedAnnotation!)
                    self.mapView.showAnnotations(annotations, animated: true)
                }
            } else {
                self.showMessage(type: .routeError)
            }
        }
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        searchBar.resignFirstResponder()
        searchBar.isHidden = !searchBar.isHidden
    }
    
    func showMessage(type: MapMessageType) {
        
        let tittle = type == .authorizationWarning ? "Aviso" : "Erro"
        let message = type == .authorizationWarning ? "Para utilizar os recursos de localizacao, voce precisa permitir na tela de Ajustes" : "Nao foi possivel encontrar a rota"
        
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil) //Criando botao cancel do alerta
        alert.addAction(cancelAction) // Adicionando o botao cancel ao alerta
        
        if type == .authorizationWarning {
            let confirmAction = UIAlertAction(title: "Ir para Ajustes", style: .default) { (action) in
                
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(confirmAction) //Adicionando o botao de confirmacao do alerta
        }
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension MapViewController: MKMapViewDelegate {
    //Metodo utilizado para modificar uma annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation) {
            return nil
        }
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = type == .place ? UIColor(named: "main") : UIColor(named: "poi")
        annotationView?.glyphImage = type == .place ? UIImage(named: "placeGlyph.png") : UIImage(named: "poiGlyph.png") //Nao deu certo usando imagem
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Instanciando um objeto do tipo MKMapCamera (para mostrar os edificios em 3D)
        let camera = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80 //Angulo da camera
        camera.altitude = 100
        mapView.setCamera(camera, animated: true) //Dizendo que esta camera vai ser usada no mapView do app
        
        selectedAnnotation = (view.annotation as! PlaceAnnotation)
        showInfo()
    }
    
    // Metodo que desenha overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)//Criando o redenrizador que vai criar o overlay, detalhe que o renderizador tem que ser do mesmo tipo que voce vai redenrizar, nesse caso, do tipo polyline
            renderer.strokeColor = UIColor(named: "main")?.withAlphaComponent(0.8)
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        loading.startAnimating()
        
        let request = MKLocalSearch.Request() //Os dados da requisicao da barra de pesquisa
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request) //Responsavel por EXECUTAR a requisicao
        search.start { (response, error) in
            if error == nil {
                guard let response = response else {
                    self.loading.stopAnimating()
                    return
                }
                self.mapView.removeAnnotations(self.poi)
                self.poi.removeAll()
                
                for item in response.mapItems {
                    let annotation = PlaceAnnotation(coordinate: item.placemark.coordinate, type: .poi)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    annotation.address = Place.getFormattedAddress(with: item.placemark)
                    self.poi.append(annotation)
                }
                self.mapView.addAnnotations(self.poi)
                self.mapView.showAnnotations(self.poi, animated: true)
            }
            self.loading.stopAnimating()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.showsUserLocation = true
                mapView.addSubview(btUserLocation)
                locationManager.startUpdatingLocation()
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last!)
    }
}
