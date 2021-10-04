//
//  CollectionViewCell.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurar(imagem: UIImage) {
        imageView.image = imagem
    }
}
