//
//  StandardLearnVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/13/24.
//

import UIKit
import PencilKit
import Vision

class StandardLearnVC: UIViewController, PKCanvasViewDelegate, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    var set = 0
    var topHeight: CGFloat = 200
    var keyboard: CGFloat = 0
    
    let cardCounter = UILabel()
    
    let CardLabel = UILabel()
//    let CardOverlayLabel = UIView()
    let CardDrawing = PKCanvasView()
    let CardImage = UIImageView()
    
    let DrawingView = PKCanvasView()
    let TextField = UITextField()
    var currentDrawing = PKDrawing()
    let enterButton = UIButton()
    
    var currentInput = "t" //t, d, d-r, s, s-r
    var startOnFront = true
    var cardOrder: [Int] = []
    var cards: [[Any]] = []
    var known: [Int] = []
    var index: Int = 0
    
    var recognizedText = ""
    var mostRecentProcess = 0
    var processing = false
    var waitingOnResult = false
    
    var random = true
    
    let EndScreen = UIView()
    let EndLabel = UILabel()
    
    let correctButton = UIButton()
    let incorrectButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        cards = data["set"] as! [[Any]]
        if(data.contains{$0.key == "learn"}){
            known = data["learn"] as! [Int]
        }else{
            var c: [Int] = []
            for i in 0..<cards.count{
                c.append(0)
            }
            known = c
            save()
        }
        var t = true
        for i in known {
            if(i != 2){
                t = false
                break
            }
        }
        if t {
            for i in 0..<known.count {
                known[i] = 0
            }
        }
        for i in 0 ..< cards.count{
            if(known[i] != 2){
                cardOrder.append(i)
            }
        }
        if(random){
            cardOrder.shuffle()
        }
        setup()
        nextTerm()
    }
    
    deinit {
            // Unregister from keyboard notifications
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setup()
//    }
//    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        setup()
//    }
    
    
    func setup(){
//        for i in view.subviews {
//            i.removeFromSuperview()
//        }
        let backButton = UIButton()
        backButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        backButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(self.BackButton(sender:)), for: .touchUpInside)
        backButton.tintColor = Colors.highlight
        view.addSubview(backButton)
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: view.layer.frame.width - 40, y: 10, width: 30, height: 30)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.addTarget(self, action: #selector(self.SettingsButton(sender:)), for: .touchUpInside)
        settingsButton.tintColor = Colors.highlight
        view.addSubview(settingsButton)
        cardCounter.frame = CGRect(x: 60, y: 20, width: view.frame.width - 120, height: 20)
        cardCounter.font = .systemFont(ofSize: 15)
        cardCounter.textAlignment = .center
        cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
        view.addSubview(cardCounter)
        CardLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 50)
        CardLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: topHeight - keyboard)
        CardLabel.textColor = Colors.text
        CardLabel.textAlignment = .center
        CardLabel.numberOfLines = 0
        CardLabel.text = ""
        view.addSubview(CardLabel)
        CardDrawing.frame = CGRect(x: 0, y: 0, width: (view.frame.width - 161), height: 2*(view.frame.width - 161)/3)
        CardDrawing.backgroundColor = .clear
        CardDrawing.center = CGPoint(x: view.frame.width/2, y: (topHeight-keyboard)/2)
        CardDrawing.tool = Colors.pen
        CardDrawing.overrideUserInterfaceStyle = .light
        view.addSubview(CardDrawing)
        CardImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: topHeight-keyboard)
        CardImage.contentMode = .scaleAspectFit
        view.addSubview(CardImage)
        TextField.frame = CGRect(x: 50, y: topHeight - keyboard + 20, width: view.frame.width - 100, height: 50)
        TextField.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 35)
        TextField.textColor = Colors.text
        TextField.placeholder = "Type your answer here . . ."
        TextField.delegate = self
        TextField.backgroundColor = Colors.secondaryBackground
        TextField.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, TextField.frame.height))
        TextField.leftView = paddingView
        TextField.leftViewMode = .always
        view.addSubview(TextField)
        DrawingView.frame = CGRect(x: 50, y: topHeight - keyboard + 20, width: view.frame.width - 100, height: 250)
        DrawingView.backgroundColor = Colors.secondaryBackground
        DrawingView.delegate = self
        DrawingView.tool = Colors.pen
        DrawingView.overrideUserInterfaceStyle = .light
        //DrawingView.drawing = currentDrawing
        //DrawingView.drawingPolicy = .pencilOnly
        DrawingView.backgroundColor = Colors.secondaryBackground
        DrawingView.layer.cornerRadius = 10
        view.addSubview(DrawingView)
        enterButton.frame = CGRect(x: view.frame.width - 90, y: topHeight-keyboard + 30, width: 30, height: 30)
        enterButton.backgroundColor = Colors.highlight
        enterButton.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
        enterButton.tintColor = Colors.secondaryBackground
        enterButton.layer.cornerRadius = 10
        enterButton.addTarget(self, action: #selector(enter(sender:)), for: .touchUpInside)
        view.addSubview(enterButton)
        
        EndScreen.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(EndScreen)
        EndLabel.frame = CGRect(x: 100, y: 100, width: view.frame.width - 200, height: view.frame.height - 275)
        EndLabel.text = ""
        EndLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 40)
        EndLabel.textColor = Colors.text
        EndLabel.textAlignment = .center
        EndLabel.numberOfLines = 0
        EndScreen.addSubview(EndLabel)
        let EndButton = UIButton()
        EndButton.frame = CGRect(x: (view.frame.width / 2) - 125, y: view.frame.height - 175, width: 250, height: 75)
        EndButton.backgroundColor = Colors.highlight
        EndButton.layer.cornerRadius = 15
        EndButton.setTitle("Next round", for: .normal)
        EndButton.setTitleColor(Colors.text, for: .normal)
        EndButton.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 30)
        EndButton.addTarget(self, action: #selector(nextRound(sender:)), for: .touchUpInside)
        EndScreen.addSubview(EndButton)
        EndScreen.isHidden = true
        
        incorrectButton.frame = CGRect(x: (view.frame.width / 2) - 60, y: topHeight - keyboard + 20 - 70, width: 50, height: 50)
        incorrectButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        incorrectButton.tintColor = Colors.red
        incorrectButton.contentVerticalAlignment = .fill
        incorrectButton.contentHorizontalAlignment = .fill
        incorrectButton.imageView?.contentMode = .scaleAspectFit
        incorrectButton.contentEdgeInsets = .zero
        incorrectButton.addTarget(self, action: #selector(incorrectDrawing(sender:)), for: .touchUpInside)

        correctButton.frame = CGRect(x: (view.frame.width / 2) + 10, y: topHeight - keyboard + 20 - 70, width: 50, height: 50)
        correctButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        correctButton.tintColor = Colors.green
        correctButton.contentVerticalAlignment = .fill
        correctButton.contentHorizontalAlignment = .fill
        correctButton.imageView?.contentMode = .scaleAspectFit
        correctButton.contentEdgeInsets = .zero
        correctButton.addTarget(self, action: #selector(correctDrawing(sender:)), for: .touchUpInside)

        view.addSubview(incorrectButton)
        view.addSubview(correctButton)

        incorrectButton.alpha = 0
        correctButton.alpha = 0
        incorrectButton.isHidden = true
        correctButton.isHidden = true
        view.bringSubviewToFront(incorrectButton)
        view.bringSubviewToFront(correctButton)

    }
    
    func correctAnim(_ i: Int){
        DrawingView.backgroundColor = Colors.green
        TextField.backgroundColor = Colors.green
        UIView.animate(withDuration: 0.5, animations: {
            self.DrawingView.backgroundColor = Colors.secondaryBackground
            self.TextField.backgroundColor = Colors.secondaryBackground
        })
        known[i] += 1
        save()
    }
    
    func incorrectAnim(_ i: Int){
        DrawingView.backgroundColor = Colors.red
        TextField.backgroundColor = Colors.red
        UIView.animate(withDuration: 0.5, animations: {
            self.DrawingView.backgroundColor = Colors.secondaryBackground
            self.TextField.backgroundColor = Colors.secondaryBackground
        })
        known[i] = 0
        save()
    }
    @objc func incorrectDrawing(sender: UIButton) {
        DrawingView.drawing = recolor(PKDrawing())
        UIView.animate(withDuration: 0.3, animations: {
            self.incorrectButton.alpha = 0
            self.correctButton.alpha = 0
            self.enterButton.alpha = 1
        })
        enterButton.isEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.incorrectButton.isHidden = true
            self.correctButton.isHidden = true
        }
        incorrectAnim(cardOrder[index])
        index+=1
        nextTerm()
    }
    @objc func correctDrawing(sender: UIButton) {
        DrawingView.drawing = recolor(PKDrawing())
        UIView.animate(withDuration: 0.3, animations: {
            self.incorrectButton.alpha = 0
            self.correctButton.alpha = 0
            self.enterButton.alpha = 1
        })
        enterButton.isEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.incorrectButton.isHidden = true
            self.correctButton.isHidden = true
        }
        correctAnim(cardOrder[index])
        index+=1
        nextTerm()
    }
    @objc func nextRound(sender: UIButton) {
        cardOrder.removeAll()
        for (i, j) in known.enumerated() {
            if(j != 2){
                cardOrder.append(i)
            }
        }
        if(cardOrder.count == 0){
            for i in 0..<known.count {
                known[i] = 0
            }
            for i in 0..<cards.count{
                cardOrder.append(i)
            }
        }
        if(random){
            cardOrder.shuffle()
        }
        EndScreen.isHidden = true
        enterButton.isHidden = false
        index = 0
        nextTerm()
        cardCounter.text = "1/" + String(cardOrder.count)
    }
    @objc func enter(sender: UIButton) {
        if(currentInput == "t"){
            var goal = ""
            for i in cards[cardOrder[index]][3] as! String {
                if(i != " "){
                    goal += i.lowercased()
                }
            }
            var current = ""
            for i in TextField.text! {
                if(i != " "){
                    current += i.lowercased()
                }
            }
            if(goal == current){
                correctAnim(cardOrder[index])
            }else{
                incorrectAnim(cardOrder[index])
            }
            index+=1
            nextTerm()
        }else if(currentInput == "d"){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
//                self.CardLabel.text = self.cards[self.cardOrder[self.index]][3] as? String
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.CardLabel.layer.opacity = 1
//                })
//            }
            CardDrawing.isHidden = false
            CardLabel.isHidden = true
            CardImage.isHidden = true
            do {
                CardDrawing.drawing = try recolor(PKDrawing(data: cards[cardOrder[index]][3] as! Data))
            }catch{
                
            }
            incorrectButton.isHidden = false
            correctButton.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.incorrectButton.alpha = 1
                self.correctButton.alpha = 1
                self.enterButton.alpha = 0.5
            })
            enterButton.isEnabled = false
        }else if(currentInput == "d-r"){
            if(processing){
                waitingOnResult = true
            }else{
                var goal = ""
                for i in self.cards[self.cardOrder[self.index]][3] as! String {
                    if(i != " "){
                        goal += i.lowercased()
                    }
                }
                var current = ""
                for i in recognizedText {
                    if(i != " "){
                        current += i.lowercased()
                    }
                }
                if(goal == current){
                    correctAnim(cardOrder[index])
                }else{
                    incorrectAnim(cardOrder[index])
                }
                index+=1
                nextTerm()
                DrawingView.drawing = recolor(PKDrawing())
            }
        }//else if(currentInput == "s"){
