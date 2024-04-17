//
//  WebSetVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/13/24.
//

import UIKit

class WebSetVC: UIViewController {

    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    let web = 0 //No need to pass actual web with the content since we can't view it on this screen
    
    let name: String = "Revolutionary War"
    let date: String = "Last edited: April 14th, 2024"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let backgroundImage = UIImageView(image: UIImage(named: "pawel-czerwinski-rsaHwOFpmRI-unsplash"))
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        backButton.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Normal", size: 20)
        backButton.addTarget(self, action: #selector(self.backButton(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(backButton)
        
        let breakView0 = UIView()
        breakView0.widthAnchor.constraint(equalToConstant: 15).isActive = true
        breakView0.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(breakView0)
        
        let titleLabel = UILabel()
        titleLabel.text = name
        titleLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Extrabold", size: 50)
        titleLabel.sizeToFit()
        stackView.addArrangedSubview(titleLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Light", size: 20)
        dateLabel.sizeToFit()
        stackView.addArrangedSubview(dateLabel)
        
        let breakView1 = UIView()
        breakView1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        breakView1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.addArrangedSubview(breakView1)
        
        let viewButton = createButton(withTitle: "View")
        let studyButton = createButton(withTitle: "Study")
        let editButton = createButton(withTitle: "Edit")
        
        let buttonsStackView = UIStackView(arrangedSubviews: [viewButton, studyButton, editButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillProportionally
        stackView.addArrangedSubview(buttonsStackView)
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.layer.masksToBounds = true

        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = button.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.insertSubview(blurredEffectView, at: 0)

        return button
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "View":
            viewWeb()
        case "Study":
            studyWeb()
        case "Edit":
            editWeb()
        default:
            break
        }
    }

    @objc func viewWeb() {
        print("view")
    }

    @objc func studyWeb() {
        print("study")
    }

    @objc func editWeb() {
        print("edit")
    }
    
    @objc func backButton(sender: UIButton){
        print("back")
        performSegue(withIdentifier: "webSetVC_unwind", sender: nil)
    }
    
}
