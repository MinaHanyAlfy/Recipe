//
//  SearchResultViewModel.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-31.
//

import Foundation

protocol SearchResultViewModelProtocol{
    func requestRecipes(url: String)
}
class SearchResultViewModel: SearchResultViewModelProtocol{
    
    var recipeList: RecipeResponse?
    var recipes: [Hit] = []{
        didSet{
            DispatchQueue.main.async {
                self.view.recipesSuccess(recipes: self.recipes)
            }
        }
    }
    weak private var view: SearchResultProtocol!

    init(view: SearchResultProtocol) {
        self.view = view
    }
    
    func requestRecipes(url: String){
        
        Network.shared.getResults(url, APICase: nil, decodingModel: RecipeResponse.self) { results in
            
            DispatchQueue.main.async {
                switch results {
                case .success(let recipesList):
                    self.recipes.append(contentsOf: recipesList.hits)
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
   
}
