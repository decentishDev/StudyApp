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
        ["t", "What is the capital of South Africa?", "t", "Pretoria"],
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
        stackView.spacing = 5
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        titleLabel.font = .boldSystemFont(ofSize: 30)
        stackView.addArrangedSubview(titleLabel)
        let buttonsView = UIView()
        stackView.addArrangedSubview(buttonsView)
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let flashcardsButton = UIButton()
        flashcardsButton.backgroundColor = .red
        let learnButton = UIButton()
        learnButton.backgroundColor = .green
        buttonsView.addSubview(flashcardsButton)
        buttonsView.addSubview(learnButton)
        flashcardsButton.frame = CGRect(x: 0, y: 0, width: buttonsView.frame.width / 2, height: buttonsView.frame.height)
        learnButton.frame = CGRect(x: buttonsView.frame.width / 2, y: 0, width: buttonsView.frame.width / 2, height: buttonsView.frame.height)
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
            let definitionLabel = UILabel()
            definitionLabel.text = definition
            definitionLabel.numberOfLines = 0
            let termDefinitionStackView = UIStackView(arrangedSubviews: [termLabel, definitionLabel])
            termDefinitionStackView.axis = .horizontal
            termDefinitionStackView.spacing = 10
            allTermsStackView.addArrangedSubview(termDefinitionStackView)
        }
    }
}
