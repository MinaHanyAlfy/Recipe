//
//  HomeViewModel.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import Foundation



protocol HomeViewModelProtocol {
    func recipesResult()
    func fetchRecipesDefault(isPagination: Bool)
//    func recipesSearch(q: String)
//    func recipesSearchFiltered(q: String,filter: String)
}
public class HomeViewModel: HomeViewModelProtocol {
   
    var recipeList: RecipeResponse?
    var recipes: [Hit] = []{
        didSet{
            DispatchQueue.main.async {
                self.view.recipeSuccess(recipes: self.recipes)
            }
        }
    }
    
    weak private var view: HomeViewProtocol!
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
    
    
}
//Function Extenison
extension HomeViewModel{
    
    func recipesResult() {
        Network.shared.getResults(APICase: .getDefault,decodingModel: RecipeResponse.self) { [weak self] (response) in
            switch response{
                
            case .success(let data):
                self?.recipeList = data
                self?.recipes = data.hits
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func fetchRecipesDefault(isPagination: Bool){
        if isPagination {
            guard let urlString = recipeList?.links.next.href else{return}
            Network.shared.getResults(urlString,APICase: .getRecipe(q: "Chicken"), decodingModel: RecipeResponse.self) { response in
                switch response {
                case .success(let recipe):
                    self.recipeList?.links = recipe.links
                   self.recipes.append(contentsOf: recipe.hits)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
        Network.shared.getResults(APICase: .getRecipe(q: "Chicken"), decodingModel: RecipeResponse.self) { response in
            switch response {
            case .success(let recipe):
                    self.recipeList = recipe
                    self.recipes = recipe.hits
            case .failure(let error):
                print(error)
                }
            }
        }
    }
 
    
    
    
}
