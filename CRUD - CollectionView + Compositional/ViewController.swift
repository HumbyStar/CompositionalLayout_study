//
//  ViewController.swift
//  CRUD - CollectionView + Compositional
//
//  Created by Humberto Rodrigues on 22/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.identifier)
        view.addSubview(collectionView)
    }
    
    //MARK: - Configurar Compositional Layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
    
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 10
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        
        //  Torna mais fácil adicionar, remover ou atualizar itens.
        //  Section e Int são os tipos usados para identificar seções e itens, respectivamente, no dataSource
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, counts: Int) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TextCell.identifier,
                for: indexPath) as? TextCell else {fatalError("Cannot create new cell")}
            
            cell.label.text = "\(counts)"
            cell.contentView.backgroundColor = .yellow
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
            return cell
        }
        
        // O NSDiffableDataSourceSnapshot é uma instância que captura uma foto dos dados e seções presentes em um dado momento.
        
        // Fornece uma maneira de manipular esses dados e aplicar as mudanças de maneira animada e automática à UICollectionView ou UITableView
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main]) // Adicionando uma seção ao snapshot
        snapshot.appendItems(Array(0..<94))
        
        // Na linha de baixo iremos aplicar esse snapshot ao dataSource, esse ato que fala para collectionView atualizar.
        // O parametro animatingDifferences especifica se as diferenças de estado anterior e o novo estado devem ser animadas.
    
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    

}
