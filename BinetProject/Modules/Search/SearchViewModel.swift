//
//  SearchViewModel.swift
//  BinetProject
//
//  Created Вячеслав Вовк on 18.01.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
import UIKit

protocol SearchViewModelProtocol {
    func moduleDidLoad()
    var array: BehaviorRelay<[Preparat]> { get set }
    var searchString: PublishRelay<String> { get set }
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<Preparats>! { get set }
    
}

class SearchViewModel: SearchViewModelProtocol {
    private var router: SearchRouterProtocol
    
    init(router: SearchRouterProtocol) {
        self.router = router
    }

    
    private var dbServise = DBService()
    
    
    var array = BehaviorRelay<[Preparat]>(value: [])
    var searchString = PublishRelay<String>()
    private var disposeBag = DisposeBag()
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<Preparats>!
    
    

    func moduleDidLoad() {
        array
            .subscribe(onNext: { items in
               
            })
            .disposed(by: disposeBag)
        
        searchString.asObservable()
            .subscribe(onNext: { searchText in
                if searchText != "" {
                    self.dbServise.fetchDataBySearch(search: searchText) { result in
                        switch result {
                        case .success(let preparat):
                            self.array.accept(preparat)
                        case .failure(_):
                            break
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}


