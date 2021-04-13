//
//  FinalViewController.swift
//  Fotoroid
//
//  Created by Vitor Gomes on 14/07/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import Photos //Framework necessario para quando se vai salvar uma foto

class FinalViewController: UIViewController {
    
    @IBOutlet weak var ivPhoto: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivPhoto.image = image
        ivPhoto.layer.borderWidth = 10
        ivPhoto.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    
    func saveToAlbum() {
        PHPhotoLibrary.shared().performChanges({ // Esse conceito e de criacao. Para uma imagem ser salva no album de fotos ela precisa ser criada la
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image) // Request de criar a imagem
            let addAssetRequest = PHAssetCollectionChangeRequest() // Request de adicionar a uma colecao
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset] as NSArray) //Addassets pede um array de imagens
        }) { (success, error) in
            if !success {
                print(error!.localizedDescription)
            } else {
                let alert = UIAlertController(title: "Imagem salva!", message: "Sua imagem foi salva no album de fotos", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
                case .authorized:
                    self.saveToAlbum()
                default:
                    let alert = UIAlertController(title: "ERRO", message: "Voce precisa autorizar o acesso ao album para salvar a foto", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true) // Sai de onde estiver voltando a primeira tela do app, pra tela root
    }
    
}
