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
    
    //Navigate to home screen after the time passed
    func showCharacterDetailScreen(_ nav : UINavigationController?,_ time : CGFloat,id : Int){
        let detailViewController = DetailView()
        detailViewController.id = id
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            nav?.pushViewController(detailViewController, animated: true)
        }
    }
    
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
    
    func fetchLocations(_ pageNumber : Int) async{
        do {
            self.locationStatus = .LOADING
            fetchedLocations = try await rmClient.location().getLocationsByPageNumber(pageNumber: pageNumber)
            locationStatus = .DONE
        } catch (let error) {
            print(error)
        }
    }
}
