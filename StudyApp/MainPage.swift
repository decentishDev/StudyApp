//
//  MainPage.swift
//  StudyApp
//
//  Created by Tirth D. Patel on 4/16/24.
//
import UIKit

class MainPage: UIViewController, NewSetDelegate {
//    var isDarkMode = false // State variable to track dark mode
    
    //let buttonSize: CGFloat = 170 // Adjust button size here
    
    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var destination = -1
    
    var sets: [[Any?]] = []
    
    var goToEditor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let theme = defaults.value(forKey: "theme") as? String{
            for j in Colors.themes {
                if j[0] as! String == theme {
                    Colors.background = j[1] as! UIColor
                    Colors.secondaryBackground = j[2] as! UIColor
                    Colors.darkHighlight = j[3] as! UIColor
                    Colors.highlight = j[4] as! UIColor
                    Colors.lightHighlight = j[5] as! UIColor
                    Colors.text = j[6] as! UIColor
                }
            }
        }
            
//        for family in UIFont.familyNames {
//            print("family: \(family)")
//            for name in UIFont.fontNames(forFamilyName: family){
//                print("        Font: \(name)~")
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setup()
    }
    
//    @objc func toggleDarkMode(_ sender: UISwitch) {
//        isDarkMode = sender.isOn
//        view.backgroundColor = isDarkMode ? .black : .white
//    }
    
    func setup(){
        sets = []
        if let data = defaults.value(forKey: "sets") as? [Dictionary<String, Any>]{
            //print("yeah")
            //print(data)
            for (index, i) in data.enumerated() {
//                if i["image"] != nil {
                sets.append([i["name"] as! String, i["type"] as! String, (defaults.value(forKey: "images") as! [Data?])[index]])
                    
//                }else{
//                    sets.append([i["name"] as! String, i["type"] as! String, nil])
//                }
            }
        }else{
            //PLACEHOLDER SETS - add blank stuff and 'create first set' screen soon
            
//            var revwar: Dictionary<String, Any> = Dictionary()
//            revwar["name"] = "American Revolution"
//            revwar["type"] = "web"
//            revwar["author"] = "mlundeen5270"
//            revwar["date"] = "Last edited: May 20th, 2024"
//            revwar["set"] = []
            var trivia: Dictionary<String, Any> = Dictionary()
            trivia["name"] = "Trivia"
            trivia["type"] = "standard"
            trivia["author"] = "mlundeen5270"
            trivia["flashcards"] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
            trivia["date"] = "Last edited: May 20th, 2024"
            trivia["learn"] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            trivia["set"] = [
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
                ["t", "Who was the first woman to ever win a Nobel Prize in the whole entire large global world?", "t", "Marie Curie"],
                ["t", "What is the capital of South Africa?", "t", "Pretoria"]
            ]
            trivia["version"] = Colors.version
            defaults.setValue([trivia], forKey: "sets")
            defaults.setValue([Colors.placeholderI] as [Data?], forKey: "images")
            sets.append(["Trivia", "standard", Colors.placeholderI])
            defaults.setValue(false, forKey: "fingerDrawing")
//            let image = UIImage(named: "samuel-branch-ZPVisr0s_hQ-unsplash.jpg")?.pngData()
//            sets.append(["American Revolution", "web", image])
        }
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        stackView.removeFromSuperview()
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        view.backgroundColor = Colors.background
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -60),
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -100)
        ])
        
        let topBar = UIView()
        //topBar.frame = CGRect(x: 0, y: 0, width: stackView.frame.width, height: 50)
        topBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(topBar)
        topBar.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        //topBar.translatesAutoresizingMaskIntoConstraints = false
        //topBar.backgroundColor = .red
        let icon = UIImageView(image: UIImage(named: "DendriticLearningIcon-01.svg")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = Colors.highlight
        icon.contentMode = .scaleAspectFit
        topBar.addSubview(icon)
        con(icon, 50, 50)
        icon.leadingAnchor.constraint(equalTo: topBar.leadingAnchor).isActive = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Dendritic Learning"
        titleLabel.textColor = Colors.text
        titleLabel.font = UIFont(name: "LilGrotesk-Black", size: 30)
        topBar.addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //titleLabel.backgroundColor = .green
        
        let settingsIcon = UIImageView()
        //settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsIcon.image = UIImage(systemName: "gear")
        settingsIcon.contentMode = .scaleAspectFit
        settingsIcon.tintColor = Colors.highlight
        settingsIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        topBar.addSubview(settingsIcon)
        settingsIcon.trailingAnchor.constraint(equalTo: topBar.trailingAnchor).isActive = true
        settingsIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let settingsButton = UIButton()
        //settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        topBar.addSubview(settingsButton)
        settingsButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor).isActive = true
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settings(_:)), for: .touchUpInside)
        
        let breakView0 = UIView()
        breakView0.widthAnchor.constraint(equalToConstant: 30).isActive = true
        breakView0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.addArrangedSubview(breakView0)
        
        let recentLabel = UILabel()
        recentLabel.text = "Your sets"
        recentLabel.font = UIFont(name: "LilGrotesk-Black", size: 50)
        con(recentLabel, 300, 50)
        recentLabel.textColor = Colors.text
        recentLabel.isUserInteractionEnabled = true
        stackView.addArrangedSubview(recentLabel)
        let newButton = UIButton()
        newButton.frame = CGRect(x: 250, y: 5, width: 40, height: 40)
        recentLabel.addSubview(newButton)
        newButton.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        newButton.contentHorizontalAlignment = .fill
        newButton.contentVerticalAlignment = .fill
        newButton.imageView?.contentMode = .scaleAspectFit
        newButton.tintColor = Colors.highlight
        newButton.addTarget(self, action: #selector(newSet(_:)), for: .touchUpInside)
        //recentLabel.backgroundColor = .purple
        if(sets.count > 0){
            for i in 0...((sets.count - 1)/3) {
                let row = UIStackView()
                row.axis = .horizontal
                row.spacing = 20
                row.alignment = .leading
                row.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(row)
                NSLayoutConstraint.activate([
                    row.widthAnchor.constraint(equalTo: stackView.widthAnchor),
                    row.heightAnchor.constraint(equalToConstant: 100)
                ])
                for j in 3*i...(3*i) + 2 {
                    if(sets.count > j){
                        let setView = UIView()
                        row.addArrangedSubview(setView)
                        var image = UIImageView()
                        if sets[j][2] as? Data != Colors.placeholderI {
                            image = UIImageView(image: UIImage(data: sets[j][2] as! Data))
                            image.layer.cornerRadius = 10
                            image.contentMode = .scaleAspectFill
                            image.clipsToBounds = true
                        }else{
                            setView.backgroundColor = Colors.secondaryBackground
                        }
                        setView.addSubview(image)
                        let setLabel = UILabel()
                        setLabel.text = sets[j][0] as? String
                        setView.addSubview(setLabel)
                        image.translatesAutoresizingMaskIntoConstraints = false
                        setView.translatesAutoresizingMaskIntoConstraints = false
                        setLabel.translatesAutoresizingMaskIntoConstraints = false
                        setLabel.textColor = Colors.text
                        setLabel.textAlignment = .center
                        setLabel.font = UIFont(name: "LilGrotesk-Regular", size: 25)
                        setView.layer.cornerRadius = 10
                        let setButton = UIButton()
                        setButton.accessibilityIdentifier = String(j)
                        setButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                        setButton.translatesAutoresizingMaskIntoConstraints = false
                        setView.addSubview(setButton)
                        NSLayoutConstraint.activate([
                            setView.widthAnchor.constraint(equalToConstant: (view.frame.width - 160)/3),
                            setView.heightAnchor.constraint(equalTo: row.heightAnchor),
                            setLabel.topAnchor.constraint(equalTo: setView.topAnchor),
                            setLabel.bottomAnchor.constraint(equalTo: setView.bottomAnchor),
                            setLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor),
                            setLabel.trailingAnchor.constraint(equalTo: setView.trailingAnchor),
                            setButton.topAnchor.constraint(equalTo: setView.topAnchor),
                            setButton.bottomAnchor.constraint(equalTo: setView.bottomAnchor),
                            setButton.leadingAnchor.constraint(equalTo: setView.leadingAnchor),
                            setButton.trailingAnchor.constraint(equalTo: setView.trailingAnchor),
                            image.topAnchor.constraint(equalTo: setView.topAnchor),
                            image.bottomAnchor.constraint(equalTo: setView.bottomAnchor),
                            image.leadingAnchor.constraint(equalTo: setView.leadingAnchor),
                            image.trailingAnchor.constraint(equalTo: setView.trailingAnchor),
                        ])
                    }else{
                        let setView = UIView()
                        row.addArrangedSubview(setView)
                        NSLayoutConstraint.activate([
                            setView.widthAnchor.constraint(equalToConstant: (view.frame.width - 160)/3),
                            setView.heightAnchor.constraint(equalTo: row.heightAnchor),
                        ])
                    }
                }
            }
        }
    }
    
