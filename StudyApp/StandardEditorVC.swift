//
//  StandardEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/9/24.
//

import UIKit
import PencilKit

class StandardEditorVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DrawingEditorDelegate {
    
    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let allTermsStackView = UIStackView()
    
    var set = 0 // passed through mainpage
    var cards: [[Any]] = [] //t: text, d: drawing, s: speech - maybe
    var name: String = ""
    var date: String = ""
    var flashcards: [Bool] = []
    var learn: [Int] = []
    
    var currentImagePicker = -1
    
    let imagePicker = UIImagePickerController()
    let imageButton = UIButton()
    
    var keyboardHeight = 0
    
    var defaultTerm = "t"
    var defaultDefinition = "t"
    
    var indexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        name = data["name"] as! String
        date = data["date"] as! String
        cards = data["set"] as! [[Any]]
        flashcards = data["flashcards"] as! [Bool]
        learn = data["learn"] as! [Int]
        view.backgroundColor = Colors.background
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissIt(_:)))
        view.addGestureRecognizer(gesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setup()
        
        
    }

deinit {
        // Unregister from keyboard notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setup(){
        //print(cards)
        for subview in stackView.arrangedSubviews {
            //stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        for subview in allTermsStackView.arrangedSubviews {
            //stackView.removeArrangedSubview(subview)
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
        titleField.font = UIFont(name: "LilGrotesk-Bold", size: 25)
        titleField.textColor = Colors.highlight
        titleField.backgroundColor = Colors.secondaryBackground
        titleField.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, titleField.frame.height))
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        
        topBar.addSubview(titleField)
        
        if((defaults.value(forKey: "images") as! [Data?])[set] == Colors.placeholderI){
            imageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        }else{
            imageButton.setImage(UIImage(systemName: "rectangle.badge.xmark.fill"), for: .normal)
        }
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
            indexes.append(i)
            let termDefinitionStackView = UIStackView()
            termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
            let term = card[1] as? String
            let definition = card[3] as? String
            if(card[0] as! String == "t"){
                let termView = UITextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                termView.isEditable = true
                termView.text = term
                termView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
                termView.delegate = self
                termView.translatesAutoresizingMaskIntoConstraints = false
                termView.isScrollEnabled = false
                termView.backgroundColor = .clear
                termView.accessibilityIdentifier = "t" + String(i)
                termView.translatesAutoresizingMaskIntoConstraints = false
                termView.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                termView.textColor = Colors.text
                termDefinitionStackView.addArrangedSubview(termView)
                //termView.backgroundColor = .green
            }else if(card[0] as! String == "i"){
                let termImage = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                termImage.translatesAutoresizingMaskIntoConstraints = false
                //termImage.setImage(UIImage(named: "color1.png"), for: .normal)
                termImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                termImage.imageView?.contentMode = .scaleAspectFit
                termImage.contentMode = .scaleAspectFit
                termImage.layer.cornerRadius = 10
                termImage.accessibilityIdentifier = String(i)
                termImage.addTarget(self, action: #selector(changeTermImage(_:)), for: .touchUpInside)
                termImage.setImage(UIImage(data: card[1] as! Data), for: .normal)
                termImage.accessibilityIdentifier = String(i)
                termDefinitionStackView.addArrangedSubview(termImage)
                //termImage.backgroundColor = .blue
            }else{
                let drawingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                drawingButton.translatesAutoresizingMaskIntoConstraints = false
                drawingButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                drawingButton.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                drawingButton.addTarget(self, action: #selector(editDrawing(_:)), for: .touchUpInside)
                drawingButton.accessibilityIdentifier = "t" + String(i)
                let termDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 141, height: 2*(view.frame.width - 141)/3))
                termDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                termDrawing.tool = Colors.pen
                termDrawing.overrideUserInterfaceStyle = .light
                termDrawing.backgroundColor = Colors.background
                termDrawing.layer.cornerRadius = 10
                //definitionDrawing.widthAnchor.constraint(equalTo: definitionView.widthAnchor).isActive = true
                //definitionDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                termDrawing.isUserInteractionEnabled = false
                do {
                    try termDrawing.drawing = recolor(PKDrawing(data: card[1] as! Data))
                } catch {
                    
                }
                termDrawing.translatesAutoresizingMaskIntoConstraints = false
                //definitionDrawing.backgroundColor = .red
                drawingButton.insertSubview(termDrawing, at: 0)
                termDrawing.anchorPoint = CGPoint(x: 1, y: 1)
                
//                termDrawing.leadingAnchor.constraint(equalTo: drawingButton.leadingAnchor).isActive = true
//                termDrawing.trailingAnchor.constraint(equalTo: drawingButton.trailingAnchor).isActive = true
//                termDrawing.topAnchor.constraint(equalTo: drawingButton.topAnchor).isActive = true
//                termDrawing.bottomAnchor.constraint(equalTo: drawingButton.bottomAnchor).isActive = true
                
                termDefinitionStackView.addArrangedSubview(drawingButton)
                
                //centerDrawing(termDrawing)
            }
            
            let breakView = UIView()
            breakView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            breakView.translatesAutoresizingMaskIntoConstraints = false
            breakView.backgroundColor = Colors.text.withAlphaComponent(0.5)
            termDefinitionStackView.addArrangedSubview(breakView)
            //breakView.heightAnchor.constraint(equalTo: termDefinitionStackView.heightAnchor, multiplier: 0.5).isActive = true
            
            if(card[2] as! String == "t" || card[2] as! String == "d-r"){
                let definitionView = UITextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                definitionView.isEditable = true
                definitionView.text = definition
                definitionView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
                definitionView.delegate = self
                definitionView.translatesAutoresizingMaskIntoConstraints = false
                definitionView.isScrollEnabled = false
                definitionView.backgroundColor = .clear
                definitionView.accessibilityIdentifier = "d" + String(i)
                definitionView.textColor = Colors.text
                termDefinitionStackView.addArrangedSubview(definitionView)
                //definitionView.backgroundColor = .blue
            }else if card[2] as! String == "d"{
                let drawingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                drawingButton.translatesAutoresizingMaskIntoConstraints = false
                drawingButton.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                drawingButton.addTarget(self, action: #selector(editDrawing(_:)), for: .touchUpInside)
                
                drawingButton.accessibilityIdentifier = "d" + String(i)
                let definitionDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 141, height: 2*(view.frame.width - 141)/3))
                definitionDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                definitionDrawing.layer.cornerRadius = 10
                //definitionDrawing.widthAnchor.constraint(equalTo: definitionView.widthAnchor).isActive = true
                //definitionDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                definitionDrawing.isUserInteractionEnabled = false
                definitionDrawing.tool = Colors.pen
                definitionDrawing.overrideUserInterfaceStyle = .light
                do {
                    try definitionDrawing.drawing = recolor(PKDrawing(data: card[3] as! Data))
                } catch {
                    
                }
                definitionDrawing.translatesAutoresizingMaskIntoConstraints = false
                //definitionDrawing.backgroundColor = .red
                drawingButton.insertSubview(definitionDrawing, at: 0)
