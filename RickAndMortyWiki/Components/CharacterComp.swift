//
//  LocationWidget.swift
//  RickAndMortyWiki
//
//  Created by Harun on 3.04.2023.
//

import UIKit

class CharacterComp : UIView {
    var id : Int?
    var title : String?
    var gender : String?
    var image : String?
    var order : Int?
    var completor : ((_ id : Int) -> Void)?
    
    var img : UIImageView = {
        let img = UIImageView.init()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    let stack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    let lbl : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = AppFonts.title
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    init(id : Int,title: String, gender : String, image:String, order : Int, completor : @escaping (_ id : Int) -> Void) {
        super.init(frame: .infinite)
        self.id = id
        self.title = title
        self.gender = gender
        self.image = image
        self.completor = completor
        self.order = order
        configure()
    }
    
    override func layoutSubviews() {
        img.makeCircle()
    }
    
    func configure(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectCharacter))
        self.addGestureRecognizer(tap)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        
        //Gender coloring
        switch(self.gender){
            case "Male":
                self.backgroundColor = .init(named: "maleCharacterColor")
            case "Female":
                self.backgroundColor = .init(named: "femaleCharacterColor")
            default:
                self.backgroundColor = .init(named: "unknownCharacterColor")
        }
        
        //Stack
        self.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 10),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        //Label
        lbl.text = self.title
        
        //Image
        img.image = .init(named: "defaultCharacterImage")
        img.load(url: URL(string: (self.image!))!)
        
        
        //Order orientation
        if self.order != nil{
            switch(self.order! % 2){
            case 1:
                stack.addArrangedSubview(lbl)
                stack.addArrangedSubview(img)
            default:
                stack.addArrangedSubview(img)
                stack.addArrangedSubview(lbl)
            }
        }
        
        NSLayoutConstraint.activate([
            img.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            img.widthAnchor.constraint(equalTo: img.heightAnchor),
        ])
    }
    
    @objc func selectCharacter() {
        completor!(self.id!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
