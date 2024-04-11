//
//  StandardSetVC.swift
//  StudyApp
//
//  Created by Matthew J. Lundeen on 4/9/24.
//

import UIKit

class StandardSetVC: UIViewController {

    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var cards: [[Any]] = [ //t: text, d: drawing, s: speech - maybe
        ["t", "What is the boiling point of water in Celsius?", "t", "100°C"],
        ["t", "Who wrote the novel 'Pride and Prejudice'?", "t", "Jane Austen"],
        ["t", "What is the chemical symbol for gold?", "t", "Au"],
        ["t", "What is the tallest mountain in the world?", "t", "Mount Everest"],
        ["t", "What year did the Titanic sink?", "t", "1912"],
        ["t", "What is the capital of Brazil?", "t", "Brasília"],
        ["t", "Who painted the 'Mona Lisa'?", "t", "Leonardo da Vinci"],
        ["t", "What is the currency of Japan?", "t", "Japanese yen"],
        ["t", "What is the largest mammal in the world?", "t", "Blue whale"],
        ["t", "What is the chemical formula for water?", "t", "H2O"],
        ["t", "Who discovered penicillin?", "t", "Alexander Fleming"],
        ["t", "What is the main ingredient in guacamole?", "t", "Avocado"],
        ["t", "What is the capital of Australia?", "t", "Canberra"],
        ["t", "What is the square root of 144?", "t", "12"],
        ["t", "Who wrote 'To Kill a Mockingbird'?", "t", "Harper Lee"],
        ["t", "What is the chemical symbol for iron?", "t", "Fe"],
        ["t", "What is the largest ocean on Earth?", "t", "Pacific Ocean"],
        ["t", "What is the speed of light in a vacuum?", "t", "299,792,458 meters per second"],
        ["t", "Who was the first woman to win a Nobel Prize?", "t", "Marie Curie"],
        ["t", "What is the capital of South Africa?", "t", "Pretoria"]
    ]
    let name: String = "Trivia"
    let date: String = "Last edited: April 10th, 2024"
    let cabinetGrotesk: [UIFont] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //["CabinetGroteskVariable-Bold_Regular", "CabinetGroteskVariable-Bold_Thin", "CabinetGroteskVariable-Bold_Extralight", "CabinetGroteskVariable-Bold_Light", "CabinetGroteskVariable-Bold_Medium", "CabinetGroteskVariable-Bold_Bold", "CabinetGroteskVariable-Bold_Extrabold", "CabinetGroteskVariable-Bold"]
        
    }
    
    func setup(){
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
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
        
        // Add buttons
        let learnButton = createButton(withTitle: "Learn")
        let flashcardsButton = createButton(withTitle: "Flashcards")
        let testButton = createButton(withTitle: "Test")
		
        let buttonsStackView = UIStackView(arrangedSubviews: [learnButton, flashcardsButton, testButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillProportionally
        stackView.addArrangedSubview(buttonsStackView)
        
        let breakView2 = UIView()
        breakView2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        breakView2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        breakView2.backgroundColor = .clear
        stackView.addArrangedSubview(breakView2)
        
        let termsLabel = UILabel()
        termsLabel.text = "Terms"
        termsLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 30)
        termsLabel.sizeToFit()
        stackView.addArrangedSubview(termsLabel)
        
        let allTermsStackView = UIStackView()
        allTermsStackView.axis = .vertical
        allTermsStackView.spacing = 5
        for card in cards {
            guard card.count == 4,
                  let term = card[1] as? String,
                  let definition = card[3] as? String else {
                continue
            }
            let termLabel = UILabel()
            termLabel.text = term
            termLabel.numberOfLines = 0
            termLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 20)

            let definitionLabel = UILabel()
            definitionLabel.text = definition
            definitionLabel.numberOfLines = 0
            definitionLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 20)
            
            let termDefinitionStackView = UIStackView()
            termDefinitionStackView.isLayoutMarginsRelativeArrangement = true
            termDefinitionStackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            
            let breakView = UIView()
            breakView.backgroundColor = .label.withAlphaComponent(0.5)
            breakView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            
            termDefinitionStackView.addArrangedSubview(termLabel)
            termDefinitionStackView.addArrangedSubview(breakView)
            termDefinitionStackView.addArrangedSubview(definitionLabel)
            
            termDefinitionStackView.axis = .horizontal
            termDefinitionStackView.spacing = 10
            allTermsStackView.addArrangedSubview(termDefinitionStackView)
            breakView.heightAnchor.constraint(equalTo: termLabel.heightAnchor, multiplier: 1).isActive = true
            
            
            // Apply blur effect
            let blurEffect = UIBlurEffect(style: .systemThinMaterial)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = termDefinitionStackView.frame
            blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurredEffectView.layer.cornerRadius = 10
            blurredEffectView.clipsToBounds = true
            termDefinitionStackView.insertSubview(blurredEffectView, at: 0)
        }
        stackView.addArrangedSubview(allTermsStackView)
        NSLayoutConstraint.activate([
            allTermsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            allTermsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 30)
//        button.backgroundColor = UIColor(white: 1, alpha: 0.5) // Adjust alpha for transparency
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.layer.masksToBounds = true

        // Apply blur effect
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = button.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.insertSubview(blurredEffectView, at: 0)

        return button
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "Learn":
            startLearn()
        case "Flashcards":
            startFlashcards()
        case "Test":
            startTest()
        default:
            break
        }
    }

    @objc func startLearn() {
        // Implement action for learn mode button
    }

    @objc func startFlashcards() {
        // Implement action for flashcards mode button
    }

    @objc func startTest() {
        // Implement action for test mode button
    }
}
