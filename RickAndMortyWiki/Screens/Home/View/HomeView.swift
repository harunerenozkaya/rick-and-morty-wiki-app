//
//  HomeView.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import UIKit

class HomeView : UIViewController {
    var vm  = HomeViewModel()
    
    let scrollview : UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.backgroundColor = .init(named: "mainBackgroundColor")
        scrollview.bounces = true
        scrollview.autoresizingMask = []
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    let container : UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 10
        return container
    }()
    
    let titleArea : UIView = {
        let titleArea = UIView()
        titleArea.translatesAutoresizingMaskIntoConstraints = false
        return titleArea
    }()
    
    let informationArea : UIStackView = {
        let informationArea = UIStackView()
        informationArea.axis = .vertical
        informationArea.spacing = 20
        informationArea.distribution = .fill
        informationArea.translatesAutoresizingMaskIntoConstraints = false
        return informationArea
    }()
    
    let titleImage : UIImageView = {
        let titleImage = UIImageView(image: UIImage.init(named: "titleImage"))
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    let locationsArea: UIScrollView = {
        let locationsArea = UIScrollView()
        locationsArea.translatesAutoresizingMaskIntoConstraints = false
        locationsArea.bounces = true
        locationsArea.showsHorizontalScrollIndicator = false
        return locationsArea
    }()
    
    var charactersArea: UIStackView = {
        let charactersArea = UIStackView()
        charactersArea.axis = .vertical
        charactersArea.translatesAutoresizingMaskIntoConstraints = false
        charactersArea.alignment = .center
        charactersArea.spacing = 10
        charactersArea.distribution = .equalSpacing
        
        return charactersArea
    }()
    
    let locationsContainer : UIStackView = {
        let locationsContainer = UIStackView()
        locationsContainer.axis = .horizontal
        locationsContainer.spacing = 10
        locationsContainer.distribution = .fillProportionally
        locationsContainer.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        locationsContainer.isLayoutMarginsRelativeArrangement = true
        locationsContainer.translatesAutoresizingMaskIntoConstraints = false
        return locationsContainer
    }()
    
    let missingLocationLbl : UILabel = {
        let label = UILabel()
        label.text = "Select a location"
        label.textColor = .init(named: "dirtyWhite")
        label.font = AppFonts.subtitle
        return label
    }()
    
    let loadingLbl : UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .init(named: "dirtyWhite")
        label.font = AppFonts.subtitle
        return label
    }()
    
    let missingCharactersLbl: UILabel = {
        let label = UILabel()
        label.text = "There is no residents here :("
        label.textColor = .init(named: "dirtyWhite")
        label.font = AppFonts.subtitle
        return label
    }()
    
    let errorCharacterLbl: UILabel = {
        let label = UILabel()
        label.text = "An error has occured :("
        label.textColor = .init(named: "dirtyWhite")
        label.font = AppFonts.subtitle
        return label
    }()
    
    func getData(){
        Task{
            await vm.fetchLocations()
            for i in vm.fetchedLocations{
                self.locationsContainer.addArrangedSubview(LocationComp(title: i.name , id: i.id){id in
                    
                    let fetchTask = Task{
                        for k in self.charactersArea.arrangedSubviews{
                            k.removeFromSuperview()
                        }
                        
                        self.charactersArea.addArrangedSubview(self.loadingLbl)
                        self.loadingLbl.topAnchor.constraint(equalTo: self.charactersArea.topAnchor,constant: 10).isActive = true
                        
                        await self.vm.fetchCharacters(locationId:id)
                        
                        for k in self.charactersArea.arrangedSubviews{
                            k.removeFromSuperview()
                        }
                        
                        if (self.vm.characterStatus == .LOADING){
                            self.charactersArea.addArrangedSubview(self.loadingLbl)
                            self.loadingLbl.topAnchor.constraint(equalTo: self.charactersArea.topAnchor,constant: 10).isActive = true
                            return self.vm.characterStatus
                        }
                        else if (self.vm.characterStatus == .ERROR){
                            self.charactersArea.addArrangedSubview(self.errorCharacterLbl)
                            self.errorCharacterLbl.topAnchor.constraint(equalTo: self.charactersArea.topAnchor,constant: 10).isActive = true
                            return self.vm.characterStatus
                        }
                        else{
                            var count = 0
                            for j in self.vm.fetchedCharacters{
                                self.charactersArea.addArrangedSubview(CharacterComp(id: j.id, title: j.name, gender: j.gender, image: j.image ,order: count){id in})
                                count += 1
                            }
                            
                            return self.vm.characterStatus
                        }
                    }
                    
                    //If server doesn't respond then time out
                    Task {
                        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
                        
                        if await (fetchTask.result == .success(.LOADING)){
                            for k in self.charactersArea.arrangedSubviews{
                                k.removeFromSuperview()
                            }
                            self.charactersArea.addArrangedSubview(self.missingCharactersLbl)
                            self.missingCharactersLbl.topAnchor.constraint(equalTo: self.charactersArea.topAnchor,constant: 10).isActive = true
                        }
                        fetchTask.cancel()
                    }
                })
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //Set constrainst according to orientation
        if(UIDevice.current.orientation == .portrait){
            configurePortrait()
        }
        else if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight){
            configureLandscape()
        }
    }
    
    override func viewDidLoad() {
        configureCommon()
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        if(UIDevice.current.orientation == .portrait || windowScene?.interfaceOrientation == .portrait ){
            configurePortrait()
        }
        else if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || windowScene?.interfaceOrientation == .landscapeLeft || windowScene?.interfaceOrientation == .landscapeRight){
            configureLandscape()
        }
        
        getData()
    }
    
    func configureCommon(){
        navigationController?.isNavigationBarHidden = true
        
        //Scroll View
        self.view.addSubview(scrollview)
        NSLayoutConstraint.activate([
            scrollview.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        //Container
        scrollview.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollview.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            container.widthAnchor.constraint(equalTo: scrollview.widthAnchor)
        ])
        
    }
    
    func configurePortrait() {
        //Title Area
        titleArea.removeFromSuperview()
        container.addArrangedSubview(titleArea)
        NSLayoutConstraint.activate([
            titleArea.heightAnchor.constraint(equalTo: self.view.widthAnchor , multiplier: 0.17)
        ])
        
        //Information Area
        informationArea.removeFromSuperview()
        container.addArrangedSubview(informationArea)
        /*NSLayoutConstraint.activate([
            informationArea.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.8)
        ])*/
        
        //Title Image
        titleImage.removeFromSuperview()
        titleArea.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: titleArea.centerXAnchor),
            titleImage.centerYAnchor.constraint(equalTo: titleArea.centerYAnchor),
            titleImage.widthAnchor.constraint(lessThanOrEqualTo: titleArea.widthAnchor , multiplier: 0.7),
            titleImage.widthAnchor.constraint(equalTo: titleArea.widthAnchor, multiplier: 0.6),
            titleImage.heightAnchor.constraint(equalTo: titleArea.heightAnchor , multiplier: 0.8)
        ])
        
        // Locations Area (Scroll)
        locationsArea.removeFromSuperview()
        informationArea.addArrangedSubview(locationsArea)
        NSLayoutConstraint.activate([
            locationsArea.heightAnchor.constraint(equalTo: self.view.heightAnchor ,multiplier: 0.05),
        ])
        
        // Characters Area
        charactersArea.removeFromSuperview()
        informationArea.addArrangedSubview(charactersArea)
        charactersArea.addArrangedSubview(missingLocationLbl)
        
        
        //Locations Container
        locationsContainer.removeFromSuperview()
        locationsArea.addSubview(locationsContainer)
        NSLayoutConstraint.activate([
            locationsContainer.leadingAnchor.constraint(equalTo: locationsArea.leadingAnchor),
            locationsContainer.trailingAnchor.constraint(equalTo: locationsArea.trailingAnchor),
            locationsContainer.topAnchor.constraint(equalTo: locationsArea.topAnchor),
            locationsContainer.bottomAnchor.constraint(equalTo: locationsArea.bottomAnchor),
            locationsContainer.heightAnchor.constraint(equalTo: locationsArea.heightAnchor)
        ])
        
        //Missing Location Label
        NSLayoutConstraint.activate([
            missingLocationLbl.topAnchor.constraint(equalTo: charactersArea.topAnchor,constant: 10)
        ])
    }
    
    func configureLandscape(){
        //Title Area
        titleArea.removeFromSuperview()
        container.addArrangedSubview(titleArea)
        NSLayoutConstraint.activate([
            titleArea.heightAnchor.constraint(equalTo: self.view.widthAnchor , multiplier: 0.17)
        ])
        
        //Information Area
        informationArea.removeFromSuperview()
        container.addArrangedSubview(informationArea)
        /*NSLayoutConstraint.activate([
            informationArea.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.8)
        ])*/
        
        //Title Image
        titleImage.removeFromSuperview()
        titleArea.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: titleArea.centerXAnchor),
            titleImage.centerYAnchor.constraint(equalTo: titleArea.centerYAnchor),
            titleImage.widthAnchor.constraint(lessThanOrEqualTo: titleArea.widthAnchor , multiplier: 0.7),
            titleImage.widthAnchor.constraint(equalTo: titleArea.widthAnchor, multiplier: 0.6),
            titleImage.heightAnchor.constraint(equalTo: titleArea.heightAnchor , multiplier: 0.8)
        ])
        
        // Locations Area (Scroll)
        locationsArea.removeFromSuperview()
        informationArea.addArrangedSubview(locationsArea)
        NSLayoutConstraint.activate([
            locationsArea.heightAnchor.constraint(equalTo: self.view.heightAnchor ,multiplier: 0.05),
        ])
        
        // Characters Area
        charactersArea.removeFromSuperview()
        informationArea.addArrangedSubview(charactersArea)
        charactersArea.addArrangedSubview(missingLocationLbl)
        
        
        //Locations Container
        locationsContainer.removeFromSuperview()
        locationsArea.addSubview(locationsContainer)
        NSLayoutConstraint.activate([
            locationsContainer.leadingAnchor.constraint(equalTo: locationsArea.leadingAnchor),
            locationsContainer.trailingAnchor.constraint(equalTo: locationsArea.trailingAnchor),
            locationsContainer.topAnchor.constraint(equalTo: locationsArea.topAnchor),
            locationsContainer.bottomAnchor.constraint(equalTo: locationsArea.bottomAnchor),
            locationsContainer.heightAnchor.constraint(equalTo: locationsArea.heightAnchor)
        ])
        
        //Missing Location Label
        NSLayoutConstraint.activate([
            missingLocationLbl.topAnchor.constraint(equalTo: charactersArea.topAnchor,constant: 10)
        ])
    }
}
