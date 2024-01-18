//
//  SearchAssembly.swift
//  BinetProject
//
//  Created Вячеслав Вовк on 18.01.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


class SearchAssembly {

    func build() -> UIViewController {
        let view = SearchViewController()
        let router = SearchRouter()
        let viewModel = SearchViewModel(router: router)
        
        view.viewModel = viewModel
        router.moduleViewController = view
        
        return view
    }

}
