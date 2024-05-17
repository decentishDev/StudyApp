//
//  StandardEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/9/24.
//

import UIKit
import PencilKit

class StandardEditorVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let allTermsStackView = UIStackView()
    
    var set = 0 // passed through mainpage
    var cards: [[Any]] = [] //t: text, d: drawing, s: speech - maybe
    var name: String = ""
    var date: String = ""
    
    var currentImagePicker = -1
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        name = data["name"] as! String
        date = data["date"] as! String
        cards = data["set"] as! [[Any]]
        view.backgroundColor = Colors.background
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissIt(_:)))
        view.addGestureRecognizer(gesture)
        
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
        
        let topBar = UIView()
        topBar.widthAnchor.constraint(equalToConstant: 530).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        topBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(topBar)
        
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "arrowshape.backward.fill"), for: .normal)
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        backButton.backgroundColor = Colors.secondaryBackground
        backButton.layer.cornerRadius = 10
        backButton.tintColor = Colors.highlight
        
        topBar.addSubview(backButton)
        
        let titleField = UITextField()
        titleField.delegate = self
        titleField.text = name
        titleField.placeholder = "Set name"
        titleField.frame = CGRect(x: 60, y: 0, width: 350, height: 50)
        titleField.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 25)
        titleField.textColor = Colors.highlight
        titleField.backgroundColor = Colors.secondaryBackground
        titleField.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, titleField.frame.height))
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        
        topBar.addSubview(titleField)
        
        let imageButton = UIButton()
        imageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        imageButton.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
        imageButton.frame = CGRect(x: 420, y: 0, width: 50, height: 50)
        imageButton.backgroundColor = Colors.secondaryBackground
        imageButton.layer.cornerRadius = 10
        imageButton.tintColor = Colors.highlight
        
        topBar.addSubview(imageButton)
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteSet(_:)), for: .touchUpInside)
        deleteButton.frame = CGRect(x: 480, y: 0, width: 50, height: 50)
        deleteButton.backgroundColor = Colors.secondaryBackground
        deleteButton.layer.cornerRadius = 10
        deleteButton.tintColor = Colors.highlight
        
        topBar.addSubview(deleteButton)
        
        let breakView0 = UIView()
        breakView0.widthAnchor.constraint(equalToConstant: 30).isActive = true
        breakView0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.addArrangedSubview(breakView0)
        
        allTermsStackView.axis = .vertical
        allTermsStackView.spacing = 10
        allTermsStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(allTermsStackView)
        NSLayoutConstraint.activate([
            allTermsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            allTermsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        for (i, card) in cards.enumerated()
        {
            let term = card[1] as? String
            let definition = card[3] as? String
            let termSuperview = UIView()
            
            let termView = UITextView()
            termView.isEditable = true
            termView.text = term
            termView.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 20)
            termView.delegate = self
            termView.translatesAutoresizingMaskIntoConstraints = false
            termView.isScrollEnabled = false
            termView.backgroundColor = .clear
            termView.accessibilityIdentifier = "t" + String(i)
            termView.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            if(card[0] as! String != "t"){
                termView.isHidden = true
            }
            termSuperview.addSubview(termView)
            
            let termImage = UIButton()
            termImage.setImage(UIImage(named: "color1.png"), for: .normal)
            termImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            termImage.imageView?.contentMode = .scaleAspectFill
            termImage.accessibilityIdentifier = String(i)
            termImage.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
            if(card[0] as! String != "i"){
                termImage.isHidden = true
            }else{
                termImage.setImage(UIImage(data: card[1] as! Data), for: .normal)
            }
            termSuperview.addSubview(termImage)
            
            let termDrawing = PKCanvasView()
            termDrawing.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            termDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            termDrawing.isUserInteractionEnabled = false
            if(card[0] as! String != "d"){
                termDrawing.isHidden = true
            }else{
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //AAAAAAAAAA
                //termDrawing.drawing = PKDrawing(data: card[1] as! Data)
            }
            termSuperview.addSubview(termDrawing)

            let definitionView = UITextView()
            definitionView.isEditable = true
            definitionView.text = definition
            definitionView.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 20)
            definitionView.delegate = self
            definitionView.translatesAutoresizingMaskIntoConstraints = false
            definitionView.isScrollEnabled = false
            definitionView.backgroundColor = .clear
            definitionView.accessibilityIdentifier = "d" + String(i)
            
            let termDefinitionStackView = UIStackView()
            termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
            termDefinitionStackView.isLayoutMarginsRelativeArrangement = true
            termDefinitionStackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            
            let breakView = UIView()
            breakView.backgroundColor = .label.withAlphaComponent(0.5)
            breakView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            
            termDefinitionStackView.addArrangedSubview(termView)
            termDefinitionStackView.addArrangedSubview(breakView)
            termDefinitionStackView.addArrangedSubview(definitionView)
            
            termDefinitionStackView.axis = .horizontal
            termDefinitionStackView.spacing = 10
            termDefinitionStackView.backgroundColor = Colors.secondaryBackground
            termDefinitionStackView.layer.cornerRadius = 10
            
            breakView.heightAnchor.constraint(equalTo: termView.heightAnchor, multiplier: 1).isActive = true
            
            let buttonsView = UIView()
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            con(buttonsView, view.frame.width - 100, 30)
            let button1 = UIButton()
            button1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button1.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
            if(cards[i][0] as! String == "t"){
                button1.tintColor = Colors.highlight
            }else{
                button1.tintColor = Colors.darkHighlight
            }
            button1.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button1.accessibilityIdentifier = "1" + String(i)
            let button2 = UIButton()
            button2.frame = CGRect(x: 30, y: 0, width: 30, height: 30)
            button2.setImage(UIImage(systemName: "photo"), for: .normal)
            if(cards[i][0] as! String == "i"){
                button2.tintColor = Colors.highlight
            }else{
                button2.tintColor = Colors.darkHighlight
            }
            button2.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button2.accessibilityIdentifier = "2" + String(i)
            let button3 = UIButton()
            button3.frame = CGRect(x: 60, y: 0, width: 30, height: 30)
            button3.setImage(UIImage(systemName: "pencil.and.scribble"), for: .normal)
            if(cards[i][0] as! String == "d"){
                button3.tintColor = Colors.highlight
            }else{
                button3.tintColor = Colors.darkHighlight
            }
            button3.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button3.accessibilityIdentifier = "3" + String(i)
            let button4 = UIButton()
            button4.frame = CGRect(x: ((view.frame.width - 100) / 2), y: 0, width: 30, height: 30)
            button4.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
            
            button4.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button4.accessibilityIdentifier = "4" + String(i)
//            let button5 = UIButton()
//            button5.frame = CGRect(x: ((view.frame.width - 100) / 2) + 30, y: 0, width: 30, height: 30)
//            button5.setImage(UIImage(systemName: "photo"), for: .normal)
//            button5.tintColor = Colors.darkHighlight
//            button5.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
//            button5.accessibilityIdentifier = "5" + String(i)
            let button6 = UIButton()
            button6.frame = CGRect(x: ((view.frame.width - 100) / 2) + 30, y: 0, width: 30, height: 30)
            button6.setImage(UIImage(systemName: "pencil.and.scribble"), for: .normal)
            if(cards[i][2] as! String == "i"){
                button6.tintColor = Colors.highlight
            }else{
                button6.tintColor = Colors.darkHighlight
            }
            button6.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button6.accessibilityIdentifier = "5" + String(i)
            let recognize = UILabel(frame: CGRect(x: ((view.frame.width - 100) / 2) + 60, y: 0, width: 100, height: 30))
            recognize.text = "Recognize:"
            recognize.textAlignment = .right
            recognize.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 15)
            let button7 = UIButton()
            button7.frame = CGRect(x: ((view.frame.width - 100) / 2) + 160, y: 0, width: 30, height: 30)
            
            button7.tintColor = Colors.highlight
            button7.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button7.accessibilityIdentifier = "6" + String(i)
            
            let deleteButton = UIButton()
            deleteButton.frame = CGRect(x: view.frame.width - 130, y: 0, width: 30, height: 30)
            deleteButton.tintColor = .init(red: 0.6, green: 0.3, blue: 0.3, alpha: 1)
            deleteButton.addTarget(self, action: #selector(deleteTerm(_:)), for: .touchUpInside)
            deleteButton.accessibilityIdentifier = String(i)
            deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
            
            if(cards[i][2] as! String == "t"){
                button4.tintColor = Colors.highlight
                button7.setImage(UIImage(systemName: "circle"), for: .normal)
            }else if(cards[i][2] as! String == "d-r"){
                button4.tintColor = Colors.highlight
                button7.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }else{
                button4.tintColor = Colors.darkHighlight
                recognize.isHidden = true
                button7.isHidden = true
                button7.setImage(UIImage(systemName: "circle"), for: .normal)
                
            }
            
            buttonsView.addSubview(button1)
            buttonsView.addSubview(button2)
            buttonsView.addSubview(button3)
            buttonsView.addSubview(button4)
            //buttonsView.addSubview(button5)
            buttonsView.addSubview(button6)
            buttonsView.addSubview(recognize)
            buttonsView.addSubview(button7)
            buttonsView.addSubview(deleteButton)
            
            let cardAndButtons = UIStackView()
            cardAndButtons.translatesAutoresizingMaskIntoConstraints = false
            cardAndButtons.axis = .vertical
            cardAndButtons.spacing = 0
            cardAndButtons.addArrangedSubview(termDefinitionStackView)
            cardAndButtons.addArrangedSubview(buttonsView)
            
            allTermsStackView.addArrangedSubview(cardAndButtons)
        }
        
        let newTerm = UIButton()
        newTerm.backgroundColor = Colors.secondaryBackground
        newTerm.layer.cornerRadius = 10
        newTerm.setImage(UIImage(systemName: "plus"), for: .normal)
        newTerm.imageView?.tintColor = Colors.highlight
        newTerm.imageView?.contentMode = .scaleAspectFit
        newTerm.addTarget(self, action: #selector(addTerm(_:)), for: .touchUpInside)
        con(newTerm, view.frame.width - 100, 60)
        stackView.addArrangedSubview(newTerm)
    }
    @objc func addTerm(_ sender: UIButton){
        let term = ""
        let definition = ""
        let termSuperview = UIView()
        
        let termView = UITextView()
        termView.isEditable = true
        termView.text = term
        termView.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 20)
        termView.delegate = self
        termView.translatesAutoresizingMaskIntoConstraints = false
        termView.isScrollEnabled = false
        termView.backgroundColor = .clear
        termView.accessibilityIdentifier = "t" + String(cards.count)
        termView.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
