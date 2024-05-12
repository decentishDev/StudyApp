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
    var knownAnswers: [Int] = []
    
    var answerList = UIStackView()
    
    var mainLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        web = data["set"] as! [[Any]]
        
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
        termCounter.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 15)
        termCounter.textAlignment = .center
        
        termCounter.textColor = Colors.text
        view.addSubview(termCounter)
        
        mainLabel.frame = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: 200)
        mainLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 50)
        mainLabel.textColor = Colors.text
        mainLabel.textAlignment = .center
        view.addSubview(mainLabel)
        
        answerList.axis = .horizontal
        answerList.frame = CGRect(x: 20, y: 280, width: view.frame.width - 40, height: 100)
        answerList.spacing = 20
        answerList.distribution = .fillEqually
        view.addSubview(answerList)
        
        let inputField = UITextField()
        inputField.frame = CGRect(x: 20, y: 400, width: view.frame.width - 40, height: 50)
        inputField.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 30)
        inputField.placeholder = "Type your answer here . . ."
        inputField.delegate = self
        inputField.backgroundColor = Colors.secondaryBackground
        inputField.layer.cornerRadius = 10
        
        view.addSubview(inputField)
        
        for i in 0..<web.count {
            round.append(i)
        }
        round.shuffle()
        termCounter.text = String(index + 1) + "/" + String(round.count)
        nextTerm()
    }
    
    func nextTerm(){
        
        knownAnswers = []
        answer = []
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
                //end?
            }else{
                nextTerm()
            }
        }else{
            questionType = options.randomElement()!
            let otherType = [false, true].randomElement()!
            
            if(questionType == 0){ //INCOMING TERMS
                if(otherType){
                    questionType+=1
                    mainLabel.text = "What leads to " + (web[round[index]][0] as! String) + "?"
                    for i in (web[round[index]][4] as! [Int]) {
                        answer.append(web[i][0] as! String)
                    }
                }else{
                    var t = ""
                    if(incoming.count == 1){
                        t = incoming[0]
                    }else if(incoming.count == 2){
                        t = incoming[0] + " and " + incoming[1]
                    }else{
                        for (i, term) in incoming.enumerated(){
                            if(i == incoming.count - 1){
                                t += ", and " + term
                            }else{
                                t += term + ", "
                            }
                        }
                    }
                    mainLabel.text = "What does " + t + " lead to?"
                    answer = [(web[round[index]][0] as! String)]
                }
                
            }else if(questionType == 2){ //OUTGOING TERMS
                if(otherType){
                    questionType+=1
                    
                    var t = ""
                    let outgoing = web[round[index]][4] as! [Int]
                        
                    if(outgoing.count == 1){
                        t = web[outgoing[0]][0] as! String
                    }else if(outgoing.count == 2){
                        t = (web[outgoing[0]][0] as! String) + " and " + (web[outgoing[1]][0] as! String)
                    }else{
                        for (i, term) in outgoing.enumerated(){
                            if(i == outgoing.count - 1){
                                t += ", and " + (web[outgoing[term]][0] as! String)
                            }else{
                                t += (web[outgoing[term]][0] as! String) + ", "
                            }
                        }
                    }
                        
                    mainLabel.text = "What leads to " + t + "?"
                    answer = [(web[round[index]][0] as! String)]
                }else{
                    mainLabel.text = "What does " + (web[round[index]][0] as! String) + " lead to?"
                    let outgoing = web[round[index]][4] as! [Int]
                    for term in outgoing {
                        answer.append(web[outgoing[term]][0] as! String)
                    }
                }
                
            }else{ //TERM / DEFINITION
                if(otherType){
                    questionType+=1
                    mainLabel.text = "What is " + (web[round[index]][1] as! String) + "?"
                    answer = [(web[round[index]][0] as! String)]
                }else{
                    mainLabel.text = "What is " + (web[round[index]][0] as! String) + "?"
                    answer = [(web[round[index]][1] as! String)]
                }
            }
            for _ in 0..<answer.count {
                let answerView = UILabel()
                answerView.backgroundColor = Colors.secondaryBackground
                answerView.layer.cornerRadius = 10
                answerView.text = ""
                answerView.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 30)
                answerList.addArrangedSubview(answerView)
                answerView.heightAnchor.constraint(equalTo: answerList.heightAnchor).isActive = true
            }
        }
        
        print(answer)
        print(web[round[index]])
    }
    
    @objc func BackButton(sender: UIButton){
        performSegue(withIdentifier: "webStudyVC_unwind", sender: nil)
    }
    
    @objc func SettingsButton(sender: UIButton){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(answer.firstIndex(of: textField.text ?? "") != nil && (knownAnswers.firstIndex(of: answer.firstIndex(of: textField.text ?? "")!) == nil)){
            knownAnswers.append(answer.firstIndex(of: textField.text ?? "")!)
            (answerList.arrangedSubviews[knownAnswers.count - 1] as! UILabel).text = textField.text
            if(knownAnswers.count == answer.count){
                index+=1
                if(index != round.count){
                    nextTerm()
                }
            }
        }else{
            
        }
        textField.text = ""
        return true
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
}
