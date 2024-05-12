//
//  WebSetVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/13/24.
//

import UIKit

class WebSetVC: UIViewController {

    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var set = 0 //No need to pass actual web with the content since we can't view it on this screen
    
    var name: String = ""
    var date: String = ""
    
    var image: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //cards = data["set"] as! [[Any]]
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func setup(){
        
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        //print(data)
        name = data["name"] as! String
        date = data["date"] as! String
        image = data["image"] as! Data?
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        stackView.removeFromSuperview()
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        if(image == nil){
            view.backgroundColor = Colors.background
        }else{
            let backgroundImage = UIImageView(image: UIImage(data: image!))
            backgroundImage.contentMode = .scaleAspectFill
            view.addSubview(backgroundImage)
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
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
        backButton.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Normal", size: 20)
        backButton.titleLabel?.textColor = Colors.text
        backButton.addTarget(self, action: #selector(self.backButton(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(backButton)
        
        let breakView0 = UIView()
        breakView0.widthAnchor.constraint(equalToConstant: 15).isActive = true
        breakView0.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(breakView0)
        
        let titleLabel = UILabel()
        titleLabel.text = name
        titleLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Extrabold", size: 50)
        titleLabel.textColor = Colors.text
        titleLabel.sizeToFit()
        stackView.addArrangedSubview(titleLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Light", size: 20)
        dateLabel.textColor = Colors.text
        dateLabel.sizeToFit()
        stackView.addArrangedSubview(dateLabel)
        
        let breakView1 = UIView()
        breakView1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        breakView1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.addArrangedSubview(breakView1)
        
        let viewButton = createButton(withTitle: "View")
        let studyButton = createButton(withTitle: "Study")
        let editButton = createButton(withTitle: "Edit")
        let spacer = UIView()
        
        let buttonsStackView = UIStackView(arrangedSubviews: [viewButton, studyButton, editButton, spacer])
        buttonsStackView.axis = .horizontal
        buttonsStackView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fill
        stackView.addArrangedSubview(buttonsStackView)
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 30)
        button.titleLabel?.textColor = Colors.text
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        conW(button, (title as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 30)!]).width + 40)
        button.layer.masksToBounds = true

        if(image == nil){
            button.backgroundColor = Colors.secondaryBackground
        }else{
            let blurEffect = UIBlurEffect(style: .systemThinMaterial)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = button.bounds
            blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurredEffectView.isUserInteractionEnabled = false
            button.insertSubview(blurredEffectView, at: 0)
        }

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
        performSegue(withIdentifier: "webStudy", sender: self)
    }

    @objc func editWeb() {
        performSegue(withIdentifier: "editWebSet", sender: self)
    }
    
    @objc func backButton(sender: UIButton){
        performSegue(withIdentifier: "webSetVC_unwind", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if let destination = segue.destination as? WebEditorVC{
            destination.set = set
        }
        if let destination = segue.destination as? WebStudyVC{
            destination.set = set
        }
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
}