//                definitionDrawing.leadingAnchor.constraint(equalTo: drawingButton.leadingAnchor).isActive = true
//                definitionDrawing.trailingAnchor.constraint(equalTo: drawingButton.trailingAnchor).isActive = true
//                definitionDrawing.topAnchor.constraint(equalTo: drawingButton.topAnchor).isActive = true
//                definitionDrawing.bottomAnchor.constraint(equalTo: drawingButton.bottomAnchor).isActive = true
                definitionDrawing.anchorPoint = CGPoint(x: 1, y: 1)
                definitionDrawing.backgroundColor = Colors.background
                
                termDefinitionStackView.addArrangedSubview(drawingButton)
                
                //centerDrawing(definitionDrawing)
                
            }
            
            termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
            termDefinitionStackView.isLayoutMarginsRelativeArrangement = true
            termDefinitionStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            termDefinitionStackView.axis = .horizontal
            termDefinitionStackView.spacing = 10
            termDefinitionStackView.backgroundColor = Colors.secondaryBackground
            termDefinitionStackView.layer.cornerRadius = 10
            
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
            if(cards[i][2] as! String == "d"){
                button6.tintColor = Colors.highlight
            }else{
                button6.tintColor = Colors.darkHighlight
            }
            button6.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
            button6.accessibilityIdentifier = "5" + String(i)
            let recognize = UILabel(frame: CGRect(x: ((view.frame.width - 100) / 2) + 60, y: 0, width: 100, height: 30))
            recognize.text = "Recognize:"
            recognize.textAlignment = .right
            recognize.font = UIFont(name: "LilGrotesk-Regular", size: 15)
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
                button7.setImage(UIImage(systemName: "circle.fill"), for: .normal)
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
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        con(buttonsView, view.frame.width - 100, 30)
        let button1 = UIButton()
        button1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button1.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
        button1.tintColor = Colors.highlight
        button1.addTarget(self, action: #selector(changeDefaultInput(_:)), for: .touchUpInside)
        button1.accessibilityIdentifier = "1" + String(cards.count)
        let button2 = UIButton()
        button2.frame = CGRect(x: 30, y: 0, width: 30, height: 30)
        button2.setImage(UIImage(systemName: "photo"), for: .normal)
        button2.tintColor = Colors.darkHighlight
        button2.addTarget(self, action: #selector(changeDefaultInput(_:)), for: .touchUpInside)
        button2.accessibilityIdentifier = "2" + String(cards.count)
        let button3 = UIButton()
        button3.frame = CGRect(x: 60, y: 0, width: 30, height: 30)
        button3.setImage(UIImage(systemName: "pencil.and.scribble"), for: .normal)
//        if(cards[i][0] as! String == "d"){
//            button3.tintColor = Colors.highlight
//        }else{
            button3.tintColor = Colors.darkHighlight
//        }
        button3.addTarget(self, action: #selector(changeDefaultInput(_:)), for: .touchUpInside)
        button3.accessibilityIdentifier = "3" + String(cards.count)
        let button4 = UIButton()
        button4.frame = CGRect(x: ((view.frame.width - 100) / 2), y: 0, width: 30, height: 30)
        button4.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
        
        button4.addTarget(self, action: #selector(changeDefaultInput(_:)), for: .touchUpInside)
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
        button6.addTarget(self, action: #selector(changeDefaultInput(_:)), for: .touchUpInside)
        button6.accessibilityIdentifier = "5" + String(cards.count)
        let recognize = UILabel(frame: CGRect(x: ((view.frame.width - 100) / 2) + 60, y: 0, width: 100, height: 30))
        recognize.text = "Recognize:"
        recognize.textAlignment = .right
        recognize.font = UIFont(name: "LilGrotesk-Regular", size: 15)
        let button7 = UIButton()
        button7.frame = CGRect(x: ((view.frame.width - 100) / 2) + 160, y: 0, width: 30, height: 30)
        
        button7.tintColor = Colors.highlight
        button7.addTarget(self, action: #selector(changeDefaultInput(_:)), for: .touchUpInside)
        button7.accessibilityIdentifier = "6" + String(cards.count)
        
//        if(cards[i][2] as! String == "t"){
            button4.tintColor = Colors.highlight
            button7.setImage(UIImage(systemName: "circle"), for: .normal)
//        }else if(cards[i][2] as! String == "d-r"){
//            button4.tintColor = Colors.highlight
//            button7.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//        }else{
//            button4.tintColor = Colors.darkHighlight
//            recognize.isHidden = true
//            button7.isHidden = true
//            button7.setImage(UIImage(systemName: "circle"), for: .normal)
            
//        }
        
        buttonsView.addSubview(button1)
        buttonsView.addSubview(button2)
        buttonsView.addSubview(button3)
        buttonsView.addSubview(button4)
        //buttonsView.addSubview(button5)
        buttonsView.addSubview(button6)
        buttonsView.addSubview(recognize)
        buttonsView.addSubview(button7)
        
        stackView.addArrangedSubview(buttonsView)
    }
    
    @objc func addTerm(_ sender: UIButton){
        let termDefinitionStackView = UIStackView()
        termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
        var term : Any = ""
        var definition : Any = ""
        if(defaultTerm == "t"){
            let termView = UITextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            termView.isEditable = true
            termView.text = term as? String
            termView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
            termView.delegate = self
            termView.translatesAutoresizingMaskIntoConstraints = false
            termView.isScrollEnabled = false
            termView.backgroundColor = .clear
            termView.accessibilityIdentifier = "t" + String(cards.count)
            termView.translatesAutoresizingMaskIntoConstraints = false
            termView.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            termView.textColor = Colors.text
            termDefinitionStackView.addArrangedSubview(termView)
            //termView.backgroundColor = .green
        }else if(defaultTerm == "i"){
            term = UIImage(named: "color1.png")!.pngData()!
            let termImage = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            termImage.translatesAutoresizingMaskIntoConstraints = false
            //termImage.setImage(UIImage(named: "color1.png"), for: .normal)
            termImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            termImage.imageView?.contentMode = .scaleAspectFit
            termImage.contentMode = .scaleAspectFit
            termImage.layer.cornerRadius = 10
            termImage.accessibilityIdentifier = String(cards.count)
            termImage.addTarget(self, action: #selector(changeTermImage(_:)), for: .touchUpInside)
            termImage.setImage(UIImage(named: "DendriticLearning_icon_1024x1024_v2-2.png"), for: .normal)
            termDefinitionStackView.addArrangedSubview(termImage)
            //termImage.backgroundColor = .blue
        }else{
            term = PKDrawing().dataRepresentation()
            let drawingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            drawingButton.translatesAutoresizingMaskIntoConstraints = false
            drawingButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
            drawingButton.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            drawingButton.addTarget(self, action: #selector(editDrawing(_:)), for: .touchUpInside)
            drawingButton.accessibilityIdentifier = "t" + String(cards.count)
            let termDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 141, height: 2*(view.frame.width - 141)/3))
            termDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            termDrawing.tool = Colors.pen
            termDrawing.overrideUserInterfaceStyle = .light
            termDrawing.backgroundColor = Colors.background
            termDrawing.layer.cornerRadius = 10
            //definitionDrawing.widthAnchor.constraint(equalTo: definitionView.widthAnchor).isActive = true
            //definitionDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            termDrawing.isUserInteractionEnabled = false
            termDrawing.drawing = recolor(PKDrawing())
            termDrawing.translatesAutoresizingMaskIntoConstraints = false
            //definitionDrawing.backgroundColor = .red
            drawingButton.insertSubview(termDrawing, at: 0)
            termDrawing.anchorPoint = CGPoint(x: 1, y: 1)
            
//                termDrawing.leadingAnchor.constraint(equalTo: drawingButton.leadingAnchor).isActive = true
//                termDrawing.trailingAnchor.constraint(equalTo: drawingButton.trailingAnchor).isActive = true
//                termDrawing.topAnchor.constraint(equalTo: drawingButton.topAnchor).isActive = true
//                termDrawing.bottomAnchor.constraint(equalTo: drawingButton.bottomAnchor).isActive = true
            
            termDefinitionStackView.addArrangedSubview(drawingButton)
            
            //centerDrawing(termDrawing)
        }
        
        let breakView = UIView()
        breakView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        breakView.translatesAutoresizingMaskIntoConstraints = false
        breakView.backgroundColor = Colors.text.withAlphaComponent(0.5)
        termDefinitionStackView.addArrangedSubview(breakView)
        //breakView.heightAnchor.constraint(equalTo: termDefinitionStackView.heightAnchor, multiplier: 0.5).isActive = true
        
        if(defaultDefinition == "t" || defaultDefinition == "d-r"){
            let definitionView = UITextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            definitionView.isEditable = true
            definitionView.text = definition as? String
            definitionView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
            definitionView.delegate = self
            definitionView.translatesAutoresizingMaskIntoConstraints = false
            definitionView.isScrollEnabled = false
            definitionView.backgroundColor = .clear
            definitionView.accessibilityIdentifier = "d" + String(cards.count)
            definitionView.textColor = Colors.text
            termDefinitionStackView.addArrangedSubview(definitionView)
            //definitionView.backgroundColor = .blue
        }else if defaultDefinition == "d"{
            definition = PKDrawing().dataRepresentation()
            let drawingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            drawingButton.translatesAutoresizingMaskIntoConstraints = false
            drawingButton.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            drawingButton.addTarget(self, action: #selector(editDrawing(_:)), for: .touchUpInside)
            
            drawingButton.accessibilityIdentifier = "d" + String(cards.count)
            let definitionDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 141, height: 2*(view.frame.width - 141)/3))
            definitionDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            definitionDrawing.layer.cornerRadius = 10
            //definitionDrawing.widthAnchor.constraint(equalTo: definitionView.widthAnchor).isActive = true
            //definitionDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            definitionDrawing.isUserInteractionEnabled = false
            definitionDrawing.tool = Colors.pen
            definitionDrawing.overrideUserInterfaceStyle = .light
            definitionDrawing.drawing = recolor(PKDrawing())
            definitionDrawing.translatesAutoresizingMaskIntoConstraints = false
            //definitionDrawing.backgroundColor = .red
            drawingButton.insertSubview(definitionDrawing, at: 0)
//                definitionDrawing.leadingAnchor.constraint(equalTo: drawingButton.leadingAnchor).isActive = true
//                definitionDrawing.trailingAnchor.constraint(equalTo: drawingButton.trailingAnchor).isActive = true
//                definitionDrawing.topAnchor.constraint(equalTo: drawingButton.topAnchor).isActive = true
//                definitionDrawing.bottomAnchor.constraint(equalTo: drawingButton.bottomAnchor).isActive = true
            definitionDrawing.anchorPoint = CGPoint(x: 1, y: 1)
            definitionDrawing.backgroundColor = Colors.background
            
            termDefinitionStackView.addArrangedSubview(drawingButton)
            
            //centerDrawing(definitionDrawing)
            
        }
        
        termDefinitionStackView.translatesAutoresizingMaskIntoConstraints = false
        termDefinitionStackView.isLayoutMarginsRelativeArrangement = true
        termDefinitionStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        termDefinitionStackView.axis = .horizontal
        termDefinitionStackView.spacing = 10
        termDefinitionStackView.backgroundColor = Colors.secondaryBackground
        termDefinitionStackView.layer.cornerRadius = 10
        
        cards.append([defaultTerm, term, defaultDefinition, definition])
        flashcards.append(false)
        learn.append(0)
        save()
        
        let i = indexes[cards.count - 2] + 1
        indexes.append(i)
        
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
        if(cards[i][2] as! String == "d"){
            button6.tintColor = Colors.highlight
        }else{
            button6.tintColor = Colors.darkHighlight
        }
        button6.addTarget(self, action: #selector(changeInput(_:)), for: .touchUpInside)
        button6.accessibilityIdentifier = "5" + String(i)
        let recognize = UILabel(frame: CGRect(x: ((view.frame.width - 100) / 2) + 60, y: 0, width: 100, height: 30))
        recognize.text = "Recognize:"
        recognize.textAlignment = .right
        recognize.font = UIFont(name: "LilGrotesk-Regular", size: 15)
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
            button7.setImage(UIImage(systemName: "circle.fill"), for: .normal)
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
    @objc func dismissIt(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func changeInput(_ sender: UIButton){
        let i = indexes.firstIndex(of: Int(sender.accessibilityIdentifier!.dropFirst())!)!
        switch sender.accessibilityIdentifier!.first.map(String.init) {
        case "1":
            if cards[i][0] as! String != "t" {
                sender.tintColor = Colors.highlight
                sender.superview!.subviews[1].tintColor = Colors.darkHighlight
                sender.superview!.subviews[2].tintColor = Colors.darkHighlight
                cards[i][0] = "t"
                cards[i][1] = ""
                let termView = UITextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                termView.isEditable = true
                termView.text = ""
                termView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
                termView.delegate = self
                termView.translatesAutoresizingMaskIntoConstraints = false
                termView.isScrollEnabled = false
                termView.backgroundColor = .clear
                termView.textColor = Colors.text
                termView.accessibilityIdentifier = "t" + String(i)
                termView.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                //termView.backgroundColor = .green
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0].removeFromSuperview()
//                let original = ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0]
//                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).removeArrangedSubview(original)
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).insertArrangedSubview(termView, at: 0)
            }
        case "2":
            if cards[i][0] as! String != "i" {
                sender.tintColor = Colors.highlight
                sender.superview!.subviews[0].tintColor = Colors.darkHighlight
                sender.superview!.subviews[2].tintColor = Colors.darkHighlight
                cards[i][0] = "i"
                cards[i][1] = UIImage(named: "color1.png")!.pngData()!
                let termImage = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                termImage.setImage(UIImage(named: "DendriticLearning_icon_1024x1024_v2-2.png"), for: .normal)
                termImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                //termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                termImage.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                termImage.imageView?.contentMode = .scaleAspectFit
                termImage.contentMode = .scaleAspectFit
                termImage.layer.cornerRadius = 10
                termImage.accessibilityIdentifier = String(i)
                
                termImage.translatesAutoresizingMaskIntoConstraints = false
                termImage.addTarget(self, action: #selector(changeTermImage(_:)), for: .touchUpInside)
                //termImage.setImage(UIImage(named: "DendriticLearning_icon_1024x1024_v2-2.png"), for: .normal)
                termImage.accessibilityIdentifier = String(i)
                //termImage.backgroundColor = .blue
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0].removeFromSuperview()
//                let original = ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0]
//                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).removeArrangedSubview(original)
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).insertArrangedSubview(termImage, at: 0)
                
            }
        case "3":
            if cards[i][0] as! String != "d" {
                sender.tintColor = Colors.highlight
                sender.superview!.subviews[0].tintColor = Colors.darkHighlight
                sender.superview!.subviews[1].tintColor = Colors.darkHighlight
                cards[i][0] = "d"
                let drawingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                drawingButton.translatesAutoresizingMaskIntoConstraints = false
                drawingButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 141)/2).isActive = true
                drawingButton.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                drawingButton.addTarget(self, action: #selector(editDrawing(_:)), for: .touchUpInside)
                drawingButton.accessibilityIdentifier = "t" + String(i)
                let termDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 141, height: 2*(view.frame.width - 141)/3))
                termDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                //definitionDrawing.widthAnchor.constraint(equalTo: definitionView.widthAnchor).isActive = true
                //definitionDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
                termDrawing.isUserInteractionEnabled = false
                termDrawing.drawing = recolor(PKDrawing())
                termDrawing.translatesAutoresizingMaskIntoConstraints = false
                termDrawing.layer.cornerRadius = 10
                termDrawing.backgroundColor = Colors.background
                termDrawing.tool = Colors.pen
                termDrawing.overrideUserInterfaceStyle = .light
                //definitionDrawing.backgroundColor = .red
                drawingButton.insertSubview(termDrawing, at: 0)
                termDrawing.anchorPoint = CGPoint(x: 1, y: 1)
//                termDrawing.leadingAnchor.constraint(equalTo: drawingButton.leadingAnchor).isActive = true
//                termDrawing.trailingAnchor.constraint(equalTo: drawingButton.trailingAnchor).isActive = true
//                termDrawing.topAnchor.constraint(equalTo: drawingButton.topAnchor).isActive = true
//                termDrawing.bottomAnchor.constraint(equalTo: drawingButton.bottomAnchor).isActive = true
                //termDrawing.backgroundColor = .red
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0].removeFromSuperview()
//                let original = ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0]
//                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).removeArrangedSubview(original)
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).insertArrangedSubview(drawingButton, at: 0)
                cards[i][1] = PKDrawing().dataRepresentation()
            }
        case "4":
            if cards[i][2] as! String != "t" && cards[i][2] as! String != "d-r"{
                sender.tintColor = Colors.highlight
                sender.superview!.subviews[4].tintColor = Colors.darkHighlight
                cards[i][2] = "t"
                cards[i][3] = ""
                sender.superview!.subviews[5].isHidden = false
                sender.superview!.subviews[6].isHidden = false
                let definitionView = UITextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                definitionView.isEditable = true
                definitionView.text = ""
                definitionView.font = UIFont(name: "LilGrotesk-Regular", size: 20)
                definitionView.delegate = self
                definitionView.translatesAutoresizingMaskIntoConstraints = false
                definitionView.isScrollEnabled = false
                definitionView.backgroundColor = .clear
                definitionView.accessibilityIdentifier = "d" + String(i)
                definitionView.textColor = Colors.text
                //definitionView.backgroundColor = .blue
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[2].removeFromSuperview()
//                let original = ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[2]
//                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).removeArrangedSubview(original)
                ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).addArrangedSubview(definitionView)
                (sender.superview!.subviews[6] as! UIButton).setImage(UIImage(systemName: "circle"), for: .normal)
            }
        case "5":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[3].tintColor = Colors.darkHighlight
            sender.superview!.subviews[5].isHidden = true
            sender.superview!.subviews[6].isHidden = true
            cards[i][2] = "d"
            
            let drawingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            drawingButton.translatesAutoresizingMaskIntoConstraints = false
            drawingButton.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            drawingButton.addTarget(self, action: #selector(editDrawing(_:)), for: .touchUpInside)
            drawingButton.accessibilityIdentifier = "d" + String(i)
            let definitionDrawing = PKCanvasView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 141, height: 2*(view.frame.width - 141)/3))
            definitionDrawing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            //definitionDrawing.widthAnchor.constraint(equalTo: definitionView.widthAnchor).isActive = true
            //definitionDrawing.heightAnchor.constraint(equalToConstant: (view.frame.width - 141)/3).isActive = true
            definitionDrawing.isUserInteractionEnabled = false
            definitionDrawing.drawing = recolor(PKDrawing())
            definitionDrawing.translatesAutoresizingMaskIntoConstraints = false
            definitionDrawing.layer.cornerRadius = 10
            definitionDrawing.backgroundColor = Colors.background
            definitionDrawing.tool = Colors.pen
            definitionDrawing.overrideUserInterfaceStyle = .light
            //definitionDrawing.backgroundColor = .red
            drawingButton.insertSubview(definitionDrawing, at: 0)
            definitionDrawing.anchorPoint = CGPoint(x: 1, y: 1)
            
            //definitionDrawing.backgroundColor = .red
            ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[2].removeFromSuperview()