//    func createButton(title: String, color: UIColor) -> UIButton {
//        let button = UIButton()
//        button.setTitle(title, for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = color
//        button.layer.cornerRadius = 25
//        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.white.cgColor
//        return button
//    }
    
    @objc func newSet(_ sender: UIButton){
        print("hi")
        let popupVC = NewSetVC()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func settings(_ sender: UIButton){
        performSegue(withIdentifier: "settingsVC", sender: nil)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "viewStandardSet", sender: self)
        //performSegue(withIdentifier: "viewWebSet", sender: self)
        destination = Int(sender.accessibilityIdentifier!)!
        if(sets[Int(sender.accessibilityIdentifier!)!][1] as! String == "standard"){
                self.performSegue(withIdentifier: "viewStandardSet", sender: self)
        }else{
                performSegue(withIdentifier: "viewWebSet", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if(destination == -1){
            //guard let vc = segue.destination as? SettingsVC else {return}
            //idk
        }else if(sets[destination][1] as! String == "standard"){
            guard let vc = segue.destination as? StandardSetVC else {return}
            if(goToEditor){
                vc.goToEditor = true
            }
            vc.set = destination
        }else{
            guard let vc = segue.destination as? WebSetVC else {return}
            if(goToEditor){
                vc.goToEditor = true
            }
            vc.set = destination
        }
        goToEditor = false
        destination = -1
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
    
    func newSetType(type: String){
        if(type == "Standard"){
            goToEditor = true
            destination = sets.count
            var trivia: Dictionary<String, Any> = Dictionary()
            trivia["name"] = "New Set"
            trivia["type"] = "standard"
            trivia["author"] = "mlundeen5270"
            trivia["flashcards"] = [false]
            trivia["date"] = "Last edited: " + dateString()
            trivia["image"] = Colors.placeholderI
            trivia["set"] = [["t", "Example term", "t", "Example definition"]]
            trivia["learn"] = [0]
            trivia["version"] = Colors.version
            sets.append(["New Set", "standard", Colors.placeholderI])
            var oldData = defaults.value(forKey: "sets") as! [Any]
            oldData.append(trivia)
            defaults.setValue(oldData, forKey: "sets")
            var images = (defaults.value(forKey: "images") as! [Data?])
            images.append(Colors.placeholderI)
            defaults.setValue(images, forKey: "images")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.performSegue(withIdentifier: "viewStandardSet", sender: self)
                //goToEditor = false
            }
        }else if(type == "Web"){
            goToEditor = true
            destination = sets.count
            var revwar: Dictionary<String, Any> = Dictionary()
            revwar["name"] = "New Web"
            revwar["type"] = "web"
            revwar["author"] = "mlundeen5270"
            revwar["date"] = "Last edited: " + dateString()
            revwar["set"] = []
            revwar["version"] = Colors.version
            sets.append(["New Web", "web", Colors.placeholderI])
            var oldData = defaults.value(forKey: "sets") as! [Any]
            oldData.append(revwar)
            defaults.setValue(oldData, forKey: "sets")
            var images = (defaults.value(forKey: "images") as! [Data?])
            images.append(Colors.placeholderI)
            defaults.setValue(images, forKey: "images")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.performSegue(withIdentifier: "viewWebSet", sender: self)
            }
            //goToEditor = false
        }
    }
    
    func newImport() {
        setup()
    }
}
