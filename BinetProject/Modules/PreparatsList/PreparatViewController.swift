//
//  ViewController.swift
//  BinetProject
//
//  Created by Вячеслав Вовк on 17.01.2024.
//

import UIKit
import SnapKit
import RxDataSources
import RxSwift

class PreparatViewController: UIViewController {
    
    
    private let viewModel = PreparatViewModel()
    private let disposeBag = DisposeBag()

    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        label.textColor = .white
        label.text = "Препараты"
        label.textAlignment = .center
        return label
    }()
    
    lazy var plantPreparateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 100
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 24, left: 16, bottom: 70, right: 16)
    
        let plantPreparateCollectionView = UICollectionView(frame:  .zero, collectionViewLayout: layout)
        plantPreparateCollectionView.backgroundColor = .white
        plantPreparateCollectionView.register(PreparatCell.self, forCellWithReuseIdentifier: PreparatCell.identifier)
        return plantPreparateCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.leftBarButtonItems = makeLeftTabBarButton()
        navigationItem.rightBarButtonItems = makeRightTabBarButton()
        
        
        initialize()
        makeConstraints()
        viewModel.moduleDidLoad()
        makeCollectionView()
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        viewModel.fetchData(id: self.viewModel.count)
        
    }


}

private extension PreparatViewController {
    func initialize() {
        navigationItem.titleView = titleLabel
        view.addSubview(plantPreparateCollectionView)
        
    }
    
    func makeConstraints() {
        plantPreparateCollectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }

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
            .bind(to: plantPreparateCollectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        plantPreparateCollectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] event in
                print("count \((self?.viewModel.array.value.count)!)")
                if event.at.item == ((self?.viewModel.array.value.count)! - 4) {
                    self?.viewModel.fetchData(id: (self?.viewModel.count)!)
                    self?.viewModel.fetchData(id: (self?.viewModel.count)!)
                    self?.viewModel.fetchData(id: (self?.viewModel.count)!)
                    self?.viewModel.fetchData(id: (self?.viewModel.count)!)
                    
                }
            })
            .disposed(by: disposeBag)
        
        plantPreparateCollectionView.rx.itemSelected
            .subscribe(onNext: { event in
                let newViewController = SelectedPreparatAssembly().build(preparat: self.viewModel.array.value[event.item])
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    func makeRightTabBarButton() -> [UIBarButtonItem] {
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        searchBarButton.tintColor = .white
        
        return [searchBarButton]
    }
    
    @objc func didTapSearchButton() {
        let searchViewController = SearchAssembly().build()
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    func makeLeftTabBarButton() -> [UIBarButtonItem] {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .white
        
        return [backButton]
    }
    
    @objc func didTapBackButton() {
        print("back")
    }
}

