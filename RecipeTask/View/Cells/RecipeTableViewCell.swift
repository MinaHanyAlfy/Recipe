//
//  RecipeTableViewCell.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-23.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    static let identifier = "RecipeTableViewCell"
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var healthTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = recipeImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(_ recipe: Recipe){
        titleLabel.text = recipe.label
        sourceLabel.text = recipe.source
        downloadImage(from: URL(string: recipe.image ?? "https://www.dmplayhouse.com/wp-content/uploads/2019/12/13-512.png")!)
        let str = recipe.healthLabels?.joined(separator: " , ")
        healthTextView.text = str
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        sourceLabel.text = nil
        healthTextView.text = nil
    }
    
}

extension RecipeTableViewCell{
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
