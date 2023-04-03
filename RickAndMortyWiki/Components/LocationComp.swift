//
//  LocationWidget.swift
//  RickAndMortyWiki
//
//  Created by Harun on 3.04.2023.
//

import UIKit

class LocationComp : UIButton {
    
    init(title: String) {
        super.init(frame: .infinite)
        self.setAttributedTitle(.init(string: title,attributes: [.font:AppFonts.location , .foregroundColor : UIColor.black]), for:.normal)
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .init(named: "dirtyWhite")
        configuration.background.cornerRadius = 5
        configuration.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        self.configuration = configuration
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
