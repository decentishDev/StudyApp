//
//  FlashCardsVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/8/24.
//

import UIKit
import PencilKit

class FlashcardsVC: UIViewController {
    
    var set = 0
    
    let cardCounter = UILabel()
    
    let IncorrectView = UIView()
    let CorrectView = UIView()
    let CardView = UIView()
    let CardLabel = UILabel()
//    let CardOverlayLabel = UIView()
    let CardDrawing = PKCanvasView()
    let CardImage = UIImageView()
    let cardButton = UIButton()
    let OverlayCard = UIView()
    let OverlayLabel = UILabel()
    let OverlayDrawing = PKCanvasView()
    let OverlayImage = UIImageView()
    
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    
    var onFront = true
    var startOnFront = true
    var random = true
    var cardOrder: [Int] = []
    let defaults = UserDefaults.standard
    var cards: [[Any]] = [] //t: text, d: drawing, s: speech - maybe

    var known: [Bool] = []
    var index: Int = 0
    let cardAnimation = 0.6
    
    let endScreen = UIView()
    let endLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        cards = data["set"] as! [[Any]]
        known = data["flashcards"] as! [Bool]
        var t = true
        for i in known {
            if(!i){
                t = false
                break
            }
        }
        if t {
            for i in 0..<known.count {
                known[i] = false
            }
        }
        for i in 0 ..< cards.count{
            if(!known[i]){
                cardOrder.append(i)
            }
        }
        if(random){
            cardOrder.shuffle()
        }
        setup()
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
        
        IncorrectView.backgroundColor = Colors.secondaryBackground
        IncorrectView.layer.cornerRadius = 10
        CardView.backgroundColor = Colors.secondaryBackground
        CardView.layer.cornerRadius = 10
        
        CorrectView.backgroundColor = Colors.secondaryBackground
        CorrectView.layer.cornerRadius = 10
        
        view.addSubview(CorrectView)
        view.addSubview(IncorrectView)
        view.addSubview(CardView)
        
        if(view.layer.frame.width > view.layer.frame.height){
            IncorrectView.frame = CGRect(x: 20, y: 60, width: (view.layer.frame.width - 80) * 0.15, height: view.frame.height - 80)
            CardView.frame = CGRect(x: 40 + IncorrectView.frame.width, y: 60, width: (view.layer.frame.width - 80) * 0.7, height: view.frame.height - 80)
            CorrectView.frame = CGRect(x: 60 + IncorrectView.frame.width + CardView.frame.width, y: 60, width: (view.layer.frame.width - 80) * 0.15, height: view.frame.height - 80)
        }else{
            let optionsHeight: CGFloat = (view.layer.frame.height - 100) * 0.3
            let topHeight: CGFloat = (view.layer.frame.height - 100) * 0.7
            
            IncorrectView.frame = CGRect(x: 20, y: 80 + topHeight, width: (view.layer.frame.width - 60) * 0.5, height: optionsHeight)
            CardView.frame = CGRect(x: 20, y: 60, width: view.layer.frame.width - 40, height: topHeight)
            CorrectView.frame = CGRect(x: 40 + IncorrectView.frame.width, y: 80 + topHeight, width: (view.layer.frame.width - 60) * 0.5, height: optionsHeight)
            
        }
        