//        if(card[0] as! String != "t"){
//            termView.isHidden = true
//        }
        termSuperview.addSubview(termView)
        
        let termImage = UIButton()
        termImage.setImage(UIImage(named: "color1.png"), for: .normal)
        termImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
        termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
        termImage.imageView?.contentMode = .scaleAspectFill
        termImage.accessibilityIdentifier = String(cards.count)
        termImage.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
//        if(card[0] as! String != "i"){
            termImage.isHidden = true
//        }else{
//            termImage.setImage(UIImage(data: card[1] as! Data), for: .normal)
//        }
        termSuperview.addSubview(termImage)
        
        let termDrawing = PKCanvasView()
        termDrawing.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
        termDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
        termDrawing.isUserInteractionEnabled = false
//        if(card[0] as! String != "d"){
            termDrawing.isHidden = true
//        }else{
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //AAAAAAAAAA
//            //termDrawing.drawing = PKDrawing(data: card[1] as! Data)
//        }
        termSuperview.addSubview(termDrawing)

        let definitionView = UITextView()
        definitionView.isEditable = true
        definitionView.text = definition
        definitionView.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 20)
        definitionView.delegate = self
        definitionView.translatesAutoresizingMaskIntoConstraints = false
        definitionView.isScrollEnabled = false
        definitionView.backgroundColor = .clear
        definitionView.accessibilityIdentifier = "d" + String(cards.count)
        
        let termDefinitionStackView = UIStackView()
        termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
        termDefinitionStackView.isLayoutMarginsRelativeArrangement = true
        termDefinitionStackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let breakView = UIView()
        breakView.backgroundColor = .label.withAlphaComponent(0.5)
        breakView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        termDefinitionStackView.addArrangedSubview(termView)
        termDefinitionStackView.addArrangedSubview(breakView)
        termDefinitionStackView.addArrangedSubview(definitionView)
        
        termDefinitionStackView.axis = .horizontal
        termDefinitionStackView.spacing = 10
        termDefinitionStackView.backgroundColor = Colors.secondaryBackground
        termDefinitionStackView.layer.cornerRadius = 10
        
        breakView.heightAnchor.constraint(equalTo: termView.heightAnchor, multiplier: 1).isActive = true
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        con(buttonsView, view.frame.width - 100, 30)
        let button1 = UIButton()
        button1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button1.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
