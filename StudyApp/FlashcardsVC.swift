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
    let OverlayCard = UIView()
    let OverlayLabel = UILabel()
    let OverlayDrawing = PKCanvasView()
    let OverlayIMage = UIImageView()
    
    var onFront = true
    var startOnFront = true
    var random = true
    var cardOrder: [Int] = []
    let defaults = UserDefaults.standard
    var cards: [[Any]] = [] //t: text, d: drawing, s: speech - maybe

    var known: [Bool] = []
    var index: Int = 0
    let cardAnimation = 0.6
    
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
        
        CardLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 40)
        CardLabel.textAlignment = .center
        CardLabel.frame = CGRect(x: 20, y: 0, width: CardView.frame.width - 40, height: CardView.frame.height)
        CardLabel.numberOfLines = 0
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
        incorrectImage.tintColor = Colors.text
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
        cardCounter.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 15)
        cardCounter.textAlignment = .center
        cardCounter.text = String(index + 1) + "/" + String(cardOrder.count)
        cardCounter.textColor = Colors.text
        view.addSubview(cardCounter)
        
        OverlayCard.frame = CardView.frame
        OverlayCard.layer.cornerRadius = 10
        OverlayCard.backgroundColor = Colors.secondaryBackground
        OverlayLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 40)
        OverlayLabel.textAlignment = .center
        OverlayLabel.frame = CGRect(x: 20, y: 0, width: CardView.frame.width - 40, height: CardView.frame.height)
        OverlayLabel.numberOfLines = 0
        OverlayCard.addSubview(OverlayLabel)
        OverlayDrawing.frame = CGRect(x: 0, y: 0, width: CardView.frame.width, height: CardView.frame.height)
        OverlayDrawing.isUserInteractionEnabled = false
        OverlayCard.addSubview(OverlayDrawing)
        OverlayCard.isHidden = true
        view.addSubview(OverlayCard)
        view.bringSubviewToFront(OverlayCard)
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
            self.CorrectView.backgroundColor = Colors.secondaryBackground
        })
        known[cardOrder[index]] = true
        if(index == cardOrder.count - 1){
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
            CardView.layer.opacity = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
                self.OverlayCard.alpha = 0
                self.OverlayCard.layer.position = CGPoint(x: self.view.frame.width, y: self.view.frame.height / 2)
                self.CardView.layer.opacity = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.OverlayCard.isHidden = true
            }
        }
        save()
    }
    
    func Incorrect(){
        IncorrectView.backgroundColor = .red
        UIView.animate(withDuration: 0.5, animations: {
            self.IncorrectView.backgroundColor = Colors.secondaryBackground
        })
        known[cardOrder[index]] = false
        if(index == cardOrder.count - 1){
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
            CardView.layer.opacity = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.OverlayCard.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
                self.OverlayCard.alpha = 0
                self.OverlayCard.layer.position = CGPoint(x: 0, y: self.view.frame.height / 2)
                self.CardView.layer.opacity = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.OverlayCard.isHidden = true
            }
        }
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
                if(self.cards[self.cardOrder[self.index]][0] as! String == "t"){
                    self.CardLabel.text = self.cards[self.cardOrder[self.index]][3] as? String
                    self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
                }
            }
            UIView.animate(withDuration: cardAnimation, animations: {
                self.CardView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            })
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + (cardAnimation/2)){
                if(self.cards[self.cardOrder[self.index]][2] as! String == "t"){
                    self.CardLabel.text = self.cards[self.cardOrder[self.index]][1] as? String
                    self.CardLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
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
