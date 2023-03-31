//
//  SplashView.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import UIKit

class SplashView : UIViewController {
    let vm = SplashViewModel()
    
    override func viewDidLoad() {
        self.configure()
        vm.showHomeScreen(self.navigationController,3)
    }
    
    func configure(){
        //Background image
        let bgImage = UIImageView.init(image: UIImage.init(named: "splashBackground"))
        view.addSubview(bgImage)
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        //Greeting Text
        let greetingText = UILabel()
        greetingText.text = vm.getGreetingMessage()
        greetingText.font = AppFonts.title
        greetingText.textColor = .init(named: "dirtyWhite")
        view.addSubview(greetingText)
        greetingText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greetingText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingText.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100)
        ])
    }
}
