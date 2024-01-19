//
//  ViewModel.swift
//  BinetProject
//
//  Created by Вячеслав Вовк on 17.01.2024.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
import UIKit




class PreparatViewModel {
    private var dbServise = DBService()
    var count = 2
    var items: [Preparat] = [
    
        
    ]
    var array = BehaviorRelay<[Preparat]>(value: [])
    private var disposeBag = DisposeBag()
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<Preparats>!
    
    

    func moduleDidLoad() {
        array
            .subscribe(onNext: { items in
                print(items.count)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchData(id: Int/*, collectionView: UICollectionView*/) {
        count += 1
        dbServise.fetchData(id: id) { result in
            switch result {
            case .success(let preparat):
                
                var items = self.array.value
                items.append(preparat)
                self.array.accept(items)
            case .failure(_):
                
                self.count += 1
                self.fetchData(id: self.count)
            }
        }
    }
    
    
}

