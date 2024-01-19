//
//  PreparatCell.swift
//  BinetProject
//
//  Created by Вячеслав Вовк on 17.01.2024.
//


import UIKit
import SnapKit

class PreparatCell: UICollectionViewCell {
    
    static let identifier = "PreparatCell"
    private var dbService = DBService()
    
    private var mainView = UIView()
    private var shadowView = UIView()
    
    private let mainImage = UIImageView()
    private var nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 13)
        label.textColor = .black
        label.numberOfLines = 0
        
        let attributedString = NSMutableAttributedString(string: "Your text")

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 5

        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        label.attributedText = attributedString
        
        label.text = "БОЛЕЗНИ ЗЕРНОВЫХ КУЛЬТУР"
        return label
    }()
    
    private var descriptionLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        label.textColor = UIColor(red: 0.683, green: 0.691, blue: 0.712, alpha: 1)
        label.numberOfLines = 0
        
        let attributedString = NSMutableAttributedString(string: "Your text")

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 5

        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        label.attributedText = attributedString
        
        label.text = "Болезни клевера и люцерны опасны как при выращивании на кормовые цели, так и при получении ..."
        
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private var shadows = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        makeConstraints()
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 164, height: 296), cornerRadius: 8)
        
        mainView.layer.shadowPath = shadowPath.cgPath
        mainView.layer.shadowColor = UIColor(red: 0.282, green: 0.298, blue: 0.298, alpha: 0.15).cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(data: Preparat) {
        if let name = data.name {
            self.nameLable.text = name
        }
        if let description = data.description {
            self.descriptionLable.text = description
        }
        if let image = data.image {
            self.dbService.downloadImage(from: image, imageView: self.mainImage)
        }
    }
}

private extension PreparatCell {
    func initialize() {
        addSubview(mainView)
        mainView.addSubview(mainImage)
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 8
        
        mainImage.image = UIImage(named: "error")
        mainImage.layer.cornerRadius = 8
        mainImage.clipsToBounds = true
        mainImage.backgroundColor = .white
        
        mainView.addSubview(nameLable)
        mainView.addSubview(descriptionLable)
        
        
    }
    
    func makeConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(296)
        }
        
        
        mainImage.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
            make.width.equalTo(140)
            make.height.equalTo(152)
        }
        
        nameLable.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        descriptionLable.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(12)
            make.top.equalTo(nameLable.snp.bottom).offset(6)
            make.height.equalTo(85)
        }
        
    }
    
    
    
}
