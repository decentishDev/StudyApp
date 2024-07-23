//
//  WelcomeVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 7/23/24.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let centeredView = UIView(frame: CGRect(x: (view.frame.width/2) - 300, y: (view.frame.height/2) - 300, width: 600, height: 600))
        view.addSubview(centeredView)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        centeredView.backgroundColor = Colors.background
        centeredView.layer.cornerRadius = 20
        
        let confirmButton = UIButton()
        confirmButton.setTitle("Start learning", for: .normal)
        centeredView.addSubview(confirmButton)
        confirmButton.setTitleColor(Colors.text, for: .normal)
        confirmButton.backgroundColor = Colors.highlight
        confirmButton.layer.cornerRadius = 5
        confirmButton.frame = CGRect(x: 40, y: 480, width: 520, height: 80)
        confirmButton.addTarget(self, action: #selector(startButton(_:)), for: .touchUpInside)
        confirmButton.titleLabel!.font = UIFont(name: "LilGrotesk-Regular", size: 25)
        
        let topLabel = UILabel(frame: CGRect(x: 40, y: 40, width: 520, height: 120))
        topLabel.text = "Welcome to\nDendritic Learning"
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        topLabel.font = UIFont(name: "LilGrotesk-Black", size: 42)
        topLabel.textColor = Colors.text
        centeredView.addSubview(topLabel)
        
        let middleLabel = UILabel(frame: CGRect(x: 40, y: 120, width: 520, height: 360))
        middleLabel.text = "Through non-linear web sets, drawing tools, writing recognition, and uninterrupted simple features, we aim to improve your study habits.\n\nThis is the first public version of the offline version of the app. We're currently working on a lot of new features, but feel free to contact us about any bugs or issues you encounter.\n\nThank you for downloading."
        middleLabel.numberOfLines = 0
        middleLabel.textAlignment = .center
        middleLabel.font = UIFont(name: "LilGrotesk-Regular", size: 20)
        middleLabel.textColor = Colors.text
        centeredView.addSubview(middleLabel)
    }
    
    @objc func startButton(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }

}
