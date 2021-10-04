//
//  Colecao.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/2021.
//

import Foundation
import UIKit

class Colecao: Codable, Equatable {
    let id: String
    var titulo: String
    var subTitulo: String
    var nomeImagens: [String]
    
    init(titulo: String, subTitulo: String) {
        self.titulo = titulo
        self.subTitulo = subTitulo
        self.nomeImagens = [String]()
        
        id = "\(titulo) - \(subTitulo) - \(Date())"
    }
    
    func retornaImagens() -> [UIImage] {
        let imagens: [UIImage] = nomeImagens.map { elemento in
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

            if let dirPath = paths.first {
                let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(elemento)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image ?? UIImage()

            }

            return UIImage()
        }
        
        return imagens
    }
    
    func adicionarNovaImagem(imagem: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = "\(titulo) - \(Date())"
        nomeImagens.append(fileName)
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = imagem.jpegData(compressionQuality: 1) else { return }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
            
            }
        }

        do {
            try data.write(to: fileURL)
        } catch {
        }
    }
    
    static func == (lhs: Colecao, rhs: Colecao) -> Bool {
        return lhs.id == rhs.id
    }
}
