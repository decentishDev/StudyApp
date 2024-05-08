//
//  StandardLearnVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/13/24.
//

import UIKit
import PencilKit
import Vision

class StandardLearnVC: UIViewController, PKCanvasViewDelegate {
    
    
    
//  I realized I was accidently combining learn mode and flashcards in one so right now I'm trying to separate them - work in progress
    
    
    
    
    var buttonsHeight: CGFloat = 20
    var topHeight: CGFloat = 200
    var bottomHeight: CGFloat = 200
    
    let cardCounter = UILabel()
    
    let IncorrectView = UIView()
    let CorrectView = UIView()
    let CardView = UIView()
    let CardLabel = UILabel()
//    let CardOverlayLabel = UIView()
    let CardDrawing = PKCanvasView()
    let CardImage = UIImageView()
    let OverlayCard = UIView()
    let OverlayLabel = UILabel()
    let OverlayDrawing = PKCanvasView()
    let OverlayIMage = UIImageView()
    
    let DrawingView = PKCanvasView()
    let TextField = UITextField()
    var currentDrawing = PKDrawing()
    
    var currentInput = "d-r" //t, d, d-r, s, s-r
    var onFront = true
    var startOnFront = true
    var cardOrder: [Int] = [0, 1]
    var cards: [[Any]] = [["t", "∫sin(x)", "d-r", "-cos(x)"], ["t", "∫cos(x)", "d-r", "sin(x)"], ["t", "What is the capital of Illinois?", "t", "Springfield"]]
    var known: [Bool] = []
    var index: Int = 0
    let cardAnimation = 0.6
    