//            let original = ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[2]
//            ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).removeArrangedSubview(original)
            ((sender.superview!.superview! as! UIStackView).arrangedSubviews[0] as! UIStackView).addArrangedSubview(drawingButton)
            cards[i][3] = PKDrawing().dataRepresentation()
        case "6":
            if(cards[i][2] as! String == "d-r"){
                sender.setImage(UIImage(systemName: "circle"), for: .normal)
                cards[i][2] = "t"
            }else{
                sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                cards[i][2] = "d-r"
            }
        default:
            break
        }
        save()
    }
    
    @objc func changeDefaultInput(_ sender: UIButton){
        switch sender.accessibilityIdentifier!.first.map(String.init) {
        case "1":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[1].tintColor = Colors.darkHighlight
            sender.superview!.subviews[2].tintColor = Colors.darkHighlight
            defaultTerm = "t"
        case "2":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[0].tintColor = Colors.darkHighlight
            sender.superview!.subviews[2].tintColor = Colors.darkHighlight
            defaultTerm = "i"
        case "3":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[0].tintColor = Colors.darkHighlight
            sender.superview!.subviews[1].tintColor = Colors.darkHighlight
            defaultTerm = "d"
        case "4":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[4].tintColor = Colors.darkHighlight
            defaultDefinition = "t"
            sender.superview!.subviews[5].isHidden = false
            sender.superview!.subviews[6].isHidden = false
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        case "5":
            sender.tintColor = Colors.highlight
            sender.superview!.subviews[3].tintColor = Colors.darkHighlight
            sender.superview!.subviews[5].isHidden = true
            sender.superview!.subviews[6].isHidden = true
            defaultDefinition = "d"
        case "6":
            if(sender.imageView!.image == UIImage(systemName: "circle.fill")){
                sender.setImage(UIImage(systemName: "circle"), for: .normal)
                defaultDefinition = "t"
            }else{
                sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                defaultDefinition = "d-r"
            }
        default:
            break
        }
    }
    
    func save(){
        var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
        previousData[set]["set"] = cards
        previousData[set]["name"] = name
        previousData[set]["flashcards"] = flashcards
        previousData[set]["learn"] = learn
        previousData[set]["date"] = "Last edited: " + dateString()
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
            var images = self.defaults.array(forKey: "images") as? [Data?] ?? []
            images.remove(at: self.set)
            self.defaults.setValue(images, forKey: "images")
            self.performSegue(withIdentifier: "standardEditorVC_unwind", sender: nil)
            self.performSegue(withIdentifier: "standardEditorVC_unwind", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func deleteTerm(_ sender: UIButton){
        let i = Int(sender.accessibilityIdentifier!)!
        let actualI = indexes.firstIndex(of: i)!
        allTermsStackView.arrangedSubviews[actualI].removeFromSuperview()
        //allTermsStackView.removeArrangedSubview(allTermsStackView.arrangedSubviews[i])
        cards.remove(at: actualI)
        flashcards.remove(at: actualI)
        learn.remove(at: actualI)
        indexes.remove(at: actualI)
        save()
    }
    
    @objc func changeTermImage(_ sender: UIButton) {
        currentImagePicker = Int(sender.accessibilityIdentifier!)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func editDrawing(_ sender: UIButton) {
        var original = sender.accessibilityIdentifier!
        original.removeFirst()
        let i: Int = Int(original)!
        if(String(sender.accessibilityIdentifier!.first!) == "t"){
            //cards[i][1]
        }else{
            //cards[i][3]
        }
        let popupVC = DrawingEditorVC()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.i = i

        if(String(sender.accessibilityIdentifier!.first!) == "t"){
            popupVC.term = true
        }else{
            popupVC.term = false
        }
        popupVC.set = set
        present(popupVC, animated: true, completion: nil)
    }
    
    
    
    @objc func changeImage(_ sender: UIButton) {
        var images = (defaults.value(forKey: "images") as! [Data?])
        if images[set] == Colors.placeholderI {
            currentImagePicker = -1
            present(imagePicker, animated: true, completion: nil)
        }else{
            images[set] = Colors.placeholderI
            defaults.setValue(images, forKey: "images")
            imageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        }
        save()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        name = textField.text!
        save()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //print(textView.text!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = pickedImage.pngData() {
                if(currentImagePicker == -1){
                    var images = (defaults.value(forKey: "images") as! [Data?])
                    images[set] = imageData
                    defaults.setValue(images, forKey: "images")
                    imageButton.setImage(UIImage(systemName: "rectangle.badge.xmark.fill"), for: .normal)
                }else{
                    cards[currentImagePicker][1] = imageData
                    (((allTermsStackView.arrangedSubviews[currentImagePicker] as! UIStackView).arrangedSubviews[0] as! UIStackView).arrangedSubviews[0] as! UIButton).setImage(UIImage(data: imageData), for: .normal)
                }
            }
        }
        dismiss(animated: true, completion: nil)
        save()
    }
    
    func updateDrawing() {
        //print("updated")
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        cards = data["set"] as! [[Any]]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.setup()
        }
    }
    
}

extension StandardEditorVC {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        // Adjust the content inset and scroll indicator insets
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardHeight
        scrollView.contentInset = contentInset
        
        var scrollIndicatorInsets = scrollView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the content inset and scroll indicator insets
        var contentInset = scrollView.contentInset
        contentInset.bottom = 0
        scrollView.contentInset = contentInset
        
        var scrollIndicatorInsets = scrollView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = 0
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
    }
}

