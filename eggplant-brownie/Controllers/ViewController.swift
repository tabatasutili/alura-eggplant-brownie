//
//  ViewController.swift
//  eggplant-brownie
//
//  Created by Tabata Sabrina Sutili on 12/03/21.
//  Copyright © 2021 Tabata Sabrina Sutili. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate {
    func add(_ refeicao: Refeicao)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdicionaItensDelegate {
    
    
    //MARK: - IBOutlet
    
    
    @IBOutlet weak var itensTableView: UITableView?
    
    

    //MARK: - Atributos
    
    var delegate: ViewControllerDelegate?
    
    
    var itens: [Item] = []
    
    var itensSelecionados: [Item] = []
    
    //MARK: - IBOoutlets
    
    @IBOutlet var nomeTextField: UITextField?
    @IBOutlet var felicidadeTextField: UITextField?
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        let botaoAdicionarItem = UIBarButtonItem(title: "adicionar", style: .plain, target: self, action: #selector(adicionarItem))
        navigationItem.rightBarButtonItem = botaoAdicionarItem
        recuperaItens()
    }
    func recuperaItens() {
        itens = ItemDao().recupera()
    }
    
    @objc func adicionarItem() {
        let adicionarItensViewController = AdicionarItensViewController(delegate: self)
        navigationController?.pushViewController(adicionarItensViewController, animated: true)
    }
    
    func add(_ item: Item) {
        itens.append(item)
        ItemDao().save(itens)
        if let tableView = itensTableView {
            tableView.reloadData()
        } else {
            Alerta(controller: self).exibe(mensagem: "Erro ao atualizar a tabela")
        }
    }
    
    func exibeAlerta() {
        let alerta = UIAlertController(title: "Desculpe", message: "não foi possivel atualizar a tabela", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(ok)
        present(alerta, animated: true, completion: nil)
    }
        
        
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let linhaDaTabela = indexPath.row
        let item = itens[linhaDaTabela]
        
        celula.textLabel?.text = item.nome
        
        return celula
    
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let celula = tableView.cellForRow(at: indexPath) else{ return }
        if celula.accessoryType == .none{
             celula.accessoryType = .checkmark
            let linhaDaTabela = indexPath.row
            itensSelecionados.append(itens[linhaDaTabela])
        } else {
             celula.accessoryType = .none
            
            let item = itens[indexPath.row]
            if let position = itensSelecionados.index(of: item) {
                itensSelecionados.remove(at: position)
                
            }
        }
      
    }
    
    
    func recuperarRefeicaoDoFormulario() -> Refeicao? {
        
        guard let nomeDaRefeicao =  nomeTextField?.text else {
            return nil
        }
        guard let felicidadeDaRefeicao =  felicidadeTextField?.text,let felicidade = Int(felicidadeDaRefeicao) else {
            return nil
        }
        
        let refeicao = Refeicao(nome: nomeDaRefeicao, felicidade: felicidade, itens: itensSelecionados)
        
        return refeicao
        
       
    }
    
    
    
    //MARK: - IBActions
    
    func adicionar(_ sender: UIButton) {
        if let refeicao = recuperarRefeicaoDoFormulario(){
            delegate?.add(refeicao)
            navigationController?.popViewController(animated: true)
        } else {
            Alerta(controller: self).exibe(mensagem: "Erro ao ler dado do formulário")}
     }
}