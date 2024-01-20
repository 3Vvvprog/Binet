//
//  SearchViewController.swift
//  BinetProject
//
//  Created Вячеслав Вовк on 18.01.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController {
    var viewModel: SearchViewModelProtocol!
    private var disposeBag = DisposeBag()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    
    private var canselButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        return button
    }()
    
    
    private var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.backgroundColor = .white
        search.backgroundImage = UIImage()
        search.placeholder = "Поиск"
        return search
    }()
    
    lazy var preparateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 100
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 24, left: 16, bottom: 70, right: 16)
    
        let preparateCollectionView = UICollectionView(frame:  .zero, collectionViewLayout: layout)
        preparateCollectionView.backgroundColor = .white
        preparateCollectionView.register(PreparatCell.self, forCellWithReuseIdentifier: PreparatCell.identifier)
        return preparateCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        viewModel.moduleDidLoad()
        view.backgroundColor = .white
        initialize()
        makeConstraints()
        configureSearchController()
        bind()
        makeCollectionView()
        
    }
    
    deinit {
        print("deinit")
    }
    
}

private extension SearchViewController {
    func initialize() {
        view.addSubview(preparateCollectionView)
    }
    
    func makeConstraints() {
       
        preparateCollectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.tintColor = .black
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setValue("Отмена", forKey:"cancelButtonText")
        searchController.isActive = true
        
        
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func bind() {
        searchController.searchBar.rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.searchString.accept(text ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    func makeCollectionView() {
        
        
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Preparats> { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreparatCell.identifier, for: indexPath) as! PreparatCell
            cell.configure(data: item)
            return cell
        }
        
        dataSource.animationConfiguration = .init(
            insertAnimation: .top,
            reloadAnimation: .top,
            deleteAnimation: .left
        )
        
        viewModel.dataSource = dataSource
        
        viewModel.array
            .map { [Preparats(identity: "1", preparats: $0)] }
            .bind(to: preparateCollectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        
        
        preparateCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] event in
                let newViewController = SelectedPreparatAssembly().build(preparat: self!.viewModel.array.value[event.item])
                self?.navigationController?.pushViewController(newViewController, animated: true)
                
            })
            .disposed(by: disposeBag)
        
    }
}