//        if(cards[i][0] as! String == "t"){
            button1.tintColor = Colors.highlight
//        }else{
//            button1.tintColor = Colors.darkHighlight
//        }
        button1.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button1.accessibilityIdentifier = "1" + String(cards.count)
        let button2 = UIButton()
        button2.frame = CGRect(x: 30, y: 0, width: 30, height: 30)
        button2.setImage(UIImage(systemName: "photo"), for: .normal)
//        if(cards[i][0] as! String == "i"){
//            button2.tintColor = Colors.highlight
//        }else{
            button2.tintColor = Colors.darkHighlight
//        }
        button2.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button2.accessibilityIdentifier = "2" + String(cards.count)
        let button3 = UIButton()
        button3.frame = CGRect(x: 60, y: 0, width: 30, height: 30)
        button3.setImage(UIImage(systemName: "pencil.and.scribble"), for: .normal)
//        if(cards[i][0] as! String == "d"){
//            button3.tintColor = Colors.highlight
//        }else{
            button3.tintColor = Colors.darkHighlight
//        }
        button3.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button3.accessibilityIdentifier = "3" + String(cards.count)
        let button4 = UIButton()
        button4.frame = CGRect(x: ((view.frame.width - 100) / 2), y: 0, width: 30, height: 30)
        button4.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
        
        button4.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button4.accessibilityIdentifier = "4" + String(cards.count)
