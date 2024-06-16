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
    
    var colorSegment = UISegmentedControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    func setup() {
        view.backgroundColor = Colors.background
        // Clear any existing views
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        stackView.removeFromSuperview()
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        // Configure stackView and scrollView
        stackView.axis = .vertical
        stackView.spacing = 10
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
        
        // Add other subviews
        let backButton = UIButton()
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel!.font = UIFont(name: "LilGrotesk-Bold", size: 20)
        backButton.addTarget(self, action: #selector(self.backButton(sender:)), for: .touchUpInside)
        backButton.setTitleColor(Colors.highlight, for: .normal)
        stackView.addArrangedSubview(backButton)
        
        let breakView0 = UIView()
        breakView0.widthAnchor.constraint(equalToConstant: 15).isActive = true
        breakView0.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(breakView0)
        
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont(name: "LilGrotesk-Black", size: 50)
        titleLabel.sizeToFit()
        titleLabel.textColor = Colors.text
        stackView.addArrangedSubview(titleLabel)
        
        let breakView01 = UIView()
        breakView01.widthAnchor.constraint(equalToConstant: 15).isActive = true
        breakView01.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(breakView01)
        
        let colorLabel = UILabel()
        colorLabel.text = "Color theme"
        colorLabel.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        colorLabel.sizeToFit()
        colorLabel.textColor = Colors.text
        stackView.addArrangedSubview(colorLabel)
        
        // Setup horizontal scroll view for color themes
        let colorScroll = UIScrollView()
        colorScroll.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(colorScroll)
        
        let colorStack = UIStackView()
        colorStack.axis = .horizontal
        colorStack.spacing = 10
        colorStack.alignment = .leading
        colorScroll.addSubview(colorStack)
        colorStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            colorScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            colorScroll.heightAnchor.constraint(equalToConstant: 100),
            
            colorStack.topAnchor.constraint(equalTo: colorScroll.topAnchor),
            colorStack.bottomAnchor.constraint(equalTo: colorScroll.bottomAnchor),
            colorStack.leadingAnchor.constraint(equalTo: colorScroll.leadingAnchor),
            colorStack.trailingAnchor.constraint(equalTo: colorScroll.trailingAnchor)
        ])
        
        for (i, color) in Colors.themes.enumerated() {
            let button = UIButton()
            button.widthAnchor.constraint(equalToConstant: 200).isActive = true
            button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            button.backgroundColor = color[2] as? UIColor
            button.setTitle(color[0] as? String, for: .normal)
            button.setTitleColor(color[5] as? UIColor, for: .normal)
            button.titleLabel!.font = UIFont(name: "LilGrotesk-Regular", size: 20)
            button.layer.cornerRadius = 10
            colorStack.addArrangedSubview(button)
            button.accessibilityIdentifier = String(i)
            button.addTarget(self, action: #selector(self.themeButton(sender:)), for: .touchUpInside)
        }
        
        let breakView02 = UIView()
        breakView02.widthAnchor.constraint(equalToConstant: 15).isActive = true
        breakView02.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(breakView02)
        
        let pencilLabel = UILabel()
        pencilLabel.text = "Allows drawing with fingers"
        pencilLabel.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        pencilLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 40)
        con(pencilLabel, view.frame.width - 100, 40)
        pencilLabel.textColor = Colors.text
        stackView.addArrangedSubview(pencilLabel)
        //pencilLabel.backgroundColor = .red
        pencilLabel.clipsToBounds = false
        pencilLabel.isUserInteractionEnabled = true
        
        let pencilSwitch = UISwitch(frame: CGRect(x: view.frame.width - 100 - 55, y: 5, width: 40, height: 40))
        pencilLabel.addSubview(pencilSwitch)
        pencilSwitch.isOn = defaults.value(forKey: "fingerDrawing")  as! Bool 
        pencilSwitch.addTarget(self, action: #selector(self.pencilSwitched(sender:)), for: .valueChanged)
        pencilSwitch.isUserInteractionEnabled = true
        //pencilSwitch.backgroundColor = .green
    }

    @objc func themeButton(sender: UIButton){
        let i = Int(sender.accessibilityIdentifier!)!
        defaults.set(Colors.themes[i][0] as! String, forKey: "theme")
        Colors.background = Colors.themes[i][1] as! UIColor
        Colors.secondaryBackground = Colors.themes[i][2] as! UIColor
        Colors.darkHighlight = Colors.themes[i][3] as! UIColor
        Colors.highlight = Colors.themes[i][4] as! UIColor
        Colors.lightHighlight = Colors.themes[i][5] as! UIColor
        Colors.text = Colors.themes[i][6] as! UIColor
        setup()
    }
    
    @objc func pencilSwitched(sender: UISwitch){
        defaults.setValue(sender.isOn, forKey: "fingerDrawing")
    }
    
    @objc func backButton(sender: UIButton){
        performSegue(withIdentifier: "settingsVC_unwind", sender: nil)
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
}
