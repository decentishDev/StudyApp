//
//  WebStudyVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/11/24.
//

import UIKit

class WebStudyVC: UIViewController, UITextFieldDelegate {

    let defaults = UserDefaults.standard

    var set = 0
    var web: [[Any]] = []
    var round: [Int] = []
    var termCounter = UILabel()
    var index = 0
    var questionType = 0
    var answer: [String] = []
    var originalAnswers: [String] = []
    var knownAnswers: [Int] = []
    
    var answerList = UIStackView()
    
    var mainLabel = UILabel()
    let inputField = UITextField()
    let unknownButton = UIButton()
    
    var roundOverlay = UIView()
    var endLabel = UILabel()
    var perfectCounter: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboard = UITapGestureRecognizer()
        hideKeyboard.addTarget(self, action: #selector(dismissKeyboards(_:)))
//        hideKeyboard.isEnabled = true
//        view.isUserInteractionEnabled = true
        let gestureView = UIView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height - 60))
        //gestureView.backgroundColor = .red
        gestureView.addGestureRecognizer(hideKeyboard)
        //hideKeyboard.view?.isUserInteractionEnabled = true
        view.addSubview(gestureView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        view.backgroundColor = Colors.background
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        web = data["set"] as! [[Any]]
        
        if(web.count > 0){
            
            let backButton = UIButton()
            backButton.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
            backButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            backButton.tintColor = Colors.highlight
            backButton.contentMode = .scaleAspectFit
            backButton.addTarget(self, action: #selector(self.BackButton(sender:)), for: .touchUpInside)
            view.addSubview(backButton)
            let settingsButton = UIButton()
            settingsButton.frame = CGRect(x: view.layer.frame.width - 40, y: 20, width: 20, height: 20)
            settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
            settingsButton.tintColor = Colors.highlight
            settingsButton.contentMode = .scaleAspectFit
            settingsButton.addTarget(self, action: #selector(self.SettingsButton(sender:)), for: .touchUpInside)
            view.addSubview(settingsButton)
            termCounter.frame = CGRect(x: 60, y: 20, width: view.frame.width - 120, height: 20)
            termCounter.font = UIFont(name: "LilGrotesk-Bold", size: 15)
            termCounter.textAlignment = .center
            
            termCounter.textColor = Colors.text
            view.addSubview(termCounter)
            
            mainLabel.frame = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: view.frame.height - 60 - 210)
            mainLabel.font = UIFont(name: "LilGrotesk-Bold", size: 50)
            mainLabel.textColor = Colors.text
            mainLabel.textAlignment = .center
            mainLabel.isUserInteractionEnabled = false
            mainLabel.numberOfLines = 0
            view.addSubview(mainLabel)
            
            answerList.axis = .horizontal
            answerList.frame = CGRect(x: 20, y: 80 + mainLabel.frame.height, width: view.frame.width - 40, height: 100)
            answerList.spacing = 20
            answerList.distribution = .fillEqually
            view.addSubview(answerList)
            
            
            inputField.frame = CGRect(x: 20, y: 80 + mainLabel.frame.height + 20 + answerList.frame.height, width: view.frame.width - 40, height: 50)
            inputField.font = UIFont(name: "LilGrotesk-Regular", size: 30)
            inputField.placeholder = "Type your answer here . . ."
            inputField.delegate = self
            inputField.backgroundColor = Colors.secondaryBackground
            inputField.layer.cornerRadius = 10
            let paddingView = UIView(frame: CGRectMake(0, 0, 10, inputField.frame.height))
            inputField.leftView = paddingView
            inputField.leftViewMode = .always
            
            view.addSubview(inputField)
            
            unknownButton.frame = CGRect(x: view.frame.width - 70, y: 80 + mainLabel.frame.height + 20 + answerList.frame.height, width: 50, height: 50)
            unknownButton.tintColor = Colors.highlight
            unknownButton.setImage(UIImage(systemName: "questionmark"), for: .normal)
            unknownButton.addTarget(self, action: #selector(self.skip(sender:)), for: .touchUpInside)
            view.addSubview(unknownButton)
            
            for i in 0..<web.count {
                round.append(i)
                perfectCounter.append(true)
            }
            round.shuffle()
            termCounter.text = String(index + 1) + "/" + String(round.count)
            nextTerm()
            
            roundOverlay.frame = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: view.frame.height - 80)
            view.addSubview(roundOverlay)
            roundOverlay.layer.cornerRadius = 10
            roundOverlay.backgroundColor = Colors.secondaryBackground
            
            let nextButton = UIButton()
            roundOverlay.addSubview(nextButton)
            nextButton.frame = CGRect(x: 20, y: roundOverlay.frame.height - 100, width: roundOverlay.frame.width - 40, height: 80)
            nextButton.backgroundColor = Colors.highlight
            nextButton.setTitle("Next round", for: .normal)
            nextButton.titleLabel!.font = UIFont(name: "LilGrotesk-Regular", size: 30)
            nextButton.titleLabel!.textColor = Colors.text
            nextButton.layer.cornerRadius = 10
            nextButton.addTarget(self, action: #selector(self.nextRound(sender:)), for: .touchUpInside)
            endLabel.text = ""
            endLabel.font = UIFont(name: "LilGrotesk-Bold", size: 30)
            endLabel.textAlignment = .center
            endLabel.frame = CGRect(x: 20, y: 20, width: roundOverlay.frame.width - 40, height: roundOverlay.frame.height - 140)
            endLabel.textColor = Colors.text
            roundOverlay.addSubview(endLabel)
            roundOverlay.isHidden = true
            //inputField.frame = CGRect(x: 20, y: 80 + mainLabel.frame.height + 20 + answerList.frame.height, width: view.frame.width - 40, height: 50)
            
        }else{
           placeholder()
        }
    }
    
    func placeholder(){
        let placeholderText = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        placeholderText.backgroundColor = Colors.background
        placeholderText.text = "Create some terms before using study mode"
        placeholderText.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        placeholderText.textAlignment = .center
        view.addSubview(placeholderText)
        let backbutton = UIButton(frame: CGRect(x: 30, y: 30, width: 200, height: 80))
        backbutton.setTitle("< Back", for: .normal)
        backbutton.titleLabel!.font = UIFont(name: "LilGrotesk-Regular", size: 25)
        backbutton.layer.cornerRadius = 10
        backbutton.backgroundColor = Colors.secondaryBackground
        backbutton.addTarget(self, action: #selector(self.BackButton(sender:)), for: .touchUpInside)
        view.addSubview(backbutton)
    }
    
    @objc func dismissKeyboards(_ gestureRecognizer: UITapGestureRecognizer) {
        inputField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        var t = view.frame.height - 60 - 210 - keyboardSize!
        let rect1 = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: t)
        t = view.frame.height - 190 - keyboardSize!
        let rect2 = CGRect(x: 20, y: t, width: view.frame.width - 40, height: 100)
        t = view.frame.height - 170 - keyboardSize! + answerList.frame.height
        let rect3 = CGRect(x: 20, y: t, width: view.frame.width - 40, height: 50)
        let rect4 = CGRect(x: view.frame.width - 70, y: rect3.minY, width: 50, height: 50)
        UIView.animate(withDuration: 0.5, animations: {
            self.mainLabel.frame = rect1
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.answerList.frame = rect2
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.inputField.frame = rect3
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.unknownButton.frame = rect4
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        var t = view.frame.height - 60 - 210 - keyboardSize!
        let rect1 = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: t)
        t = view.frame.height - 190 - keyboardSize!
        let rect2 = CGRect(x: 20, y: t, width: view.frame.width - 40, height: 100)
        t = view.frame.height - 170 - keyboardSize! + answerList.frame.height
        let rect3 = CGRect(x: 20, y: t, width: view.frame.width - 40, height: 50)
        let rect4 = CGRect(x: view.frame.width - 70, y: rect3.minY, width: 50, height: 50)
        UIView.animate(withDuration: 0.5, animations: {
            self.mainLabel.frame = rect1
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.answerList.frame = rect2
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.inputField.frame = rect3
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.unknownButton.frame = rect4
        })
    }
    
    func nextTerm(){
        
        knownAnswers = []
        answer = []
        originalAnswers = []
        for subview in answerList.arrangedSubviews{
            subview.removeFromSuperview()
        }
        
        var options: [Int] = []
        
        var incoming: [String] = []
        for term in web {
            if((term[4] as! [Int]).firstIndex(of: round[index]) != nil){
                incoming.append(term[0] as! String)
            }
        }
        if(incoming.count > 0){
            options.append(0)
        }
        
        if((web[round[index]][4] as! [Int]).count > 0){
            options.append(2)
        }
        
        if((web[round[index]][1] as! String) != ""){
            options.append(4)
        }
        
        if(options.isEmpty){
            index+=1
            if(index == web.count){
                if(round.count == 0){
                    placeholder()
                }else{
                    roundOverlay.isHidden = false
                    inputField.resignFirstResponder()
                    view.subviews[0].gestureRecognizers![0].isEnabled = false
                    var t = 0
                    for i in perfectCounter {
                        if i == true {
                            t+=1
                        }
                    }
                    endLabel.text = String(t) + " / " + String(round.count) + " terms perfect"
                }
            }else{
                nextTerm()
            }
        }else{
            questionType = options.randomElement()!
//            let otherType = [false, true].randomElement()!
            
            if(questionType == 0){ //INCOMING TERMS
//                if(otherType){
//                    questionType+=1
                    mainLabel.text = "What leads to " + (web[round[index]][0] as! String) + "?"
                    for i in incoming {
                        var response = ""
                        var thing = i
                        if(thing.count > 0){
                            for _ in 0..<thing.count {
                                if(String(thing.first!) != " "){
                                    response += String(thing.first!).lowercased()
                                }
                                thing.removeFirst()
                            }
                        }
                        originalAnswers.append(i)
                        answer.append(response)
                    }
//                }else{
//                    var t = ""
//                    if(incoming.count == 1){
//                        t = incoming[0]
//                    }else if(incoming.count == 2){
//                        t = incoming[0] + " and " + incoming[1]
//                    }else{
//                        for (i, term) in incoming.enumerated(){
//                            if(i == incoming.count - 1){
//                                t += ", and " + term
//                            }else{
//                                t += term + ", "
//                            }
//                        }
//                    }
//                    mainLabel.text = "What does " + t + " lead to?"
//                    answer = [(web[round[index]][0] as! String)]
//                }
                
            }else if(questionType == 2){ //OUTGOING TERMS
//                if(otherType){
//                    questionType+=1
//                    
//                    var t = ""
//                    let outgoing = web[round[index]][4] as! [Int]
//                        
//                    if(outgoing.count == 1){
//                        t = web[outgoing[0]][0] as! String
//                    }else if(outgoing.count == 2){
//                        t = (web[outgoing[0]][0] as! String) + " and " + (web[outgoing[1]][0] as! String)
//                    }else{
//                        for (i, term) in outgoing.enumerated(){
//                            if(i == outgoing.count - 1){
//                                t += ", and " + (web[outgoing[term]][0] as! String)
//                            }else{
//                                t += (web[outgoing[term]][0] as! String) + ", "
//                            }
//                        }
//                    }
//                        
//                    mainLabel.text = "What leads to " + t + "?"
//                    answer = [(web[round[index]][0] as! String)]
//                }else{
                    mainLabel.text = "What does " + (web[round[index]][0] as! String) + " lead to?"
                    let outgoing = web[round[index]][4] as! [Int]
                    for term in outgoing {
                        var response = ""
                        var thing = (web[term][0] as! String)
                        if(thing.count > 0){
                            for _ in 0..<thing.count {
                                if(String(thing.first!) != " "){
                                    response += String(thing.first!).lowercased()
                                }
                                thing.removeFirst()
                            }
                        }
                        originalAnswers.append(web[term][0] as! String)
                        answer.append(response)
                    }
//                }
                
            }else{ //TERM / DEFINITION
//                if(otherType){
//                    questionType+=1
                    mainLabel.text = "What is " + (web[round[index]][1] as! String) + "?"
                var response = ""
                var thing = (web[round[index]][0] as! String)
                if(thing.count > 0){
                    for _ in 0..<thing.count {
                        if(String(thing.first!) != " "){
                            response += String(thing.first!).lowercased()
                        }
                        thing.removeFirst()
                    }
                }
                    answer = [response]
                originalAnswers = [web[round[index]][0] as! String]
//                }else{
//                    mainLabel.text = "What is " + (web[round[index]][0] as! String) + "?"
//                    answer = [(web[round[index]][1] as! String)]
//                }
            }
            for _ in 0..<answer.count {
                let answerView = UILabel()
                answerView.backgroundColor = Colors.secondaryBackground
                answerView.layer.cornerRadius = 10
                answerView.text = ""
                answerView.font = UIFont(name: "LilGrotesk-Regular", size: 30)
                answerList.addArrangedSubview(answerView)
                answerView.heightAnchor.constraint(equalTo: answerList.heightAnchor).isActive = true
                answerView.layer.masksToBounds = true
                answerView.textAlignment = .center
                answerView.numberOfLines = 0
            }
        }
    }
    
    @objc func BackButton(sender: UIButton){
        performSegue(withIdentifier: "webStudyVC_unwind", sender: nil)
    }
    
    @objc func skip(sender: UIButton) {
        guard knownAnswers.count < answerList.arrangedSubviews.count else { return }

        let currentLabel = answerList.arrangedSubviews[knownAnswers.count] as! UILabel

        perfectCounter[round[index]] = false
        var nextAnswer = ""

        for a in 0..<answer.count {
            if knownAnswers.firstIndex(of: a) == nil {
                nextAnswer = originalAnswers[a]
                break
            }
        }
        
        print(nextAnswer)
        currentLabel.text = nextAnswer

        UIView.transition(with: currentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
            currentLabel.textColor = Colors.text
        }, completion: {_ in 
            UIView.transition(with: currentLabel, duration: 1, options: .transitionCrossDissolve, animations: {
                currentLabel.textColor = .clear
            }, completion: {_ in
                currentLabel.textColor = Colors.text
                currentLabel.text = ""
            })
        })
    }

    
    @objc func nextRound(sender: UIButton){
        roundOverlay.isHidden = true
        round.shuffle()
        index = 0
        nextTerm()
        termCounter.text = "1/" + String(round.count)
        for i in 0..<perfectCounter.count {
            perfectCounter[i] = true
        }
        view.subviews[0].gestureRecognizers![0].isEnabled = true
        inputField.becomeFirstResponder()
    }
    
    @objc func SettingsButton(sender: UIButton){
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var response = ""
        var thing = textField.text!
        if(thing.count > 0){
            for _ in 0..<thing.count {
                if(String(thing.first!) != " "){
                    response += String(thing.first!).lowercased()
                }
                thing.removeFirst()
            }
        }
//        print(response)
//        print(answer)
        if(answer.firstIndex(of: response ) != nil && (knownAnswers.firstIndex(of: answer.firstIndex(of: response )!) == nil)){
            knownAnswers.append(answer.firstIndex(of: response )!)
            (answerList.arrangedSubviews[knownAnswers.count - 1] as! UILabel).text = originalAnswers[answer.firstIndex(of: response)!]
            if(knownAnswers.count == answer.count){
                if(index != round.count - 1){
                    index+=1
                    termCounter.text = String(index + 1) + "/" + String(round.count)
                    nextTerm()
                }else{
                    roundOverlay.isHidden = false
                    inputField.resignFirstResponder()
                    view.subviews[0].gestureRecognizers![0].isEnabled = false
                    var t = 0
                    for i in perfectCounter {
                        if i == true {
                            t+=1
                        }
                    }
                    endLabel.text = String(t) + " / " + String(round.count) + " terms perfect"
                }
            }
            view.backgroundColor = Colors.green
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = Colors.background
            })
        }else{
            perfectCounter[round[index]] = false
        }
        textField.text = ""
        return true
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
}
