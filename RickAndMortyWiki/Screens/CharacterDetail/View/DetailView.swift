//
//  DetailView.swift
//  RickAndMortyWiki
//
//  Created by Harun on 17.04.2023.
//

import UIKit

class DetailView : UIViewController {
    var vm  = DetailViewModel()
    var id = 0
    var infos : [String] = []
    
    let container : UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .init(named: "mainBackgroundColor")
        container.distribution = .fill
    
        return container
    }()
    
    let titleAndImageArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let infoArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let spaceHead : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLbl : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Harun Eren"
        lbl.textColor = .init(named: "dirtyWhite")
        lbl.font = AppFonts.characterDetailTitle
        return lbl
    }()
    
    let characterImage : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let characterInfoStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .equalSpacing
        return stack
    }()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //Set constrainst according to orientation
        if(UIDevice.current.orientation == .portrait){
            configurePortrait()
        }
        else if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight){
            configureLandscape()
        }
    }
    
    func getCharacterDetails(){
        Task{
            //Fetch character details
            await vm.fetchCharacterDetail(id: self.id)
            
            //Set character detail title
            titleLbl.text = vm.fetchedCharacter?.name
            
            //Set character image
            self.characterImage.load(url: URL(string: (vm.fetchedCharacter?.image)!)!)
            
            
            //Set informarion strings
            var statusStr = "Status:\t\t" + (vm.fetchedCharacter?.status ?? "")
            var specyStr = "Specy:\t\t" + (vm.fetchedCharacter?.species.description ?? "")
            var genderStr = "Gender:\t\t" + (vm.fetchedCharacter?.gender ?? "")
            var originStr = "Origin:\t\t" + (vm.fetchedCharacter?.origin.name ?? "")
            var locationStr = "Location:\t" + (vm.fetchedCharacter?.location.name ?? "")
            
            //Parse episodes url array
            var episodeStr : String = "Episode:\t"
            for i in vm.fetchedCharacter!.episode{
                episodeStr += i.components(separatedBy: "episode/")[1].components(separatedBy: "\\")[0] + ","
            }
            episodeStr.removeLast()
            
            //Parse created time
            var createdStr = ""
            let timeCr = (vm.fetchedCharacter?.created ?? "").components(separatedBy: "T")
            if ( timeCr.count >= 2){
                createdStr = "Created at (in API) : " + timeCr[0] + " " + timeCr[1].dropLast(5)
            }
            else{
                createdStr = "Created at \n(in API) : "
            }
            

            //Append strings to list to place stack
            infos.append(statusStr)
            infos.append(specyStr)
            infos.append(genderStr)
            infos.append(originStr)
            infos.append(locationStr)
            infos.append(episodeStr)
            infos.append(createdStr)
            
            //Place labels
            for i in self.infos{
                
                let midIndex = i.distance(from: i.startIndex, to: i.firstIndex(of: ":")!) + 1
                let attributedString = NSMutableAttributedString(string: i)
                
                // Left bold
                let boldFont = AppFonts.characterInfoLeft
                attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: midIndex))

                // Right light
                let lightFont = AppFonts.characterInfoRight
                attributedString.addAttribute(.font, value: lightFont, range: NSRange(location: midIndex, length: i.count - midIndex))

                let lbl = UILabel()
                lbl.text = i
                lbl.textColor = .white
                lbl.numberOfLines = 2
                lbl.attributedText = attributedString
                
                characterInfoStack.addArrangedSubview(lbl)
            }
            
        }
    }
    
    override func viewDidLoad() {
        getCharacterDetails()
        configureCommon()
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        if(UIDevice.current.orientation == .portrait || windowScene?.interfaceOrientation == .portrait ){
            configurePortrait()
        }
        else if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || windowScene?.interfaceOrientation == .landscapeLeft || windowScene?.interfaceOrientation == .landscapeRight){
            configureLandscape()
        }
        
    }
    
    func configureCommon(){
        //Configure back button
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.items![0].backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    
    }
    
    func configurePortrait() {
        //Container
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        //Top area
        container.addArrangedSubview(titleAndImageArea)
        NSLayoutConstraint.activate([
            titleAndImageArea.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.55)
        ])
        
        //Info area
        container.addArrangedSubview(infoArea)
        
        
        //Character Imge
        titleAndImageArea.addSubview(characterImage)
        NSLayoutConstraint.activate([
            characterImage.heightAnchor.constraint(equalToConstant: 275),
            characterImage.leadingAnchor.constraint(equalTo: titleAndImageArea.leadingAnchor, constant: 50),
            characterImage.trailingAnchor.constraint(equalTo: titleAndImageArea.trailingAnchor, constant: -50),
            characterImage.bottomAnchor.constraint(equalTo: titleAndImageArea.bottomAnchor, constant: -20)
        ])
        
        //Title
        titleAndImageArea.addSubview(titleLbl)
        NSLayoutConstraint.activate([
            titleLbl.bottomAnchor.constraint(equalTo: characterImage.topAnchor,constant: -20),
            titleLbl.centerXAnchor.constraint(equalTo: titleAndImageArea.centerXAnchor)
        ])
        
        //Character Info Stack
        infoArea.addSubview(characterInfoStack)
        NSLayoutConstraint.activate([
            characterInfoStack.topAnchor.constraint(equalTo: infoArea.topAnchor),
            characterInfoStack.bottomAnchor.constraint(equalTo: infoArea.bottomAnchor, constant: -20),
            characterInfoStack.leadingAnchor.constraint(equalTo: infoArea.leadingAnchor,constant: 20),
            characterInfoStack.trailingAnchor.constraint(equalTo: infoArea.trailingAnchor,constant: -20)
        ])

    }
    
    func configureLandscape(){
        
    }
}