//            DispatchQueue.main.asyncAfter(deadline: .now() + (cardAnimation/2)){
//                self.CardLabel.text = "Definition"
//                self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
//            }
//            UIView.animate(withDuration: cardAnimation, animations: {
//                self.CardView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
//            })
//        }else if(currentInput == "s-r"){
//            
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enter(sender: UIButton())
        return true
    }
    
    func nextTerm(){
        TextField.text = ""
        //DrawingView.drawing = PKDrawing()
        //currentDrawing = PKDrawing()
        
        CardLabel.isHidden = true
        CardDrawing.isHidden = true
        CardImage.isHidden = true
        TextField.isHidden = true
        DrawingView.isHidden = true
        if(index == cardOrder.count){
            TextField.resignFirstResponder()
            EndScreen.isHidden = false
            enterButton.isHidden = true
            var Unknown = 0
            var Known = 0
            var Mastered = 0
            for i in known {
                if(i == 0){
                    Unknown+=1
                }else if(i == 1){
                    Known+=1
                }else{
                    Mastered+=1
                }
            }
            EndLabel.text = "Unknown terms: " + String(Unknown) + "\nKnown terms: " + String(Known) + "\nMastered terms: " + String(Mastered)
        }else{
            cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
            
            if(cards[cardOrder[index]][0] as! String == "t"){
                CardLabel.isHidden = false
                CardLabel.text = cards[cardOrder[index]][1] as? String
            }else if(cards[cardOrder[index]][0] as! String == "d"){
                CardDrawing.isHidden = false
                do {
                    CardDrawing.drawing = try recolor(PKDrawing(data: cards[cardOrder[index]][1] as! Data))
                }catch{
                    
                }
            }else{
                CardImage.isHidden = false
                CardImage.image = UIImage(data: cards[cardOrder[index]][1] as! Data)
            }
            currentInput = cards[cardOrder[index]][2] as! String
            if(currentInput == "t"){
                TextField.isHidden = false
                topHeight = view.frame.height - 90
            }else if(currentInput == "d" || currentInput == "d-r"){
                TextField.resignFirstResponder()
                DrawingView.isHidden = false
                topHeight = view.frame.height - 290
            }
            reformat()
        }
    }
    
    @objc func BackButton(sender: UIButton){
        performSegue(withIdentifier: "standardLearnVC_unwind", sender: nil)
    }
    
    func save(){
        var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
        previousData[set]["learn"] = known
        defaults.set(previousData, forKey: "sets")
    }
    
    @objc func SettingsButton(sender: UIButton){
        
    }
    
    func reformat(){
        UIView.animate(withDuration: 0.5, animations: {
            self.CardLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.topHeight-self.keyboard)
            self.CardDrawing.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width - 161), height: 2*(self.view.frame.width - 161)/3)
            self.CardImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.topHeight-self.keyboard)
            self.TextField.frame = CGRect(x: 50, y: self.topHeight-self.keyboard + 20, width: self.view.frame.width - 100, height: 50)
            self.DrawingView.frame = CGRect(x: 50, y: self.topHeight-self.keyboard + 20, width: self.view.frame.width - 100, height: 250)
            self.enterButton.frame = CGRect(x: self.view.frame.width - 90, y: self.topHeight-self.keyboard + 30, width: 30, height: 30)
            self.CardDrawing.center = CGPoint(x: self.view.frame.width/2, y: (self.topHeight-self.keyboard)/2)
            self.incorrectButton.frame = CGRect(x: (self.view.frame.width/2) - 60, y: self.topHeight - self.keyboard + 20 - 70, width: 50, height: 50)
            self.correctButton.frame = CGRect(x: (self.view.frame.width/2) + 10, y: self.topHeight - self.keyboard + 20 - 70, width: 50, height: 50)
        })
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if(canvasView != DrawingView || currentInput != "d-r"){
            return
        }
        
        mostRecentProcess+=1
        let thisProcess = mostRecentProcess
        processing = true
        
        UIGraphicsBeginImageContextWithOptions(DrawingView.bounds.size, false, UIScreen.main.scale)
                
        DrawingView.drawHierarchy(in: DrawingView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        if(image != nil){
            let requestHandler = VNImageRequestHandler(cgImage: image!)
            
            let request = VNRecognizeTextRequest { [self] (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
                
                self.currentDrawing = PKDrawing()
                //self.DrawingView.drawing = self.currentDrawing
                var processedText = ""
                for observation in observations {
                    guard let bestCandidate = observation.topCandidates(1).first else {continue}
                    let detectedText = bestCandidate.string
                    for i in detectedText {
                        if(i != " "){
                            processedText += i.lowercased()
                        }
                    }
                }
                if(self.mostRecentProcess == thisProcess){
                    self.recognizedText = processedText
                    self.processing = false
                    if(self.waitingOnResult){
                        var goal = ""
                        for i in self.cards[self.cardOrder[self.index]][3] as! String {
                            if(i != " "){
                                goal += i.lowercased()
                            }
                        }
                        var current = ""
                        for i in recognizedText {
                            if(i != " "){
                                current += i.lowercased()
                            }
                        }
                        if(goal == current){
                            correctAnim(cardOrder[index])
                        }else{
                            incorrectAnim(cardOrder[index])
                        }
                        index+=1
                        nextTerm()
                        DrawingView.drawing = recolor(PKDrawing())
                    }
                }
            }
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }

}

extension StandardLearnVC {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        // Adjust the content inset and scroll indicator insets
//        var contentInset = scrollView.contentInset
//        contentInset.bottom = keyboardHeight
//        scrollView.contentInset = contentInset
//        
//        var scrollIndicatorInsets = scrollView.scrollIndicatorInsets
//        scrollIndicatorInsets.bottom = keyboardHeight
//        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        keyboard = keyboardHeight
        reformat()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the content inset and scroll indicator insets
//        var contentInset = scrollView.contentInset
//        contentInset.bottom = 0
//        scrollView.contentInset = contentInset
//        
//        var scrollIndicatorInsets = scrollView.scrollIndicatorInsets
//        scrollIndicatorInsets.bottom = 0
//        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        keyboard = 0
        reformat()
    }
}
