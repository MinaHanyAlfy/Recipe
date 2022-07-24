//
//  DetailsViewController.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import UIKit
import SafariServices


public class RecipeDetailsViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var safariShowButton: UIButton!
    
    var recipe: Recipe?
    {
        didSet{
            guard let recipe = recipe else {
                return
            }
            
            DispatchQueue.main.async { [self] in
                titleLabel.text = recipe.label
                let newIngrediant = recipe.ingredientLines?.joined(separator: "\n")
                ingredientsTextView.text = newIngrediant
                downloadImage(from: URL(string: recipe.images?.large?.url ?? recipe.image ??  "https://www.dmplayhouse.com/wp-content/uploads/2019/12/13-512.png" )!)
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipe Details"
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    //MARK: - For Sharing SFSafariViewController
    @IBAction func safariButtonAction(_ sender: Any) {
        guard let recipe = recipe else {
            return
        }
        
        guard let url = URL(string: recipe.url ?? "https://www.google.com") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - For Sharing Recipe Option
    @IBAction func shareButtonAction(_ sender: Any) {
        print("Sharing")
        let items = ["This Screen from Recipe Task application",view.asImage()] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            activityViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            activityViewController.preferredContentSize = CGSize(width: 0, height: 0)
            present(activityViewController, animated: true, completion: nil)
        }
        else
        {
            present(activityViewController, animated: true, completion: nil)
        }
    }
}

//MARK: - For Downloading Image
extension RecipeDetailsViewController{
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.recipeImageView.image = UIImage(data: data)
            }
        }
    }
    
}
