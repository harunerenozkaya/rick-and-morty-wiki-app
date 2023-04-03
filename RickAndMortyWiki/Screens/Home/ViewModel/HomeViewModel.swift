//
//  HomeViewModel.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import UIKit

class HomeViewModel{
    var fetchedLocations : [Int] = []
    var fetchedCharacters : [Int] = []
    
    func setCharacters(missingText : UIView, charactersArea : UIStackView){
        if fetchedCharacters.isEmpty{
            charactersArea.addArrangedSubview(missingText)
        }
        else{
            
        }
        
    }
}
