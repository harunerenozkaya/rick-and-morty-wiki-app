//
//  DetailViewModel.swift
//  RickAndMortyWiki
//
//  Created by Harun on 17.04.2023.
//

import UIKit
import RickMortySwiftApi


class DetailViewModel{
    var fetchedCharacter : RMCharacterModel?
    private let rmClient = RMClient()
    
    func fetchCharacterDetail(id : Int) async {
        do {
            fetchedCharacter = try await rmClient.character().getCharacterByID(id: id)
        } catch (let error) {
            print(error)
        }
    }
}
