//
//  HomeView.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import UIKit

class HomeView : UIViewController {
    let scrollview : UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.backgroundColor = .init(named: "mainBackgroundColor")
        scrollview.bounces = true
        scrollview.autoresizingMask = []
        return scrollview
    }()
    
    let titleArea : UIView = {
        let titleArea = UIView()
        titleArea.translatesAutoresizingMaskIntoConstraints = false
        return titleArea
    }()
    
    let informationArea : UIView = {
        let informationArea = UIView()
        informationArea.backgroundColor = .green
        informationArea.translatesAutoresizingMaskIntoConstraints = false
        return informationArea
    }()
    
    let titleImage : UIImageView = {
        let titleImage = UIImageView(image: UIImage.init(named: "titleImage"))
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollview.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollview.contentSize = size
        
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
    }
    
    func configureCommon(){
        navigationController?.isNavigationBarHidden = true
        
        //Scroll View
        self.view.addSubview(scrollview)
        scrollview.frame = self.view.bounds
        scrollview.contentSize = self.view.bounds.size
    }
    
    func configurePortrait() {
        //Title Area
        titleArea.removeFromSuperview()
        scrollview.addSubview(titleArea)
        NSLayoutConstraint.activate([
            titleArea.topAnchor.constraint(equalTo: scrollview.topAnchor),
            titleArea.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            titleArea.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            titleArea.heightAnchor.constraint(equalTo: scrollview.heightAnchor, multiplier: 0.1)
        ])
        
        //Information Area
        informationArea.removeFromSuperview()
        scrollview.addSubview(informationArea)
        NSLayoutConstraint.activate([
            informationArea.topAnchor.constraint(equalTo: titleArea.bottomAnchor),
            informationArea.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            informationArea.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            informationArea.heightAnchor.constraint(equalTo: scrollview.heightAnchor, multiplier: 0.9)
        ])
        
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
    }
    
    func configureLandscape(){
        //Title Area
        titleArea.removeFromSuperview()
        scrollview.addSubview(titleArea)
        NSLayoutConstraint.activate([
            titleArea.topAnchor.constraint(equalTo: scrollview.topAnchor),
            titleArea.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            titleArea.heightAnchor.constraint(equalTo: scrollview.heightAnchor, multiplier: 0.15)
        ])
        
        //Information Area
        informationArea.removeFromSuperview()
        scrollview.addSubview(informationArea)
        NSLayoutConstraint.activate([
            informationArea.topAnchor.constraint(equalTo: titleArea.bottomAnchor),
            informationArea.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            informationArea.heightAnchor.constraint(equalTo: scrollview.heightAnchor, multiplier: 0.85)
        ])
        
        //Title Image
        titleImage.removeFromSuperview()
        titleArea.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: titleArea.centerXAnchor),
            titleImage.centerYAnchor.constraint(equalTo: titleArea.centerYAnchor),
            titleImage.widthAnchor.constraint(equalTo: titleArea.widthAnchor , multiplier: 0.3),
            titleImage.heightAnchor.constraint(equalTo: titleArea.heightAnchor , multiplier: 0.8)
        ])
    }
}
