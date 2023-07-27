//
//  FilmTableViewCell.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    var cancelableTask: (Task<(),Error>)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.layer.cornerRadius = 20
        backgroundColor = .clear

        stack.backgroundColor = .black.withAlphaComponent(0.3)
        stack.layer.cornerRadius = 18
        
        firstLabel.textColor = #colorLiteral(red: 0.7723322511, green: 0.930079639, blue: 0.9680836797, alpha: 1)
        firstLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold, width: .expanded)
        
        secondLabel.textColor = #colorLiteral(red: 0.1178662553, green: 0.1747975647, blue: 0.2032309175, alpha: 1)
        secondLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold, width: .compressed)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancelableTask?.cancel()
        cancelableTask = nil
        cellImage.image = nil
    }
}

