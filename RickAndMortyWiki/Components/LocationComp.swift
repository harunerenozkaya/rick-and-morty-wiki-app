//
//  LocationWidget.swift
//  RickAndMortyWiki
//
//  Created by Harun on 3.04.2023.
//

import UIKit

class LocationComp : UIButton {
    var id : Int?
    var title : String?
    var completor : ((_ id : Int) -> Void)?
    
    init(title: String, id : Int, completor : @escaping (_ id : Int) -> Void) {
        super.init(frame: .infinite)
        self.id = id
        self.title = title
        self.completor = completor
        
        configure()
    }
    
    func configure(){
        self.setAttributedTitle(.init(string: title!,attributes: [.font:AppFonts.location , .foregroundColor : UIColor.black]), for:.normal)
        self.addTarget(self, action: #selector(self.selectLocation) , for: .touchUpInside)
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .init(named: "dirtyWhite")
        configuration.background.cornerRadius = 5
        configuration.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        self.configuration = configuration
    }
    
    @objc func selectLocation() {
        completor!(self.id!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
