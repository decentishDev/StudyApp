//
//  SettingsVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 6/4/24.
//

import UIKit

class SettingsVC: UIViewController {

    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func setup(){
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        stackView.removeFromSuperview()
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -100)
        ])
        
        let backButton = UIButton()
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 20)
        backButton.addTarget(self, action: #selector(self.backButton(sender:)), for: .touchUpInside)
        backButton.setTitleColor(Colors.highlight, for: .normal)
        stackView.addArrangedSubview(backButton)
        
        let breakView0 = UIView()
        breakView0.widthAnchor.constraint(equalToConstant: 15).isActive = true
        breakView0.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(breakView0)
        
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Extrabold", size: 50)
        titleLabel.sizeToFit()
        titleLabel.textColor = Colors.text
        stackView.addArrangedSubview(titleLabel)
    }
    
    @objc func backButton(sender: UIButton){
        performSegue(withIdentifier: "settingsVC_unwind", sender: nil)
    }
    

    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
}
