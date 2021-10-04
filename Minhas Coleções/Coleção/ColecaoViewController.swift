//
//  ColecaoViewController.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/2021.
//

import UIKit

class ColecaoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let colecao: Colecao
    let imagePicker = UIImagePickerController()
    let alert: UIAlertController
    var imagens = [UIImage]()
    let key = "Coleções"
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurar()
    }
    
    init(colecao: Colecao) {
        self.colecao = colecao
        alert = UIAlertController(title: "Escolha uma imagem", message: nil, preferredStyle: .actionSheet)
        super.init(nibName: nil, bundle: nil)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.abrirCamera()
        }
        let galleryAction = UIAlertAction(title: "Galeria", style: .default) { action in
            self.abrirGaleria()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { action in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        imagens = colecao.retornaImagens()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurar() {
        title = colecao.titulo
        
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(adicionar))
        navigationItem.rightBarButtonItem = item
        
        collectionView.register(UINib(nibName: "\(CollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func abrirCamera() {
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Aviso", message: "Não foi possível abrir a camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            present(alertController, animated: true)
        }
    }
    
    func abrirGaleria() {
        alert.dismiss(animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    @objc func adicionar() {
        present(alert, animated: true)
    }
    
    func atualizar() {
        if var colecoes = UserDefaults.standard.decodable(forKey: key, as: [Colecao].self) {
            for (indice, colecaoSalva) in colecoes.enumerated() {
                if colecaoSalva == colecao {
                    colecoes[indice] = colecao
                    do {
                        try UserDefaults.standard.set(encodable: colecoes, forKey: key)
                    } catch {
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        imagens.append(image)
        colecao.adicionarNovaImagem(imagem: image)
        atualizar()
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.configurar(imagem: imagens[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
      }
}
