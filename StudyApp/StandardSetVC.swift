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
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
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
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.frame = CGRect(x: 0, y: 0, width: stackView.frame.width, height: 50)
        stackView.addArrangedSubview(titleLabel)
        
        let buttonsView = UIStackView(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        stackView.addArrangedSubview(buttonsView)
        buttonsView.axis = .horizontal
        buttonsView.spacing = 10
        buttonsView.alignment = .fill
        
        let flashcardsButton = UIButton()
        flashcardsButton.backgroundColor = .secondarySystemBackground
        flashcardsButton.layer.cornerRadius = 5
        flashcardsButton.frame = CGRect(x: 0, y: 0, width: 100, height: buttonsView.frame.height)
        flashcardsButton.setTitle("Flashcards", for: .normal)
        buttonsView.addArrangedSubview(flashcardsButton)
        let learnButton = UIButton()
        learnButton.backgroundColor = .secondarySystemBackground
        learnButton.layer.cornerRadius = 5
        learnButton.frame = CGRect(x: 0, y: 0, width: 100, height: buttonsView.frame.height)
        learnButton.setTitle("Learn", for: .normal)
        buttonsView.addArrangedSubview(learnButton)
        
        let allTermsStackView = UIStackView()
        allTermsStackView.axis = .vertical
        allTermsStackView.spacing = 5
        print(learnButton.frame)
        print(flashcardsButton.frame)
        print(buttonsView.frame)
        for card in cards {
            guard card.count == 4,
                  let term = card[1] as? String,
                  let definition = card[3] as? String else {
                continue
            }
            let termLabel = UILabel()
            termLabel.text = term
            termLabel.numberOfLines = 0
            let definitionLabel = UILabel()
            definitionLabel.text = definition
            definitionLabel.numberOfLines = 0
            let termDefinitionStackView = UIStackView(arrangedSubviews: [termLabel, definitionLabel])
            termDefinitionStackView.axis = .horizontal
            termDefinitionStackView.spacing = 10
            allTermsStackView.addArrangedSubview(termDefinitionStackView)
        }
        stackView.addArrangedSubview(allTermsStackView)
    }
}