        CardLabel.font = UIFont(name: "LilGrotesk-Regular", size: 40)
        CardLabel.textAlignment = .center
        CardLabel.frame = CGRect(x: 20, y: 0, width: CardView.frame.width - 40, height: CardView.frame.height)
        CardLabel.numberOfLines = 0
        CardLabel.textColor = Colors.text
        CardView.addSubview(CardLabel)
        CardDrawing.frame = CGRect(x: 0, y: 0, width: (view.frame.width - 161), height: 2*(view.frame.width - 161)/3)
        CardDrawing.isUserInteractionEnabled = false
        CardDrawing.layer.cornerRadius = 10
        CardDrawing.backgroundColor = .clear
        CardDrawing.tool = Colors.pen
        CardDrawing.overrideUserInterfaceStyle = .light
        CardView.addSubview(CardDrawing)
        CardDrawing.center = CGPoint(x: CardView.frame.width/2, y: CardView.frame.height/2)
        CardImage.frame = CGRect(x: 20, y: 20, width: CardView.frame.width - 40, height: CardView.frame.height - 40)
        CardImage.contentMode = .scaleAspectFit
        CardView.addSubview(CardImage)
        if(onFront){
            if(cards[cardOrder[index]][0] as! String == "t" || cards[cardOrder[index]][0] as! String == "d-r"){
                CardLabel.text = cards[cardOrder[index]][1] as? String
                CardLabel.isHidden = false
                CardDrawing.isHidden = true
                CardImage.isHidden = true
            }else if(cards[cardOrder[index]][0] as! String == "d"){
                do {
                    try CardDrawing.drawing = recolor(PKDrawing(data: cards[cardOrder[index]][1] as! Data))
                } catch {
                    
                }
                CardLabel.isHidden = true
                CardDrawing.isHidden = false
                CardImage.isHidden = true
            }else{
                CardImage.image = UIImage(data: cards[cardOrder[index]][1] as! Data)
                CardLabel.isHidden = true
                CardDrawing.isHidden = true
                CardImage.isHidden = false
            }
        }
        
