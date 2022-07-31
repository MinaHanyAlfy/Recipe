//
//  SearchResultViewController.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-23.
//

import UIKit
protocol SearchResultProtocol: AnyObject{
    func recipesSuccess(recipes: [Hit])
}
class SearchResultViewController: UIViewController, SearchResultProtocol {
    private var viewModel: SearchResultViewModelProtocol!
    var recipes : [Hit]?{
        didSet{
            DispatchQueue.main.async { [self] in
                if recipes?.count ?? 0 > 0 {
                    noRecipeView.alpha = 0
                    tableView.isHidden = false
                    self.tableView.reloadData()
                }else {
                    noRecipeView.alpha = 1
                    tableView.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    var isPagination: Bool = false
    var url: String?
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: RecipeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecipeTableViewCell.identifier)
        return tableView
    }()
    
    private var noRecipeView: ZeroStateView = {
        let view = ZeroStateView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        noRecipeView = ZeroStateView(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.width/2))
        noRecipeView.alpha = 1
        view.addSubview(noRecipeView)
        tableViewHandler()
        viewModel = SearchResultViewModel(view: self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noRecipeView.center = view.center
    }
    
    private func tableViewHandler(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
    }
   
    
   
}
//MARK: - For Recipe List TableView
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as? RecipeTableViewCell else {return UITableViewCell()}
        guard let recipe = recipes?[indexPath.row].recipe else {return UITableViewCell() }
        cell.configure(recipe)

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipe = recipes?[indexPath.row].recipe
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let recipeDetailsVc = storyBoard.instantiateViewController(withIdentifier: "DetailsVc") as! RecipeDetailsViewController
        recipeDetailsVc.recipe = recipe
        self.present(recipeDetailsVc, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let recipes = recipes else{return}
        if indexPath.row == recipes.count - 1{
            guard let url = url else {return}
            viewModel.requestRecipes(url: url)
        }
    }
  
    func recipesSuccess(recipes: [Hit]) {
        self.recipes?.append(contentsOf: recipes)
    }
    
    
    
}
