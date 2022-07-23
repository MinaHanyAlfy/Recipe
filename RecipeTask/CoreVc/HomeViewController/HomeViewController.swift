//
//  HomeViewController.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import UIKit

class HomeViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let searchController : UISearchController = {
        let searchResultViewController = SearchResultViewController()
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "Search for a Food or a Recipe"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        registerCells()
    }

    private func registerCells(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    

}
extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Heelo"
        return cell
    }
    
    
}
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .yellow
        return cell

    }


}
