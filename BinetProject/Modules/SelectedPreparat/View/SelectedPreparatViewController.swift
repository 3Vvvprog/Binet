//
//  SelectedPreparatViewController.swift
//  Binet
//
//  Created Вячеслав Вовк on 18.01.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

class SelectedPreparatViewController: UIViewController {
    var viewModel: SelectedPreparatViewModelProtocol!
    private let dbService = DBService()
    
    private var mainView = UIView()
    private var imageView = UIImageView()
    private var starButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = UIColor(red: 174/255.0, green: 176/255.0, blue: 183/255.0, alpha: 1.000)
        return button
    }()
    private var iconView = UIImageView()
    
    private var nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        label.textColor = .black
        label.text = "ДВД Шанс, КС"
        return label
    }()
    
    private var descriptionLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 15)
        label.textColor = UIColor(red: 0.683, green: 0.691, blue: 0.712, alpha: 1)
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: "Your text")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.text = "Двухкомпонентный протравитель семян зерновых культур."
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var mapButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.moduleDidLoad()
        view.backgroundColor = UIColor(red: 111/255.0, green: 181/255.0, blue: 75/255.0, alpha: 1.000)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItems = makeLeftTabBarButton()
        initialize()
        makeConstraints()
    }
    
    
    deinit {
        print("deinit")
    }
    
    func configure(data: Preparat) {
        if let name = data.name {
            self.nameLable.text = name
        }
        if let description = data.description {
            self.descriptionLable.text = description
        }
        if let image = data.image {
            self.dbService.downloadImage(from: image, imageView: self.imageView)
        }
        if let icon = data.categories?.icon {
            self.dbService.downloadImage(from: icon, imageView: self.iconView)
        }
    }
    
}


private extension SelectedPreparatViewController {
    func initialize() {
        view.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "error")
        
        mainView.addSubview(starButton)
        
        mainView.addSubview(iconView)
        iconView.backgroundColor = .lightGray
        iconView.layer.cornerRadius = 16
        
        mainView.addSubview(nameLable)
        mainView.addSubview(descriptionLable)
        
        mapButton = makeBottomButton()
        mainView.addSubview(mapButton)
    }
    func makeConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(183)
            make.width.equalTo(117)
        }
        
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(imageView.snp.trailing).offset(65)
            make.height.width.equalTo(32)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalTo(imageView.snp.leading).offset(-65)
            make.height.width.equalTo(32)
        }
        
        nameLable.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(32)
        }
        
        descriptionLable.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameLable.snp.bottom).offset(8)
        }
        
        mapButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLable.snp.bottom).offset(16)
            make.height.equalTo(36)
        }
    }
    
    func makeLeftTabBarButton() -> [UIBarButtonItem] {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .white
        
        return [backButton]
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func makeBottomButton() -> UIButton {
        let button = UIButton()
        let view = UIView()
        let image = UIImageView()
        let label = UILabel()
        
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.937, green: 0.937, blue: 0.941, alpha: 1).cgColor
        
        label.text = "ГДЕ КУПИТЬ"
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        label.textColor = .black
        
        image.image = UIImage.map
        
        button.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(98)
            make.height.equalTo(20)
        }
        
        view.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(4)
        }
        
        return button
    }
}
