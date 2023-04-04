//
//  HomeViewModel.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import UIKit
import RickMortySwiftApi

enum Status { case LOADING, ERROR, DONE }

class HomeViewModel{
    private(set) var fetchedLocations : [RMLocationModel] = []
    private(set) var locationStatus : Status = .LOADING
    private(set) var fetchedCharacters : [RMCharacterModel] = []
    private(set) var characterStatus : Status = .LOADING
    private let rmClient = RMClient()
 
    func fetchCharacters(locationId : Int) async {
        do {
            self.characterStatus = .LOADING
            fetchedCharacters.removeAll()
            let location = try await rmClient.location().getLocationByID(id: locationId)
            for i in location.residents{
                do {
                    let character = try await rmClient.character().getCharacterByURL(url: i)
                    fetchedCharacters.append(character)
                    self.characterStatus = .DONE
                } catch (let error) {
                    self.characterStatus = .ERROR
                    print(error)
                }
            }
        } catch (let error) {
            self.characterStatus = .ERROR
            print(error)
        }
    }
    
    func fetchLocations() async{
        do {
            self.locationStatus = .LOADING
            fetchedLocations = try await rmClient.location().getLocationsByPageNumber(pageNumber: 1)
            locationStatus = .DONE
        } catch (let error) {
            print(error)
        }
    }
}
