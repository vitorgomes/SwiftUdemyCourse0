//
//  TrailerViewController.swift
//  TrailerFlix
//
//  Created by Vitor Gomes on 10/07/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import AVKit

class TrailerViewController: UIViewController {
    
    @IBOutlet weak var ivTrailer: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var viTrailer: UIView!
    
    var trailer: Trailer!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        preparePlayer()
        // Do any additional setup after loading the view.
    }
    
    func prepareView() {
        lbTitle.text = trailer.title
        lbYear.text = "\(trailer.year)"
        var rating = "Ainda nao avaliado"
        if trailer.rating > 0 {
            rating = ""
            for _ in 1...trailer.rating {
                rating += "⭐️"
            }
        }
        lbRating.text = rating
        ivTrailer.image = UIImage(named: trailer.poster + "-large")
    }
    
    func preparePlayer() {
        let url = URL(fileURLWithPath: trailer.url) // Criando uma URL
        player = AVPlayer(url: url) //Construindo o AVPlayer
        playerController = AVPlayerViewController() //Instanciando um novo AVPlayerViewController
        playerController.player = player //Definindo que o player do playerController vai ser a constante player
        playerController.showsPlaybackControls = true //Controlesdo video como por exemplo play, pause, etc.
        playerController.player?.play() //OBS: Ate o momento o video nao esta aparecendo, e necessario recuperar a sua view
        playerController.view.frame = viTrailer.bounds // Definindo que o tamanho da view vai ser do tamanho do outlet de viTrailer. Bounds e o frame interno da view, so que que x e y sao 0.
        viTrailer.addSubview(playerController.view) // Adicionando uma subview no viTrailer que vai ser a view gerada pelo playerController.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
