//
//  MainPage.swift
//  StudyApp
//
//  Created by Tirth D. Patel on 4/16/24.
//
//
//  MainPage.swift
//  StudyApp
//
//  Created by Tirth D. Patel on 4/16/24.
//
import UIKit

class ViewController: UIViewController {
    var isDarkMode = false // State variable to track dark mode
    
    let buttonSize: CGFloat = 170 // Adjust button size here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = isDarkMode ? .black : .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Dendritic Learning"
        titleLabel.font = UIFont(name: "Times New Roman", size: 35)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        let darkModeToggle = UISwitch()
        view.addSubview(darkModeToggle)
        darkModeToggle.translatesAutoresizingMaskIntoConstraints = false
        darkModeToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        darkModeToggle.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        darkModeToggle.addTarget(self, action: #selector(toggleDarkMode), for: .valueChanged)
        
        let button1 = createButton(title: "Button 1", color: .blue)
        let button2 = createButton(title: "Button 2", color: .green)
        let flashcardsButton = createButton(title: "Flashcards", color: .red)
        let button4 = createButton(title: "Button 4", color: .orange)
        
        let stackView1 = UIStackView(arrangedSubviews: [button1, button2])
        stackView1.axis = .horizontal
        stackView1.spacing = 20
        stackView1.distribution = .fillEqually
        view.addSubview(stackView1)
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        let stackView2 = UIStackView(arrangedSubviews: [flashcardsButton, button4])
        stackView2.axis = .horizontal
        stackView2.spacing = 20
        stackView2.distribution = .fillEqually
        view.addSubview(stackView2)
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView2.bottomAnchor.constraint(equalTo: stackView1.topAnchor, constant: -20).isActive = true
    }
    
    @objc func toggleDarkMode(_ sender: UISwitch) {
        isDarkMode = sender.isOn
        view.backgroundColor = isDarkMode ? .black : .white
    }
    
    func createButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Handle button tap action here
    }
}
