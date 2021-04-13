//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Vitor Gomes on 23/06/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Game>! // Criando o cara que realmente vai fazer a requisicao no metodo "loadGames". Ele tambem usa generics
    var label = UILabel()//Declarando uma label para usar quando a lista nao tiver nenhum game cadastrado
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        label.text = "Voce nao tem jogos cadastrados"
        label.textAlignment = .center
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        loadGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            let vc = segue.destination as! GameViewController
            if let games = fetchedResultController.fetchedObjects {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    //Funcao que recupera os jogos e apresenta na tela
    func loadGames(filtering: String = "") { //Quando coloca um valor padra para os parametros do metodos ele pode ser chamado sem passar nada
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest() //NSFetchRequest trabalha com generics
        let sortDescritor =  NSSortDescriptor(key: "title", ascending: true) //Criando a ordenacao que ele vai trazer pelo banco. Por qual chave ele vai trazer e se vai ser ascendente ou nao
        fetchRequest.sortDescriptors = [sortDescritor]
        
        if !filtering.isEmpty {
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        //Duas maneiras de fazer a requisicao, usando somente o fetchrequest ou usando o fetchedresultcontroller. A vantagem do fetchedresultcontroller e que pode ser utilizado os delegates
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) //Qual a fetch request, qual o contexto, sectionNameKeyPath, significa se voce quer separar a tabela por algum atributo dela e "cacheName" seria se voce quer dar algum nome para o cache para traze-lo mais rapido da proxima vez que for solicitado
        fetchedResultController.delegate = self // Dizendo quem vai ser o delegate dele
        
        //Solicitando ao banco para devolver todos os jogos ordenados pelo titulo
        do {
            try fetchedResultController.performFetch() //Vai no contexto procurar as informacoes
        } catch {
            print(error.localizedDescription)
        }
        
    }

    // MARK: - Table view data source

    /* COMO SO TEM UMA SESSAO, ESSE METODO NAO E NECESSARIO
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = fetchedResultController.fetchedObjects?.count ?? 0 //Contando quantos objetos ele retornou. Ele e um optional, entao aqui esta dizendo que se ele retornar nulo, retorna 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell

        // Configure the cell...
        
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: game)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension GamesTableViewController: NSFetchedResultsControllerDelegate {
    //Esse metodo vai ser disparado toda vez que um objeto for alterado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //type e o tipo da mudanca que aconteceu
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
}
