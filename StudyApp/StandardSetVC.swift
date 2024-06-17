//
//  StandardSetVC.swift
//  StudyApp
//
//  Created by Matthew J. Lundeen on 4/9/24.
//

import UIKit
import PencilKit

class StandardSetVC: UIViewController {

    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var set = 0 // passed through mainpage
    var cards: [[Any]] = [] //t: text, d: drawing, s: speech - maybe
    var name: String = ""
    var date: String = ""
    
    var image: Data? = Colors.placeholderI
    
    var goToEditor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(goToEditor)
        if goToEditor {
            //UIView.setAnimationsEnabled(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.performSegue(withIdentifier: "standardEditor", sender: self)
            }
            //print("whyyyyy")
            editSet()
            //UIView.setAnimationsEnabled(true)
        }
//        print(data)
//        print("//////////////////////////////////////////////")
//        print(cards)
        
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func setup(){
        let sets = defaults.value(forKey: "sets") as! [Dictionary<String, Any>]
        if sets.count == set {
            performSegue(withIdentifier: "standardSetVC_unwind", sender: nil)
        }else{
            let data = sets[set]
            if(name != "" && (name != data["name"] as! String)){
                performSegue(withIdentifier: "standardSetVC_unwind", sender: nil)
            }
            name = data["name"] as! String
            date = data["date"] as! String
            cards = data["set"] as! [[Any]]

            image = (defaults.value(forKey: "images") as! [Data?])[set]
            for subview in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            stackView.removeFromSuperview()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            if(image == Colors.placeholderI){
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
            backButton.titleLabel!.font = UIFont(name: "LilGrotesk-Bold", size: 20)
            backButton.addTarget(self, action: #selector(self.backButton(sender:)), for: .touchUpInside)
            backButton.setTitleColor(Colors.highlight, for: .normal)
            stackView.addArrangedSubview(backButton)
            
            let breakView0 = UIView()
            breakView0.widthAnchor.constraint(equalToConstant: 15).isActive = true
            breakView0.heightAnchor.constraint(equalToConstant: 15).isActive = true
            stackView.addArrangedSubview(breakView0)
            
            let titleLabel = UILabel()
            titleLabel.text = name
            titleLabel.font = UIFont(name: "LilGrotesk-Black", size: 50)
            titleLabel.sizeToFit()
            titleLabel.textColor = Colors.text
            stackView.addArrangedSubview(titleLabel)
            
            let dateLabel = UILabel()
            dateLabel.text = date
            dateLabel.font = UIFont(name: "LilGrotesk-Light", size: 20)
            dateLabel.sizeToFit()
            dateLabel.textColor = Colors.text
            stackView.addArrangedSubview(dateLabel)
            
            let breakView5 = UIView()
            breakView5.widthAnchor.constraint(equalToConstant: 30).isActive = true
            breakView5.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(breakView5)
            
            let shareButton = UIButton()
            con(shareButton, 200, 30)
            shareButton.addTarget(self, action: #selector(self.export(sender:)), for: .touchUpInside)
            shareButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(shareButton)
            let shareIcon = UIImageView()
            shareIcon.translatesAutoresizingMaskIntoConstraints = false
            con(shareIcon, 30, 30)
            shareButton.addSubview(shareIcon)
            shareIcon.image = UIImage(systemName: "arrow.down.square.fill")
            shareIcon.leadingAnchor.constraint(equalTo: shareButton.leadingAnchor).isActive = true
            shareIcon.tintColor = Colors.highlight
            shareIcon.contentMode = .scaleAspectFit
            let shareText = UILabel()
            shareText.translatesAutoresizingMaskIntoConstraints = false
            shareButton.addSubview(shareText)
            conH(shareText, 30)
            shareText.leadingAnchor.constraint(equalTo: shareIcon.trailingAnchor, constant: 10).isActive = true
            shareText.trailingAnchor.constraint(equalTo: shareButton.trailingAnchor).isActive = true
            shareText.text = "Download"
            shareText.font = UIFont(name: "LilGrotesk-Bold", size: 20)
            shareText.textColor = Colors.highlight
            
            let breakView1 = UIView()
            breakView1.widthAnchor.constraint(equalToConstant: 30).isActive = true
            breakView1.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(breakView1)
            
            let learnButton = createButton(withTitle: "Learn")
            let flashcardsButton = createButton(withTitle: "Flashcards")
            //let testButton = createButton(withTitle: "Test")
            let editButton = createButton(withTitle: "Edit")
            let spacer = UIView()
            
            let buttonsStackView = UIStackView(arrangedSubviews: [learnButton, flashcardsButton, editButton, spacer]) // testButton,
            buttonsStackView.axis = .horizontal
            buttonsStackView.widthAnchor.constraint(equalToConstant: 600).isActive = true
            buttonsStackView.spacing = 20
            buttonsStackView.distribution = .fill
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(buttonsStackView)
            
            let breakView2 = UIView()
            breakView2.widthAnchor.constraint(equalToConstant: 100).isActive = true
            breakView2.heightAnchor.constraint(equalToConstant: 100).isActive = true
            breakView2.backgroundColor = .clear
            stackView.addArrangedSubview(breakView2)
            
            let termsLabel = UILabel()
            termsLabel.text = "Terms"
            termsLabel.font = UIFont(name: "LilGrotesk-Bold", size: 30)
            termsLabel.sizeToFit()
            termsLabel.textColor = Colors.text
            stackView.addArrangedSubview(termsLabel)
            
            let breakView3 = UIView()
            breakView3.widthAnchor.constraint(equalToConstant: 10).isActive = true
            breakView3.heightAnchor.constraint(equalToConstant: 10).isActive = true
            breakView3.backgroundColor = .clear
            stackView.addArrangedSubview(breakView3)
            
            let allTermsStackView = UIStackView()
            allTermsStackView.axis = .vertical
            allTermsStackView.spacing = 10
            allTermsStackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(allTermsStackView)
            NSLayoutConstraint.activate([
                allTermsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                allTermsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            ])
            for card in cards {
                let termDefinitionStackView = UIStackView()
                termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
                let term = card[1] as? String
                let definition = card[3] as? String
                if(card[0] as! String == "t"){
                    let termView = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                    termView.text = term
                    termView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
                    termView.translatesAutoresizingMaskIntoConstraints = false
                    termView.backgroundColor = .clear
                    termView.numberOfLines = 0
                    termView.textColor = Colors.text
                    termView.widthAnchor.constraint(equalToConstant: (view.frame.width - 156)/2).isActive = true
                    termDefinitionStackView.addArrangedSubview(termView)
                    //termView.backgroundColor = .green
                }else if(card[0] as! String == "i"){
                    let termImage = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                    termImage.translatesAutoresizingMaskIntoConstraints = false
                    //termImage.setImage(UIImage(named: "color1.png"), for: .normal)
                    termImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 156)/2).isActive = true
                    termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 156)/3).isActive = true
                    termImage.imageView?.contentMode = .scaleAspectFit
                    termImage.setImage(UIImage(data: card[1] as! Data), for: .normal)
                    termDefinitionStackView.addArrangedSubview(termImage)
                    //termImage.backgroundColor = .blue
                }else{
                    let drawingsuperview = UIView(frame: CGRect(x: 0, y: 0, width: (view.frame.width - 156)/2, height: (view.frame.width - 156)/3))
                    drawingsuperview.widthAnchor.constraint(equalToConstant: (view.frame.width - 156)/2).isActive = true
                    drawingsuperview.heightAnchor.constraint(equalToConstant: (view.frame.width - 156)/3).isActive = true
                    let termDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 156, height: 2*(view.frame.width - 156)/3))
                    termDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    drawingsuperview.addSubview(termDrawing)
                    termDrawing.anchorPoint = drawingsuperview.anchorPoint
                    drawingsuperview.translatesAutoresizingMaskIntoConstraints = false
                    termDrawing.isUserInteractionEnabled = false
                    termDrawing.translatesAutoresizingMaskIntoConstraints = false
                    termDrawing.tool = Colors.pen
                    termDrawing.overrideUserInterfaceStyle = .light
                    do {
                        try termDrawing.drawing = recolor(PKDrawing(data: card[1] as! Data))
                    } catch {
                        
                    }
                    termDrawing.anchorPoint = CGPoint(x: 1, y: 1)
                    termDrawing.backgroundColor = Colors.background
                    termDrawing.layer.cornerRadius = 10
                    termDefinitionStackView.addArrangedSubview(drawingsuperview)
                    //centerDrawing(termDrawing)
                    //termDrawing.backgroundColor = .red
                }
                
                let breakView = UIView()
                breakView.backgroundColor = Colors.text.withAlphaComponent(0.5)
                breakView.widthAnchor.constraint(equalToConstant: 1).isActive = true
                breakView.translatesAutoresizingMaskIntoConstraints = false
                termDefinitionStackView.addArrangedSubview(breakView)
                //breakView.heightAnchor.constraint(equalTo: termDefinitionStackView.heightAnchor, multiplier: 0.5).isActive = true
                
                if(card[2] as! String == "t" || card[2] as! String == "d-r"){
                    let definitionView = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                    definitionView.numberOfLines = 0
                    definitionView.text = definition
                    definitionView.textColor = Colors.text
                    definitionView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
                    definitionView.translatesAutoresizingMaskIntoConstraints = false
                    definitionView.backgroundColor = .clear
                    termDefinitionStackView.addArrangedSubview(definitionView)
                    //definitionView.backgroundColor = .blue
                }else if card[2] as! String == "d"{
                    let drawingsuperview = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: (view.frame.width - 156)/3))
                    drawingsuperview.translatesAutoresizingMaskIntoConstraints = false
                    drawingsuperview.widthAnchor.constraint(equalToConstant: (view.frame.width - 156)/2).isActive = true
                    drawingsuperview.heightAnchor.constraint(equalToConstant: (view.frame.width - 156)/3).isActive = true
                    let definitionDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 156, height: 2*(view.frame.width - 156)/3))
                    definitionDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    definitionDrawing.layer.cornerRadius = 10
                    definitionDrawing.isUserInteractionEnabled = false
                    definitionDrawing.tool = Colors.pen
                    definitionDrawing.overrideUserInterfaceStyle = .light
                    do {
                        try definitionDrawing.drawing = recolor(PKDrawing(data: card[3] as! Data))
                    } catch {
                        
                    }
                    definitionDrawing.translatesAutoresizingMaskIntoConstraints = false
                    
                    drawingsuperview.addSubview(definitionDrawing)
                    definitionDrawing.anchorPoint = CGPoint(x: 1, y: 1)
                    definitionDrawing.backgroundColor = Colors.background
                    //definitionDrawing.backgroundColor = .red
                    termDefinitionStackView.addArrangedSubview(drawingsuperview)
                    
                    //centerDrawing(definitionDrawing)
                }
                
                termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
                termDefinitionStackView.isLayoutMarginsRelativeArrangement = true
                termDefinitionStackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
                termDefinitionStackView.axis = .horizontal
                termDefinitionStackView.spacing = 15
                conW(termDefinitionStackView, view.frame.width - 100)
                
                if(image == Colors.placeholderI){
                    termDefinitionStackView.backgroundColor = Colors.secondaryBackground
                    termDefinitionStackView.layer.cornerRadius = 10
                }else{
                    var blurEffect = UIBlurEffect(style: .systemThinMaterial)
                    if(Colors.text == UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)){
                        blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
                    }else if(Colors.text == UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)){
                        blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
                    }
                    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
                    blurredEffectView.frame = termDefinitionStackView.frame
                    blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    blurredEffectView.layer.cornerRadius = 10
                    blurredEffectView.clipsToBounds = true
                    termDefinitionStackView.insertSubview(blurredEffectView, at: 0)
                }
                
                allTermsStackView.addArrangedSubview(termDefinitionStackView)
            }
        }
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel!.font = UIFont(name: "LilGrotesk-Bold", size: 30)
        button.layer.cornerRadius = 10
        button.setTitleColor(Colors.text, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        conW(button, (title as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "LilGrotesk-Bold", size: 30)!]).width + 40)
        button.layer.masksToBounds = true

        if(image == Colors.placeholderI){
            button.backgroundColor = Colors.secondaryBackground
        }else{
            var blurEffect = UIBlurEffect(style: .systemThinMaterial)
            if(Colors.text == UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)){
                blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
            }else if(Colors.text == UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)){
                blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
            }
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
        case "Learn":
            startLearn()
        case "Flashcards":
            startFlashcards()
        case "Test":
            startTest()
        case "Edit":
            editSet()
        default:
            break
        }
    }

    @objc func startLearn() {
        performSegue(withIdentifier: "standardLearnVC", sender: nil)
    }

    @objc func startFlashcards() {
        performSegue(withIdentifier: "flashcards", sender: nil)
    }

    @objc func startTest() {
        //print("test")
    }
    
    @objc func editSet() {
        performSegue(withIdentifier: "standardEditor", sender: nil)
    }
    
    @objc func backButton(sender: UIButton){
        //print("back")
        performSegue(withIdentifier: "standardSetVC_unwind", sender: nil)
    }
    
    @objc func export(sender: UIButton){
        var cardsDictionary: [String: Any] = (defaults.object(forKey: "sets") as! [Dictionary<String, Any>])[set]
        var oldLearn: [Int] = []
        for _ in 0 ..< cardsDictionary.count {
            oldLearn.append(0)
        }
        var oldFlash: [Bool] = []
        for _ in 0 ..< cardsDictionary.count {
            oldFlash.append(false)
        }
        cardsDictionary["flashcards"] = oldFlash
        cardsDictionary["learn"] = oldLearn
        //cardsDictionary["images"] = (defaults.object(forKey: "images") as! [Data?])[set]
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: cardsDictionary, requiringSecureCoding: false) else {
            print("Failed to archive data.")
            return
        }
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let timeString = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(name).appendingPathExtension("dlset")
        
        do {
            try data.write(to: fileURL)
            
            let documentPicker = UIDocumentPickerViewController(url: fileURL, in: .exportToService)
            documentPicker.shouldShowFileExtensions = true
            self.present(documentPicker, animated: true, completion: nil)
        } catch {
            print("Error exporting cards: \(error.localizedDescription)")
        }
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if let destination = segue.destination as? StandardEditorVC {
            destination.set = set
        }
        if let destination = segue.destination as? FlashcardsVC {
            destination.set = set
        }
        if let destination = segue.destination as? StandardLearnVC {
            destination.set = set
        }
    }
}