    var recognizedText = ""
    var mostRecentProcess = 0
    var processing = false
    var waitingOnResult = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setup()
    }
    
    
    func setup(){
        for i in view.subviews {
            i.removeFromSuperview()
        }
        
        IncorrectView.backgroundColor = .secondarySystemBackground
        IncorrectView.layer.cornerRadius = 10
        CardView.backgroundColor = .secondarySystemBackground
        CardView.layer.cornerRadius = 10
        
        CorrectView.backgroundColor = .secondarySystemBackground
        CorrectView.layer.cornerRadius = 10
        
        DrawingView.delegate = self
        DrawingView.drawing = currentDrawing
        DrawingView.drawingPolicy = .pencilOnly
        DrawingView.backgroundColor = .secondarySystemBackground
        DrawingView.layer.cornerRadius = 10
        
        view.addSubview(CorrectView)
        view.addSubview(IncorrectView)
        view.addSubview(CardView)
        view.addSubview(DrawingView)
        
        if(view.layer.frame.width > view.layer.frame.height){
            if(currentInput == "t"){
                topHeight = (view.layer.frame.height - 100) * 0.8
                bottomHeight = (view.layer.frame.height - 100) * 0.2
                
                DrawingView.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 40, height: bottomHeight)
                DrawingView.isHidden = true
                TextField.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 30, height: 0)
                TextField.isHidden = false
            }else if(currentInput == "d" || currentInput == "d-r"){
                topHeight = (view.layer.frame.height - 100) * 0.6
                bottomHeight = (view.layer.frame.height - 100) * 0.4
                
                DrawingView.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 40, height: bottomHeight)
                DrawingView.isHidden = false
                TextField.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 30, height: 0)
                TextField.isHidden = true
            }
            IncorrectView.frame = CGRect(x: 20, y: 40 + buttonsHeight, width: (view.layer.frame.width - 80) * 0.15, height: topHeight)
            CardView.frame = CGRect(x: 40 + IncorrectView.frame.width, y: 40 + buttonsHeight, width: (view.layer.frame.width - 80) * 0.7, height: topHeight)
            CorrectView.frame = CGRect(x: 60 + IncorrectView.frame.width + CardView.frame.width, y: 40 + buttonsHeight, width: (view.layer.frame.width - 80) * 0.15, height: topHeight)
        }else{
            var optionsHeight: CGFloat = 50
            if(currentInput == "d-r"){
                topHeight = (view.layer.frame.height - 120) * 0.45
                optionsHeight = (view.layer.frame.height - 120) * 0.15
                bottomHeight = (view.layer.frame.height - 120) * 0.4
                
                DrawingView.frame = CGRect(x: 20, y: 80 + buttonsHeight + optionsHeight + topHeight, width: view.layer.frame.width - 40, height: bottomHeight)
            }
            
            IncorrectView.frame = CGRect(x: 20, y: 60 + buttonsHeight + topHeight, width: (view.layer.frame.width - 60) * 0.5, height: optionsHeight)
            CardView.frame = CGRect(x: 20, y: 40 + buttonsHeight, width: view.layer.frame.width - 40, height: topHeight)
            CorrectView.frame = CGRect(x: 40 + IncorrectView.frame.width, y: 60 + buttonsHeight + topHeight, width: (view.layer.frame.width - 60) * 0.5, height: optionsHeight)
            
        }
        
        CardLabel.font = .systemFont(ofSize: 40)
        CardLabel.textAlignment = .center
        CardLabel.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardView.addSubview(CardLabel)
        CardDrawing.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardDrawing.isUserInteractionEnabled = false
        CardView.addSubview(CardDrawing)
        if(onFront){
            if(cards[cardOrder[index]][0] as! String == "t"){
                CardLabel.text = cards[cardOrder[index]][1] as? String
                CardLabel.isHidden = false
                CardDrawing.isHidden = true
            }else if(cards[cardOrder[index]][0] as! String == "d"){
                CardDrawing.drawing = (cards[cardOrder[index]][1] as? PKDrawing)!
                CardLabel.isHidden = true
                CardDrawing.isHidden = false
            }
        }
        
        let cardButton = UIButton()
        cardButton.addTarget(self, action: #selector(self.CardButton(sender:)), for: .touchUpInside)
        cardButton.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardView.addSubview(cardButton)
        CardView.bringSubviewToFront(cardButton)
        
        let incorrectImage = UIImageView()
        incorrectImage.image = UIImage(systemName: "xmark")
        incorrectImage.layer.frame = CGRect(x: (IncorrectView.layer.frame.width / 2) - 25, y: (IncorrectView.layer.frame.height / 2) - 25, width: 50, height: 50)
        incorrectImage.contentMode = .scaleAspectFit
        IncorrectView.addSubview(incorrectImage)
        let incorrectButton = UIButton()
        incorrectButton.addTarget(self, action: #selector(self.IncorrectButton(sender:)), for: .touchUpInside)
        incorrectButton.layer.frame = CGRect(x: 0, y: 0, width: IncorrectView.frame.width, height: IncorrectView.frame.height)
        IncorrectView.addSubview(incorrectButton)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.IncorrectSwipe(sender:)))
        swipeLeft.direction = .left
        swipeLeft.view?.layer.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.CorrectSwipe(sender:)))
        swipeRight.direction = .right
        swipeRight.view?.layer.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardView.addGestureRecognizer(swipeLeft)
        CardView.addGestureRecognizer(swipeRight)
        
        let correctImage = UIImageView()
        correctImage.image = UIImage(systemName: "checkmark")
        correctImage.layer.position = CorrectView.center
        correctImage.layer.frame = CGRect(x: (CorrectView.layer.frame.width / 2) - 25, y: (CorrectView.layer.frame.height / 2) - 25, width: 50, height: 50)
        correctImage.contentMode = .scaleAspectFit
        CorrectView.addSubview(correctImage)
        let correctButton = UIButton()
        correctButton.addTarget(self, action: #selector(self.CorrectButton(sender:)), for: .touchUpInside)
        correctButton.layer.frame = CGRect(x: 0, y: 0, width: CorrectView.frame.width, height: CorrectView.frame.height)
        CorrectView.addSubview(correctButton)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        backButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(self.BackButton(sender:)), for: .touchUpInside)
        view.addSubview(backButton)
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: view.layer.frame.width - 40, y: 20, width: 20, height: 20)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.addTarget(self, action: #selector(self.SettingsButton(sender:)), for: .touchUpInside)
        view.addSubview(settingsButton)
        cardCounter.frame = CGRect(x: 60, y: 20, width: view.frame.width - 120, height: 20)
        cardCounter.font = .systemFont(ofSize: 15)
        cardCounter.textAlignment = .center
        cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
        view.addSubview(cardCounter)
        
        OverlayCard.frame = CardView.frame
        OverlayCard.layer.cornerRadius = 10
        OverlayCard.backgroundColor = .secondarySystemBackground
        OverlayLabel.font = .systemFont(ofSize: 40)
        OverlayLabel.textAlignment = .center
        OverlayLabel.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        OverlayCard.addSubview(OverlayLabel)
        OverlayDrawing.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        OverlayDrawing.isUserInteractionEnabled = false
        OverlayCard.addSubview(OverlayDrawing)
        OverlayCard.isHidden = true
        view.addSubview(OverlayCard)
    }
    
    @objc func IncorrectButton(sender: UIButton) {
        Incorrect()
    }
    
    @objc func CorrectButton(sender: UIButton) {
        Correct()
    }
    
    @objc func IncorrectSwipe(sender: UISwipeGestureRecognizer) {
        Incorrect()
    }
    
    @objc func CorrectSwipe(sender: UISwipeGestureRecognizer) {
        Correct()
    }
    
    func Correct(){
        CorrectView.backgroundColor = .green
        UIView.animate(withDuration: 0.5, animations: {
            self.CorrectView.backgroundColor = .secondarySystemBackground
        })
        known[cardOrder[index]] = true
        if(index == cards.count - 1){
            //Next round
        }else{
            if(onFront){
                if(cards[cardOrder[index]][0] as! String == "t"){
                    OverlayLabel.text = cards[cardOrder[index]][1] as? String
                    OverlayLabel.isHidden = false
                    OverlayDrawing.isHidden = true
                }else if(cards[cardOrder[index]][0] as! String == "d"){
                    OverlayDrawing.drawing = (cards[cardOrder[index]][1] as? PKDrawing)!
                    OverlayLabel.isHidden = true
                    OverlayDrawing.isHidden = false
                }
            }else{
                if(cards[cardOrder[index]][2] as! String == "t"){
                    OverlayLabel.text = cards[cardOrder[index]][3] as? String
                    OverlayLabel.isHidden = false
                    OverlayDrawing.isHidden = true
                }else if(cards[cardOrder[index]][2] as! String == "d"){
                    OverlayDrawing.drawing = (cards[cardOrder[index]][3] as? PKDrawing)!
                    OverlayLabel.isHidden = true
                    OverlayDrawing.isHidden = false
                }
            }
            OverlayCard.isHidden = false
            OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
            OverlayCard.alpha = 1
            OverlayCard.layer.position = CardView.layer.position
            index+=1
            cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
            let oldInput = currentInput
            currentInput = cards[cardOrder[index]][2] as! String
            if(currentInput == oldInput){
                //??
            }else if(currentInput == "t"){
                topHeight = (view.layer.frame.height - 100) * 0.8
                bottomHeight = (view.layer.frame.height - 100) * 0.2
                
                DrawingView.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 40, height: bottomHeight)
                DrawingView.isHidden = true
                TextField.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 30, height: 0)
                TextField.isHidden = false
            }else if(currentInput == "d" || currentInput == "d-r"){
                topHeight = (view.layer.frame.height - 100) * 0.6
                bottomHeight = (view.layer.frame.height - 100) * 0.4
                
                DrawingView.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 40, height: bottomHeight)
                DrawingView.isHidden = false
                TextField.frame = CGRect(x: 20, y: 80 + topHeight, width: view.layer.frame.width - 30, height: 0)
                TextField.isHidden = true
            }else if(currentInput == "s"){
                
            }else if(currentInput == "s-r"){
                
            }
            if(cards[cardOrder[index]][0] as! String == "t"){
                CardLabel.text = cards[cardOrder[index]][1] as? String
                CardLabel.isHidden = false
                CardDrawing.isHidden = true
            }else if(cards[cardOrder[index]][0] as! String == "d"){
                CardDrawing.drawing = (cards[cardOrder[index]][1] as? PKDrawing)!
                CardLabel.isHidden = true
                CardDrawing.isHidden = false
            }else{
                //Sound?
            }
            CardView.layer.transform = CATransform3DIdentity
            CardLabel.layer.transform = CATransform3DIdentity
            if(cards[cardOrder[index]][0] as! String == "t"){
                CardLabel.text = cards[cardOrder[index]][1] as? String
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
                self.OverlayCard.alpha = 0
                self.OverlayCard.layer.position = CGPoint(x: self.view.frame.width, y: self.view.frame.height / 2)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.OverlayCard.isHidden = true
            }
        }
    }
    
    func Incorrect(){
        IncorrectView.backgroundColor = .red
        UIView.animate(withDuration: 0.5, animations: {
            self.IncorrectView.backgroundColor = .secondarySystemBackground
        })
        known[cardOrder[index]] = false
        if(index == cards.count - 1){
            //Next round
        }else{
            if(onFront){
                if(cards[cardOrder[index]][0] as! String == "t"){
                    OverlayLabel.text = cards[cardOrder[index]][1] as? String
                    OverlayLabel.isHidden = false
                    OverlayDrawing.isHidden = true
                }else if(cards[cardOrder[index]][0] as! String == "d"){
                    OverlayDrawing.drawing = (cards[cardOrder[index]][1] as? PKDrawing)!
                    OverlayLabel.isHidden = true
                    OverlayDrawing.isHidden = false
                }
            }else{
                if(cards[cardOrder[index]][2] as! String == "t"){
                    OverlayLabel.text = cards[cardOrder[index]][3] as? String
                    OverlayLabel.isHidden = false
                    OverlayDrawing.isHidden = true
                }else if(cards[cardOrder[index]][2] as! String == "d"){
                    OverlayDrawing.drawing = (cards[cardOrder[index]][3] as? PKDrawing)!
                    OverlayLabel.isHidden = true
                    OverlayDrawing.isHidden = false
                }
            }
            OverlayCard.isHidden = false
            OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
            OverlayCard.alpha = 1
            OverlayCard.layer.position = CardView.layer.position
            index+=1
            cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
            let oldInput = currentInput
            currentInput = cards[cardOrder[index]][2] as! String
            if(currentInput == oldInput){
                //??
            }else if(currentInput == "t"){
                
            }else if(currentInput == "d"){
                
            }else if(currentInput == "d-r"){
                
            }else if(currentInput == "s"){
                
            }else if(currentInput == "s-r"){
                
            }
            if(cards[cardOrder[index]][0] as! String == "t"){
                CardLabel.text = cards[cardOrder[index]][1] as? String
                CardLabel.isHidden = false
                CardDrawing.isHidden = true
            }else if(cards[cardOrder[index]][0] as! String == "d"){
                CardDrawing.drawing = (cards[cardOrder[index]][1] as? PKDrawing)!
                CardLabel.isHidden = true
                CardDrawing.isHidden = false
            }else{
                //Sound?
            }
            CardView.layer.transform = CATransform3DIdentity
            CardLabel.layer.transform = CATransform3DIdentity
            if(cards[cardOrder[index]][0] as! String == "t"){
                CardLabel.text = cards[cardOrder[index]][0] as? String
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
                self.OverlayCard.alpha = 0
                self.OverlayCard.layer.position = CGPoint(x: 0, y: self.view.frame.height / 2)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.OverlayCard.isHidden = true
            }
        }
    }
    
    @objc func CardButton(sender: UIButton) {
        print("zoinks")
        if(currentInput == "t"){
            if(startOnFront){
                if(TextField.text == cards[cardOrder[index]][3] as? String){
                    Correct()
                }
            }else{
                if(TextField.text == cards[cardOrder[index]][1] as? String){
                    Correct()
                }
            }
        }else if(currentInput == "d"){
            DispatchQueue.main.asyncAfter(deadline: .now() + (cardAnimation/2)){
                self.CardLabel.text = "Definition"
                self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            }
            UIView.animate(withDuration: cardAnimation, animations: {
                self.CardView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            })
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
                if(self.startOnFront){
                    if(recognizedText == self.cards[self.cardOrder[self.index]][3] as? String){
                        self.Correct()
                    }else{
                        self.Incorrect()
                    }
                }else{
                    if(recognizedText == self.cards[self.cardOrder[self.index]][1] as? String){
                        self.Correct()
                    }else{
                        self.Incorrect()
                    }
                }
            }
        }else if(currentInput == "s"){
            DispatchQueue.main.asyncAfter(deadline: .now() + (cardAnimation/2)){
                self.CardLabel.text = "Definition"
                self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            }
            UIView.animate(withDuration: cardAnimation, animations: {
                self.CardView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            })
        }else if(currentInput == "s-r"){
            
        }
    }
    
    @objc func BackButton(sender: UIButton){
        
    }
    
    @objc func SettingsButton(sender: UIButton){
        
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if(canvasView != DrawingView){
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
            
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
                
                self.currentDrawing = PKDrawing()
                self.DrawingView.drawing = self.currentDrawing
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
                        if(self.startOnFront){
                            if(self.recognizedText == self.cards[self.cardOrder[self.index]][3] as? String){
                                self.Correct()
                            }else{
                                self.Incorrect()
                            }
                        }else{
                            if(self.recognizedText == self.cards[self.cardOrder[self.index]][1] as? String){
                                self.Correct()
                            }else{
                                self.Incorrect()
                            }
                        }
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
