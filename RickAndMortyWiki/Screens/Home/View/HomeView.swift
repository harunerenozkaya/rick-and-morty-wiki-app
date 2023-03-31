//
//  HomeView.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import UIKit

class HomeView : UIViewController {
    override func viewDidLoad() {
        configure()
    }
    
    func configure() {
        navigationController?.isNavigationBarHidden = true
        
        //Scroll View
        let scrollview = UIScrollView(frame: .zero)
        self.view.addSubview(scrollview)
        scrollview.backgroundColor = .init(named: "mainBackgroundColor")
        scrollview.frame = self.view.bounds
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        scrollview.autoresizingMask = .flexibleHeight
        scrollview.bounces = true
        
        //Title Area
        let titleArea = UIView()
        scrollview.addSubview(titleArea)
        titleArea.backgroundColor = .red
        titleArea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleArea.topAnchor.constraint(equalTo: scrollview.topAnchor),
            titleArea.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            titleArea.heightAnchor.constraint(equalTo: scrollview.heightAnchor,multiplier: 0.1),
        ])
        
        //Information Area
        let informationArea = UIView()
        scrollview.addSubview(informationArea)
        informationArea.backgroundColor = .green
        informationArea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationArea.topAnchor.constraint(equalTo: titleArea.bottomAnchor),
            informationArea.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            informationArea.heightAnchor.constraint(equalTo: scrollview.heightAnchor,multiplier: 0.9),
        ])
    }
}
