//
//  ColecaoTableViewCell.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/2021.
//

import UIKit

class ColecaoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSubTitulo: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var viewRedonda: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurar(titulo: String, subtTitulo: String) {
        labelTitulo.text = titulo
        labelSubTitulo.text = subtTitulo
        
        viewRedonda.layer.cornerRadius = 10
//        viewRedonda.layer.shadowColor = UIColor.black.cgColor
//        viewRedonda.layer.shadowOpacity = 0.25
//        viewRedonda.layer.shadowOffset = CGSize(width: 0, height: 2)
//        viewRedonda.layer.shadowRadius = 10
//        viewRedonda.layer.masksToBounds = false
    }
}
