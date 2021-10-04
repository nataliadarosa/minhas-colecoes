//
//  TelaInicialViewController.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/2021.
//

import UIKit

class TelaInicialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [Colecao] = [Colecao]()
    let key = "Coleções"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurar()
    }
    
    func configurar() {
        title = "Coleções"
        
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(adicionar))
        navigationItem.rightBarButtonItem = item
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "\(ColecaoTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "colecaoCell")
        
        if let colecoes = UserDefaults.standard.decodable(forKey: key, as: [Colecao].self) {
            dataSource = colecoes
            tableView.reloadData()
        }
    }
    
    @objc func adicionar() {
        let balaoAdicionar = UIAlertController(title: "Criar Coleção", message: "De um título e subtítulo para a nova coleção", preferredStyle: .alert)
        balaoAdicionar.addTextField(configurationHandler: { textField in
            textField.placeholder = "Título"
        })
        balaoAdicionar.addTextField(configurationHandler: { textField in
            textField.placeholder = "Subtítulo"
        })
        
        let botaoCriar = UIAlertAction(title: "Criar", style: .default, handler: { action in
            let titulo = balaoAdicionar.textFields?[0].text ?? "Sem título"
            let subTitulo = balaoAdicionar.textFields?[1].text ?? "Sem subtítulo"
            let novaColecao = Colecao(titulo: titulo, subTitulo: subTitulo)
            
            self.dataSource.append(novaColecao)
            self.atualizar()
            self.tableView.reloadData()
        })
        let botaoCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
        
        balaoAdicionar.addAction(botaoCriar)
        balaoAdicionar.addAction(botaoCancelar)
        
        self.present(balaoAdicionar, animated: true)
    }
    
    func atualizar() {
        do {
            try UserDefaults.standard.set(encodable: dataSource, forKey: key)
        } catch {
            mostrarMensagemErro(erro: error.localizedDescription)
        }
    }
    
    func editar(indice: Int) {
        let colecao = dataSource[indice]
        let balaoEditar = UIAlertController(title: "Editar \"\(colecao.titulo)\"", message: nil, preferredStyle: .alert)
        balaoEditar.addTextField(configurationHandler: { textField in
            textField.text = colecao.titulo
        })
        balaoEditar.addTextField(configurationHandler: { textField in
            textField.text = colecao.subTitulo
        })
        
        let botaoSalvar = UIAlertAction(title: "Salvar", style: .default, handler: { action in
            let titulo = balaoEditar.textFields?[0].text ?? "Sem título"
            let subTitulo = balaoEditar.textFields?[1].text ?? "Sem subtítulo"
            colecao.titulo = titulo
            colecao.subTitulo = subTitulo
            
            self.atualizar()
            self.tableView.reloadData()
        })
        let botaoCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
        
        balaoEditar.addAction(botaoSalvar)
        balaoEditar.addAction(botaoCancelar)
        
        present(balaoEditar, animated: true)
    }
    
    func deletar(indice: IndexPath) {
        let alert = UIAlertController(title: "Aviso", message: "Deseja realmente deletar essa coleção? Essa ação não pode ser desfeita!", preferredStyle: .alert)
        let deletar = UIAlertAction(title: "Deletar", style: .destructive, handler: { [self] action in
            self.dataSource.remove(at: indice.row)
            self.tableView.deleteRows(at: [indice], with: .fade)
            self.tableView.reloadData()
            self.atualizar()
        })
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(cancelar)
        alert.addAction(deletar)
        
        present(alert, animated: true)
    }
    
    func mostrarMensagemErro(erro: String) {
        let alert = UIAlertController(title: "Erro", message: "Não foi possível salvar a coleção. Erro: \(erro)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "colecaoCell") as? ColecaoTableViewCell else { return UITableViewCell() }
        let colecao = dataSource[indexPath.row]
        cell.configurar(titulo: colecao.titulo, subtTitulo: colecao.subTitulo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editar = UIContextualAction(style: .normal, title: "Editar", handler: { action, view , bool  in
            self.editar(indice: indexPath.row)
        })
        let deletar = UIContextualAction(style: .normal, title: "Deletar", handler: { action, view , bool  in
            self.deletar(indice: indexPath)
        })
        deletar.backgroundColor = .red
        
        let swipe = UISwipeActionsConfiguration(actions: [deletar, editar])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let colecao = dataSource[indexPath.row]
        let colecaoController = ColecaoViewController(colecao: colecao)
        
        navigationController?.pushViewController(colecaoController, animated: true)
    }
}
