//
//  HomeViewController.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import UIKit
enum Filter: String {
    case all = "ALL"
    case low = "Low Suger"
    case keto = "Keto"
    case vegan = "Vegan"
}

protocol HomeViewProtocol: AnyObject {
    func recipeSuccess(recipes: [Hit])
    
    
}
class HomeViewController: UIViewController, HomeViewProtocol {
    private var recipeList: RecipeResponse?
    private var recipes: [Hit]?{
        didSet{
            DispatchQueue.main.async {[self] in
                if recipes?.count ?? 0 > 0 {
                    noRecipeView.alpha = 0
                    tableView.isHidden = false
                    self.tableView.reloadData()
                }else{
                    noRecipeView.alpha = 1
                    tableView.isHidden = true
                    self.tableView.reloadData()
                }
              
            }
            
        }
    }
    private var noRecipeView: ZeroStateView = {
        let view = ZeroStateView()
        view.label.text = "There's No Results.\nPlease, Recheck Your Connection."
        return view
    }()
    private var filter: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: HomeViewModelProtocol!
    var isSearched: Bool = false
    private let searchController : UISearchController = {
        let searchResultViewController = SearchResultViewController()
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "Search for a Food ingredient or a Recipe"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiHandler()
        listViewHandler()
        noRecipeViewHandler()
        viewModel = HomeViewModel(view: self)
        viewModel.fetchRecipesDefault(isPagination: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noRecipeView.center = view.center
    }
    private func uiHandler(){
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
    }
    private func registerCells(){
        tableView.register(UINib(nibName: RecipeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecipeTableViewCell.identifier)
        collectionView.register(UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
    }
    
    private func listViewHandler(){
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        registerCells()
    }
    func recipeSuccess(recipes: [Hit]) {
        self.recipes = recipes
    }
    
    private func noRecipeViewHandler(){
        noRecipeView = ZeroStateView(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.width/2))
        noRecipeView.label.text = "There's No Results.\nPlease, Recheck Your Connection."
        noRecipeView.alpha = 1
        view.addSubview(noRecipeView)
    }
    
    
    
}


//MARK: - For Handling Recipe List
extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as? RecipeTableViewCell,let recipe = recipes?[indexPath.row].recipe else {return UITableViewCell()}
        
        cell.configure(recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "recipeDetails", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let recipes = recipes else{return}
        if indexPath.row == recipes.count - 1{
            moreRecipes()
        }
    }
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recipe = recipes?[sender as? Int ?? 0].recipe  else{return}
        let destinationVC = segue.destination as? RecipeDetailsViewController
        destinationVC?.recipe = recipe
    }
    
    
    func moreRecipes(){
        viewModel.fetchRecipesDefault(isPagination: true)
    }
    
    
}


//MARK: - For Handling Filter CollectionView
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else{return UICollectionViewCell()}
        cell.config(with: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: collectionView.frame.height-4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            filter = "all"
        case 1:
            filter = "low-sugar"
        case 2:
            filter = "keto-friendly"
        default:
            filter = "vegan"
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}



//MARK: - For Handle Calling SEARCHING OR FILTERATION SEARCHING
extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
            return
            
        }
        if filter != nil && filter != "all"{
            guard let filtered = filter,
                  !filtered.trimmingCharacters(in: .whitespaces).isEmpty else{return}
            Network.shared.getResults(APICase: .getRecipeWithFilteration(q: query, filter: filtered), decodingModel: RecipeResponse.self) { results in
                
                DispatchQueue.main.async {
                    switch results {
                    case .success(let recipesList):
                        self.recipeList = recipesList
                        resultsController.url = recipesList.links.next.href
                        resultsController.recipes = recipesList.hits
                        resultsController.tableView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            Network.shared.getResults(APICase: .getRecipe(q: query), decodingModel: RecipeResponse.self) { results in
                
                DispatchQueue.main.async {
                    switch results {
                    case .success(let recipesList):
                        self.recipeList = recipesList
                        resultsController.url = recipesList.links.next.href
                        resultsController.recipes = recipesList.hits
                        resultsController.tableView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                        resultsController.recipes = []
                        resultsController.tableView.reloadData()
                    }
                }
            }
            
        }
        
        
    }
    
}
