//
//  SelectedPreparatViewModel.swift
//  BinetProject
//
//  Created Вячеслав Вовк on 18.01.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SelectedPreparatViewModelProtocol {
    func moduleDidLoad()
}

class SelectedPreparatViewModel: SelectedPreparatViewModelProtocol {
    private var router: SelectedPreparatRouterProtocol
    
    init(router: SelectedPreparatRouterProtocol) {
        self.router = router
    }

    func moduleDidLoad() {

    }
}