        cardButton.addTarget(self, action: #selector(self.CardButton(sender:)), for: .touchUpInside)
        cardButton.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardView.addSubview(cardButton)
        CardView.bringSubviewToFront(cardButton)
        
        let incorrectImage = UIImageView()
        incorrectImage.image = UIImage(systemName: "xmark")
        incorrectImage.tintColor = Colors.text
        incorrectImage.layer.frame = CGRect(x: (IncorrectView.layer.frame.width / 2) - 25, y: (IncorrectView.layer.frame.height / 2) - 25, width: 50, height: 50)
        incorrectImage.contentMode = .scaleAspectFit
        IncorrectView.addSubview(incorrectImage)
        let incorrectButton = UIButton()
        incorrectButton.addTarget(self, action: #selector(self.IncorrectButton(sender:)), for: .touchUpInside)
        incorrectButton.layer.frame = CGRect(x: 0, y: 0, width: IncorrectView.frame.width, height: IncorrectView.frame.height)
        IncorrectView.addSubview(incorrectButton)
        
        swipeLeft.addTarget(self, action: #selector(self.IncorrectSwipe(sender:)))
        swipeLeft.direction = .left
        swipeLeft.view?.layer.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        swipeRight.addTarget(self, action: #selector(self.CorrectSwipe(sender:)))
        swipeRight.direction = .right
        swipeRight.view?.layer.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardView.addGestureRecognizer(swipeLeft)
        CardView.addGestureRecognizer(swipeRight)
        
        let correctImage = UIImageView()
        correctImage.image = UIImage(systemName: "checkmark")
        correctImage.tintColor = Colors.text
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
        cardCounter.frame = CGRect(x: 60, y: 20, width: view.frame.width - 120, height: 20)
        cardCounter.font = UIFont(name: "LilGrotesk-Bold", size: 15)
        cardCounter.textAlignment = .center
        cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
        cardCounter.textColor = Colors.text
        view.addSubview(cardCounter)
        
        OverlayCard.frame = CardView.frame
        OverlayCard.layer.cornerRadius = 10
        OverlayCard.backgroundColor = Colors.secondaryBackground
        OverlayLabel.font = UIFont(name: "LilGrotesk-Regular", size: 40)
        OverlayLabel.textAlignment = .center
        OverlayLabel.frame = CGRect(x: 20, y: 0, width: CardView.frame.width - 40, height: CardView.frame.height)
        OverlayLabel.numberOfLines = 0
        OverlayLabel.textColor = Colors.text
        OverlayCard.addSubview(OverlayLabel)
        OverlayDrawing.frame = CGRect(x: 0, y: 0, width: (view.frame.width - 161), height: 2*(view.frame.width - 161)/3)
        OverlayDrawing.isUserInteractionEnabled = false
        OverlayDrawing.layer.cornerRadius = 10
        OverlayDrawing.backgroundColor = .clear
        OverlayDrawing.tool = Colors.pen
        OverlayDrawing.overrideUserInterfaceStyle = .light
        OverlayCard.addSubview(OverlayDrawing)
        OverlayDrawing.center = CGPoint(x: OverlayCard.frame.width/2, y: OverlayCard.frame.height/2)
        OverlayImage.frame = CGRect(x: 20, y: 20, width: CardView.frame.width - 40, height: CardView.frame.height - 40)
        OverlayImage.contentMode = .scaleAspectFit
        OverlayCard.addSubview(OverlayImage)
        CardView.addSubview(CardImage)
        OverlayCard.isHidden = true
        view.addSubview(OverlayCard)
        
        endScreen.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        CardView.addSubview(endScreen)
        
        endLabel.text = ""
        endLabel.font = UIFont(name: "LilGrotesk-Regular", size: 40)
        endLabel.textColor = Colors.text
        endLabel.frame = CGRect(x: 10, y: 10, width: CardView.frame.width - 20, height: CardView.frame.height - 130)
        endLabel.numberOfLines = 0
        endLabel.textAlignment = .center
        endScreen.addSubview(endLabel)
        
        let endButton = UIButton()
        endButton.frame = CGRect(x: 10, y: CardView.frame.height - 110, width: CardView.frame.width - 20, height: 100)
        endButton.backgroundColor = Colors.highlight
        endButton.setTitle("Next round", for: .normal)
        endButton.setTitleColor(Colors.text, for: .normal)
        endButton.titleLabel!.font = UIFont(name: "LilGrotesk-Bold", size: 30)
        endButton.layer.cornerRadius = 10
        endButton.addTarget(self, action: #selector(self.nextRound(sender:)), for: .touchUpInside)
        endScreen.addSubview(endButton)
        
        endScreen.isHidden = true
        
        view.bringSubviewToFront(OverlayCard)
        
        CardView.frame = CGRect(x: 40 + IncorrectView.frame.width, y: 60, width: (view.layer.frame.width - 80) * 0.7, height: view.frame.height - 80)
    }
    
    @objc func nextRound(sender: UIButton){
        cardOrder = []
        index = 0
        var t = true
        for i in known {
            if(!i){
                t = false
                break
            }
        }
        if t {
            for i in 0..<known.count {
                known[i] = false
            }
        }
        for i in 0 ..< cards.count{
            if(!known[i]){
                cardOrder.append(i)
            }
        }
        if(random){
            cardOrder.shuffle()
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.CardView.layer.opacity = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.cardCounter.text = "1/" + String(self.cardOrder.count)
            self.cardButton.isUserInteractionEnabled = true
            self.IncorrectView.isUserInteractionEnabled = true
            self.CorrectView.isUserInteractionEnabled = true
            self.swipeLeft.isEnabled = true
            self.swipeRight.isEnabled = true
            self.endScreen.isHidden = true
            if(self.cards[self.cardOrder[self.index]][0] as! String == "t" || self.cards[self.cardOrder[self.index]][0] as! String == "d-r"){
                self.CardLabel.text = self.cards[self.cardOrder[self.index]][1] as? String
                self.CardLabel.isHidden = false
                self.CardDrawing.isHidden = true
                self.CardImage.isHidden = true
            }else if(self.cards[self.cardOrder[self.index]][0] as! String == "d"){
                do {
                    try self.CardDrawing.drawing = recolor(PKDrawing(data: self.cards[self.cardOrder[self.index]][1] as! Data))
                } catch {
                    
                }
                self.CardLabel.isHidden = true
                self.CardDrawing.isHidden = false
                self.CardImage.isHidden = true
            }else{
                self.CardImage.image = UIImage(data: self.cards[self.cardOrder[self.index]][1] as! Data)
                self.CardLabel.isHidden = true
                self.CardDrawing.isHidden = true
                self.CardImage.isHidden = false
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.CardView.layer.opacity = 1
            })
        }
    }
    
    @objc func IncorrectButton(sender: UIButton) {
        nextCard(false)
    }
    
    @objc func CorrectButton(sender: UIButton) {
        nextCard(true)
    }
    
    @objc func IncorrectSwipe(sender: UISwipeGestureRecognizer) {
        nextCard(false)
    }
    
    @objc func CorrectSwipe(sender: UISwipeGestureRecognizer) {
        nextCard(true)
    }
    
    func nextCard(_ correct: Bool){
        let overlayI = index
        CardView.frame = CGRect(x: 40 + IncorrectView.frame.width, y: 60, width: (view.layer.frame.width - 80) * 0.7, height: view.frame.height - 80)
        view.bringSubviewToFront(OverlayCard)
        CardView.sendSubviewToBack(endScreen)
        if(correct){
            CorrectView.backgroundColor = Colors.green
            UIView.animate(withDuration: 0.5, animations: {
                self.CorrectView.backgroundColor = Colors.secondaryBackground
            })
        }else{
            IncorrectView.backgroundColor = Colors.red
            UIView.animate(withDuration: 0.5, animations: {
                self.IncorrectView.backgroundColor = Colors.secondaryBackground
            })
        }
        known[cardOrder[index]] = correct
        if(index == cardOrder.count - 1){
            endScreen.isHidden = false
            var t = 0
            for i in cardOrder {
                if(known[i]){
                    t+=1
                }
            }
            var c = 0
            for i in known {
                if(i){
                    c+=1
                }
            }
            endLabel.text = "Correct this round: " + String(t) + "/" + String(cardOrder.count) + "\nCorrect overall: " + String(c) + "/" + String(cards.count)
            cardButton.isUserInteractionEnabled = false
            IncorrectView.isUserInteractionEnabled = false
            CorrectView.isUserInteractionEnabled = false
            swipeLeft.isEnabled = false
            swipeRight.isEnabled = false
            CardLabel.isHidden = true
            CardDrawing.isHidden = true
            CardImage.isHidden = true
        }else{
            index+=1
            cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
            if(self.cards[self.cardOrder[self.index]][0] as! String == "t"){
                self.CardLabel.text = self.cards[self.cardOrder[self.index]][1] as? String
                self.CardLabel.isHidden = false
                self.CardDrawing.isHidden = true
                self.CardImage.isHidden = true
            }else if(self.cards[self.cardOrder[self.index]][0] as! String == "d"){
                do {
                    try self.CardDrawing.drawing = recolor(PKDrawing(data: self.cards[self.cardOrder[self.index]][1] as! Data))
                } catch {
                    
                }
                self.CardLabel.isHidden = true
                self.CardDrawing.isHidden = false
                self.CardImage.isHidden = true
            }else{
                self.CardImage.image = UIImage(data: self.cards[self.cardOrder[self.index]][1] as! Data)
                self.CardLabel.isHidden = true
                self.CardDrawing.isHidden = true
                self.CardImage.isHidden = false
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.CardView.layer.opacity = 1
            })
            
        }
        
        if(onFront){
            if(cards[cardOrder[overlayI]][0] as! String == "t"){
                OverlayLabel.text = cards[cardOrder[overlayI]][1] as? String
                OverlayLabel.isHidden = false
                OverlayDrawing.isHidden = true
                OverlayImage.isHidden = true
            }else if(cards[cardOrder[overlayI]][0] as! String == "d"){
                do {
                    try OverlayDrawing.drawing = recolor(PKDrawing(data: cards[cardOrder[overlayI]][1] as! Data))
                } catch {
                    
                }
                OverlayLabel.isHidden = true
                OverlayDrawing.isHidden = false
                OverlayImage.isHidden = true
            }else{
                OverlayImage.image = UIImage(data: cards[cardOrder[overlayI]][1] as! Data)
                OverlayLabel.isHidden = true
                OverlayDrawing.isHidden = true
                OverlayImage.isHidden = false
            }
        }else{
            if(cards[cardOrder[overlayI]][2] as! String == "t" || cards[cardOrder[overlayI]][2] as! String == "d-r"){
                OverlayLabel.text = cards[cardOrder[overlayI]][3] as? String
                OverlayLabel.isHidden = false
                OverlayDrawing.isHidden = true
                OverlayImage.isHidden = true
            }else if(cards[cardOrder[overlayI]][2] as! String == "d"){
                do {
                    try OverlayDrawing.drawing = recolor(PKDrawing(data: cards[cardOrder[overlayI]][3] as! Data))
                } catch {
                    
                }
                OverlayLabel.isHidden = true
                OverlayDrawing.isHidden = false
                OverlayImage.isHidden = true
            }//else{
//                OverlayImage.image = UIImage(data: cards[cardOrder[index]][3] as! Data)
//                OverlayLabel.isHidden = true
//                OverlayDrawing.isHidden = true
//                OverlayImage.isHidden = false
//            }
        }
        OverlayCard.isHidden = false
        OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
        OverlayCard.alpha = 1
        OverlayCard.layer.position = CardView.layer.position
        CardView.layer.opacity = 0
        if(correct){
            UIView.animate(withDuration: 0.5, animations: {
                self.OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
                self.OverlayCard.alpha = 0
                self.OverlayCard.layer.position = CGPoint(x: self.view.frame.width, y: self.view.frame.height / 2)
                self.CardView.layer.opacity = 1
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
                self.OverlayCard.alpha = 0
                self.OverlayCard.layer.position = CGPoint(x: 0, y: self.view.frame.height / 2)
                self.CardView.layer.opacity = 1
            })
        }
        
        CardView.layer.transform = CATransform3DIdentity
        CardLabel.layer.transform = CATransform3DIdentity
        CardDrawing.layer.transform = CATransform3DIdentity
        CardImage.layer.transform = CATransform3DIdentity
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.OverlayCard.isHidden = true
        }
        
        onFront = true
        save()
    }
    
    func save(){
        var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
        previousData[set]["flashcards"] = known
        defaults.set(previousData, forKey: "sets")
    }
    
    @objc func CardButton(sender: UIButton) {
        if(onFront){
            DispatchQueue.main.asyncAfter(deadline: .now() + (cardAnimation/2)){
                if(self.cards[self.cardOrder[self.index]][2] as! String == "t" || self.cards[self.cardOrder[self.index]][2] as! String == "d-r"){
                    self.CardLabel.text = self.cards[self.cardOrder[self.index]][3] as? String
                    self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
                    self.CardLabel.isHidden = false
                    self.CardDrawing.isHidden = true
                    self.CardImage.isHidden = true
                }else if(self.cards[self.cardOrder[self.index]][2] as! String == "d"){
                    do {
                        try self.CardDrawing.drawing = recolor(PKDrawing(data: self.cards[self.cardOrder[self.index]][3] as! Data))
                    } catch {
                        
                    }
                    self.CardDrawing.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
                    self.CardLabel.isHidden = true
                    self.CardDrawing.isHidden = false
                    self.CardImage.isHidden = true
                }
            }
            UIView.animate(withDuration: cardAnimation, animations: {
                self.CardView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            })
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + (cardAnimation/2)){
                if(self.cards[self.cardOrder[self.index]][0] as! String == "t"){
                    self.CardLabel.text = self.cards[self.cardOrder[self.index]][1] as? String
                    self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
                    self.CardLabel.isHidden = false
                    self.CardDrawing.isHidden = true
                    self.CardImage.isHidden = true
                }else if(self.cards[self.cardOrder[self.index]][0] as! String == "d"){
                    do {
                        try self.CardDrawing.drawing = recolor(PKDrawing(data: self.cards[self.cardOrder[self.index]][1] as! Data))
                    } catch {
                        
                    }
                    self.CardDrawing.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
                    self.CardLabel.isHidden = true
                    self.CardDrawing.isHidden = false
                    self.CardImage.isHidden = true
                }else{
                    self.CardImage.image = UIImage(data: self.cards[self.cardOrder[self.index]][1] as! Data)
                    self.CardImage.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
                    self.CardLabel.isHidden = true
                    self.CardDrawing.isHidden = true
                    self.CardImage.isHidden = false
                }
            }
            UIView.animate(withDuration: cardAnimation, animations: {
                self.CardView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
            })
        }
        onFront = !onFront
    }
    
    @objc func BackButton(sender: UIButton){
        performSegue(withIdentifier: "flashcardsVC_unwind", sender: nil)
    }
    
    @objc func SettingsButton(sender: UIButton){
        
    }
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }

}
