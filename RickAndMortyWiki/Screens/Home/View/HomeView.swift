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
        locationsContainer.alignment = .leading
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
    
    //If a location button is clicked set all location buttons color
    func changeSelectedLocationStyle(_ id : Int){
        let locationComp : [LocationComp] = self.locationsContainer.arrangedSubviews as! [LocationComp]
        for i in locationComp{
            if(i.id == id){
                i.configuration?.background.backgroundColor = .init(named: "selectedLocationColor")
                i.setAttributedTitle(.init(string: i.title!,attributes: [.font:AppFonts.location , .foregroundColor : UIColor.white]), for:.normal)
            }
            else{
                i.configuration?.background.backgroundColor = .init(named: "dirtyWhite")
                i.setAttributedTitle(.init(string: i.title!,attributes: [.font:AppFonts.location , .foregroundColor : UIColor.black]), for:.normal)
            }
        }
    }
    
    //Setup character area such as characters or error messages
    func setCharactersArea() -> Status{
        if (self.vm.characterStatus == .LOADING){
            self.charactersArea.addArrangedSubview(self.loadingLbl)
        }
        else if (self.vm.characterStatus == .ERROR){
            self.charactersArea.addArrangedSubview(self.errorCharacterLbl)
        }
        else{
            var count = 0
            for j in self.vm.fetchedCharacters{
                let character : CharacterComp = .init(id: j.id, title: j.name, gender: j.gender, image: j.image, order: count){id in
                    self.vm.showCharacterDetailScreen(self.navigationController, 0, id: id)
                }
                character.translatesAutoresizingMaskIntoConstraints = false
                //Place character views
                self.charactersArea.addArrangedSubview(character)
                
                NSLayoutConstraint.activate([
                    character.widthAnchor.constraint(equalTo: charactersArea.widthAnchor,multiplier: 0.9),
                    character.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 0.15)
                ])
                count += 1
            }
        }
        self.locationsContainer.isUserInteractionEnabled = true
        return self.vm.characterStatus
    }
    
    //Fetch character and location from service
    func getData(){
        Task{
            self.charactersArea.addArrangedSubview(self.missingLocationLbl)
            
            await vm.fetchLocations()
            for i in vm.fetchedLocations{
                //Place location buttons
                self.locationsContainer.addArrangedSubview(LocationComp(title: i.name , id: i.id){id in
                    
                    //Make non-clickable buttons
                    self.locationsContainer.isUserInteractionEnabled = false
                    
                    //Change clicked button style
                    self.changeSelectedLocationStyle(id)
                    
                    let fetchTask = Task{
                        for k in self.charactersArea.arrangedSubviews{
                            k.removeFromSuperview()
                        }
                        //Remove old characters and place loading label
                        self.charactersArea.addArrangedSubview(self.loadingLbl)
                        
                        //Fetch characters
                        await self.vm.fetchCharacters(locationId:id)
                        
                        //Remove loading label
                        for k in self.charactersArea.arrangedSubviews{
                            k.removeFromSuperview()
                        }
    
                        //Set characters area
                        return self.setCharactersArea()
                        
                    }
                    
                    //If server doesn't respond then time out
                    Task {
                        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
                        
                        if await (fetchTask.result == .success(.LOADING)){
                            for k in self.charactersArea.arrangedSubviews{
                                k.removeFromSuperview()
                            }
                            self.charactersArea.addArrangedSubview(self.missingCharactersLbl)
                        }
                        self.locationsContainer.isUserInteractionEnabled = true
                        fetchTask.cancel()
                    }
                })
            }
        }
    }
    
    //Hide navigation bar when coming back from detail page
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    //Change constraints according to device orientation when rotating
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureCommon()
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
        scrollview.removeFromSuperview()
        self.view.addSubview(scrollview)
        NSLayoutConstraint.activate([
            scrollview.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        //Container
        container.removeFromSuperview()
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
        for i in charactersArea.arrangedSubviews{
            i.removeFromSuperview()
            charactersArea.addArrangedSubview(i)
            if(i is CharacterComp){
                NSLayoutConstraint.activate([
                    i.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
                    i.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
                ])
            }
        }
        
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
    }
    
    func configureLandscape(){
        //Title Area
        titleArea.removeFromSuperview()
        container.addArrangedSubview(titleArea)
        NSLayoutConstraint.activate([
            titleArea.heightAnchor.constraint(equalTo: self.view.heightAnchor , multiplier: 0.15),
        ])
        
        //Information Area
        informationArea.removeFromSuperview()
        container.addArrangedSubview(informationArea)
        
        //Title Image
        titleImage.removeFromSuperview()
        titleArea.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: titleArea.centerXAnchor),
            titleImage.centerYAnchor.constraint(equalTo: titleArea.centerYAnchor),
            titleImage.widthAnchor.constraint(lessThanOrEqualTo: titleArea.widthAnchor , multiplier: 0.7),
            titleImage.widthAnchor.constraint(equalTo: titleArea.widthAnchor, multiplier: 0.4),
            titleImage.heightAnchor.constraint(equalTo: titleArea.heightAnchor , multiplier: 0.8)
        ])
        
        // Locations Area (Scroll)
        locationsArea.removeFromSuperview()
        informationArea.addArrangedSubview(locationsArea)
        NSLayoutConstraint.activate([
            locationsArea.heightAnchor.constraint(equalTo: self.view.heightAnchor ,multiplier: 0.1),
        ])
        
        // Characters Area
        charactersArea.removeFromSuperview()
        informationArea.addArrangedSubview(charactersArea)
        for i in charactersArea.arrangedSubviews{
            i.removeFromSuperview()
            charactersArea.addArrangedSubview(i)
            if(i is CharacterComp){
                NSLayoutConstraint.activate([
                    i.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
                    i.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
                ])
            }
        }

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
    }
}