//            let button5 = UIButton()
//            button5.frame = CGRect(x: ((view.frame.width - 100) / 2) + 30, y: 0, width: 30, height: 30)
//            button5.setImage(UIImage(systemName: "photo"), for: .normal)
//            button5.tintColor = Colors.darkHighlight
//            button5.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
//            button5.accessibilityIdentifier = "5" + String(i)
        let button6 = UIButton()
        button6.frame = CGRect(x: ((view.frame.width - 100) / 2) + 30, y: 0, width: 30, height: 30)
        button6.setImage(UIImage(systemName: "pencil.and.scribble"), for: .normal)
//        if(cards[i][2] as! String == "i"){
//            button6.tintColor = Colors.highlight
//        }else{
            button6.tintColor = Colors.darkHighlight
//        }
        button6.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button6.accessibilityIdentifier = "5" + String(cards.count)
        let recognize = UILabel(frame: CGRect(x: ((view.frame.width - 100) / 2) + 60, y: 0, width: 100, height: 30))
        recognize.text = "Recognize:"
        recognize.textAlignment = .right
        recognize.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 15)
        let button7 = UIButton()
        button7.frame = CGRect(x: ((view.frame.width - 100) / 2) + 160, y: 0, width: 30, height: 30)
        
        button7.tintColor = Colors.highlight
        button7.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button7.accessibilityIdentifier = "6" + String(cards.count)
        
        let deleteButton = UIButton()
        deleteButton.frame = CGRect(x: view.frame.width - 130, y: 0, width: 30, height: 30)
        deleteButton.tintColor = .init(red: 0.6, green: 0.3, blue: 0.3, alpha: 1)
        deleteButton.addTarget(self, action: #selector(deleteTerm(_:)), for: .touchUpInside)
        deleteButton.accessibilityIdentifier = String(cards.count)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        
//        if(cards[i][2] as! String == "t"){
//            button4.tintColor = Colors.highlight
//            button7.setImage(UIImage(systemName: "circle"), for: .normal)
//        }else if(cards[i][2] as! String == "d-r"){
//            button4.tintColor = Colors.highlight
//            button7.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//        }else{
            button4.tintColor = Colors.darkHighlight
            recognize.isHidden = true
            button7.isHidden = true
            button7.setImage(UIImage(systemName: "circle"), for: .normal)
            
//        }
        
        buttonsView.addSubview(button1)
        buttonsView.addSubview(button2)
        buttonsView.addSubview(button3)
        buttonsView.addSubview(button4)
        //buttonsView.addSubview(button5)
        buttonsView.addSubview(button6)
        buttonsView.addSubview(recognize)
        buttonsView.addSubview(button7)
        buttonsView.addSubview(deleteButton)
        
        let cardAndButtons = UIStackView()
        cardAndButtons.translatesAutoresizingMaskIntoConstraints = false
        cardAndButtons.axis = .vertical
        cardAndButtons.spacing = 0
        cardAndButtons.addArrangedSubview(termDefinitionStackView)
        cardAndButtons.addArrangedSubview(buttonsView)
        
        allTermsStackView.addArrangedSubview(cardAndButtons)
        
        cards.append(["t", "", "t", ""])
    }
    @objc func dismissIt(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func changeInput(_ sender: UIButton){
        let i = Int(sender.accessibilityIdentifier!.dropFirst())!
        switch sender.accessibilityIdentifier!.first.map(String.init) {
        case "1":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[1].tintColor = Colors.darkHighlight
            sender.superview!.subviews[2].tintColor = Colors.darkHighlight
            cards[i][0] = "t"
        case "2":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[0].tintColor = Colors.darkHighlight
            sender.superview!.subviews[2].tintColor = Colors.darkHighlight
            cards[i][0] = "d"
        case "3":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[0].tintColor = Colors.darkHighlight
            sender.superview!.subviews[1].tintColor = Colors.darkHighlight
            cards[i][0] = "i"
        case "4":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[4].tintColor = Colors.darkHighlight
            cards[i][2] = "t"
            sender.superview!.subviews[5].isHidden = false
            sender.superview!.subviews[6].isHidden = false
            (sender.superview!.subviews[6] as! UIButton).setImage(UIImage(systemName: "circle"), for: .normal)
        case "5":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[3].tintColor = Colors.darkHighlight
            sender.superview!.subviews[5].isHidden = true
            sender.superview!.subviews[6].isHidden = true
            cards[i][2] = "d"
        case "6":
            if(cards[i][2] as! String == "d-r"){
                sender.setImage(UIImage(systemName: "circle"), for: .normal)
                cards[i][2] = "t"
            }else{
                sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                cards[i][2] = "d-r"
            }
        default:
            break
        }
        save()
    }
    
    func save(){
        var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
        previousData[set]["set"] = cards
        previousData[set]["name"] = name
        defaults.set(previousData, forKey: "sets")
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var original = textView.accessibilityIdentifier!
        original.removeFirst()
        let i: Int = Int(original)!
        if(String(textView.accessibilityIdentifier!.first!) == "t"){
            cards[i][1] = textView.text!
        }else{
            cards[i][3] = textView.text!
        }
        save()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        save()
        return true
    }
    
    @objc func back(_ sender: UIButton) {
        performSegue(withIdentifier: "standardEditorVC_unwind", sender: nil)
    }
    
    @objc func deleteSet(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this set?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {_ in
            var sets = self.defaults.object(forKey: "sets") as! [Any]
            sets.remove(at: self.set)
            self.defaults.setValue(sets, forKey: "sets")
            self.performSegue(withIdentifier: "standardEditorVC_unwind", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func deleteTerm(_ sender: UIButton){
        let i = Int(sender.accessibilityIdentifier!)!
        allTermsStackView.removeArrangedSubview(allTermsStackView.arrangedSubviews[i])
        cards.remove(at: i)
        save()
    }
    
    @objc func changeImage(_ sender: UIButton) {
        currentImagePicker = -1
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        name = textField.text!
        save()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = pickedImage.pngData() {
                if(currentImagePicker == -1){
                    var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
                    previousData[set]["image"] = imageData
                    defaults.set(previousData, forKey: "sets")
                }else{
                    cards[currentImagePicker][1] = imageData
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
