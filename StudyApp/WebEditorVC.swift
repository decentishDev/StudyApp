//
//  WebEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/16/24.
//

import UIKit

class WebEditorVC: UIViewController, UIScrollViewDelegate, EditorDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let defaults = UserDefaults.standard

    var set = 0
    var name = "Revolutionary War"
    var rectangles: [UIView] = []
    var scrollView: UIScrollView!
    var web: [[Any]] = []
    var currentEdit: Int = -1
    var selectedButton: UIButton? = nil
    var addedButtons: [UIButton] = []
    
    var moveRequestNumber = 0
    
    var canUpdate = true
    let loadingView = UILabel()
    
    let imagePicker = UIImagePickerController()
    let imageButton = UIButton()
    let titleField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        let data = (defaults.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        //print(data)
        name = data["name"] as! String
        web = data["set"] as! [[Any]]
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        
        view.addSubview(scrollView)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        loadingView.text = "Loading web . . ."
        loadingView.font = UIFont(name: "LilGrotesk-Bold", size: 25)
        loadingView.backgroundColor = Colors.background
        
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "arrowshape.backward.fill"), for: .normal)
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        backButton.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        backButton.backgroundColor = Colors.secondaryBackground
        backButton.layer.cornerRadius = 10
        backButton.tintColor = Colors.highlight
        
        view.addSubview(backButton)
        
        titleField.delegate = self
        titleField.text = name
        titleField.placeholder = "Set name"
        titleField.frame = CGRect(x: 90, y: 30, width: 350, height: 50)
        titleField.font = UIFont(name: "LilGrotesk-Bold", size: 25)
        titleField.textColor = Colors.highlight
        titleField.backgroundColor = Colors.secondaryBackground
        titleField.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, titleField.frame.height))
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        
        view.addSubview(titleField)
        
        let addButton = UIButton()
        addButton.setTitle("+ Add term", for: .normal)
        addButton.setTitleColor(Colors.highlight, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "LilGrotesk-Bold", size: 25)
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        addButton.frame = CGRect(x: view.frame.width - 420, y: 30, width: 150, height: 50)
        addButton.backgroundColor = Colors.secondaryBackground
        addButton.layer.cornerRadius = 10
        
        view.addSubview(addButton)
        
        let themesButton = UIButton()
        themesButton.setTitle("Themes", for: .normal)
        themesButton.setTitleColor(Colors.highlight, for: .normal)
        themesButton.titleLabel?.font = UIFont(name: "LilGrotesk-Bold", size: 25)
        themesButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        themesButton.frame = CGRect(x: view.frame.width - 260, y: 30, width: 110, height: 50)
        themesButton.backgroundColor = Colors.secondaryBackground
        themesButton.layer.cornerRadius = 10
        
        view.addSubview(themesButton)
        if((defaults.value(forKey: "images") as! [Data?])[set] == Colors.placeholderI){
            imageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        }else{
            imageButton.setImage(UIImage(systemName: "rectangle.badge.xmark.fill"), for: .normal)
        }
        imageButton.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
        imageButton.frame = CGRect(x: view.frame.width - 140, y: 30, width: 50, height: 50)
        imageButton.backgroundColor = Colors.secondaryBackground
        imageButton.layer.cornerRadius = 10
        imageButton.tintColor = Colors.highlight
        
        view.addSubview(imageButton)
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteSet(_:)), for: .touchUpInside)
        deleteButton.frame = CGRect(x: view.frame.width - 80, y: 30, width: 50, height: 50)
        deleteButton.backgroundColor = Colors.secondaryBackground
        deleteButton.layer.cornerRadius = 10
        deleteButton.tintColor = Colors.highlight
        
        view.addSubview(deleteButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackgroundPan(_:)))
        scrollView.addGestureRecognizer(panGesture)
        
        let deselect = UITapGestureRecognizer(target: self, action: #selector(handleBackTap(_:)))
        scrollView.addGestureRecognizer(deselect)

        for term in web {
            let rectWidth: CGFloat = 180
            let rectHeight: CGFloat = 180
            
            let centerX = term[2] as! CGFloat
            let centerY = term[3] as! CGFloat
            
            let newX = centerX - rectWidth / 2
            let newY = centerY - rectHeight / 2
            
            let rectangle = UIView(frame: CGRect(x: newX, y: newY, width: rectWidth, height: rectHeight))
            rectangle.backgroundColor = .clear
            
            let visible = UIView(frame: CGRect(x: 0, y: 30, width: rectWidth, height: rectHeight - 60))
            visible.backgroundColor = Colors.secondaryBackground
            visible.layer.cornerRadius = 10
            rectangle.addSubview(visible)
            
            let topConnections = UIStackView()
            let bottomConnections = UIStackView()
            topConnections.axis = .horizontal
            topConnections.alignment = .fill
            topConnections.distribution = .fillProportionally
            topConnections.translatesAutoresizingMaskIntoConstraints = false
            topConnections.isUserInteractionEnabled = true
            topConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            topConnections.autoresizesSubviews = false
            bottomConnections.axis = .horizontal
            bottomConnections.alignment = .fill
            bottomConnections.distribution = .fillProportionally
            bottomConnections.translatesAutoresizingMaskIntoConstraints = false
            bottomConnections.isUserInteractionEnabled = true
            bottomConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            bottomConnections.autoresizesSubviews = false
            
            rectangle.addSubview(topConnections)
            rectangle.addSubview(bottomConnections)
            NSLayoutConstraint.activate([
                topConnections.topAnchor.constraint(equalTo: rectangle.topAnchor),
                topConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
                bottomConnections.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor),
                bottomConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor)
            ])
            
            let termLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 170, height: 120))
            termLabel.text = term[0] as? String
            termLabel.textColor = Colors.text
            termLabel.font = UIFont(name: "LilGrotesk-Regular", size: 18)
            termLabel.textAlignment = .center
            termLabel.numberOfLines = 0
            visible.addSubview(termLabel)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            rectangle.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editCard(_:)))
            rectangle.addGestureRecognizer(tapGesture)
            
            scrollView.addSubview(rectangle)
            rectangles.append(rectangle)
        }
        for (i, rect) in rectangles.enumerated(){
            for connection in (web[i][4] as! [Int]){
                let connectButton = UIButton()
                connectButton.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
                connectButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
                connectButton.tintColor = Colors.text
                connectButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                connectButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
                connectButton.translatesAutoresizingMaskIntoConstraints = false
                (rect.subviews[2] as! UIStackView).addArrangedSubview(connectButton)

                let otherButton = UIButton()
                otherButton.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
                otherButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
                otherButton.tintColor = Colors.text

                otherButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                otherButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
                otherButton.translatesAutoresizingMaskIntoConstraints = false
                otherButton.accessibilityIdentifier = String(i)

                (rectangles[connection].subviews[1] as! UIStackView).addArrangedSubview(otherButton)


                let endPoint = otherButton.convert(otherButton.anchorPoint, to: connectButton)

                let lineLayer = CAShapeLayer()
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x: 15, y: 15))
                linePath.addLine(to: CGPoint(x: endPoint.x + 15, y: endPoint.y + 15))
                lineLayer.path = linePath.cgPath
                lineLayer.strokeColor = Colors.text.cgColor
                lineLayer.lineWidth = 2.0 // Adjust line width as needed
                
                connectButton.layer.addSublayer(lineLayer)
            }

            let addConnection = UIButton()
            addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            addConnection.tintColor = Colors.highlight
            addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
            addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
            (rect.subviews[2] as! UIStackView).addArrangedSubview(addConnection)
            addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
            addConnection.translatesAutoresizingMaskIntoConstraints = false
            addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.updateLines()
            UIView.animate(withDuration: 0.25, animations: {
                self.loadingView.layer.opacity = 0
            }, completion: {_ in 
                self.loadingView.removeFromSuperview()
            })
        }
        
        if defaults.value(forKey: "beenInWebEditor") == nil{
            defaults.setValue(true, forKey: "beenInWebEditor")
            
            let introView = UIView(frame: CGRect(x: view.frame.width - 380, y: view.frame.height - 440, width: 350, height: 410))
            view.addSubview(introView)
            introView.backgroundColor = Colors.secondaryBackground
            introView.layer.cornerRadius = 10
            
            let exitIntroButton = UIButton(frame: CGRect(x: 300, y: 20, width: 30, height: 30))
            introView.addSubview(exitIntroButton)
            exitIntroButton.tintColor = Colors.highlight
            exitIntroButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            exitIntroButton.imageView?.contentMode = .scaleAspectFit
            exitIntroButton.contentMode = .scaleAspectFit
            exitIntroButton.layoutMargins = .zero
            exitIntroButton.addTarget(self, action: #selector(exitIntro(_:)), for: .touchUpInside)
            
            let introTitle = UILabel(frame: CGRect(x: 20, y: 20 - 3, width: 290, height: 30))
            introView.addSubview(introTitle)
            introTitle.font = UIFont(name: "LilGrotesk-Bold", size: 23)
            introTitle.textColor = Colors.text
            introTitle.text = "Creating web sets"
            introTitle.clipsToBounds = false
            
            let introTips = UILabel(frame: CGRect(x: 20, y: 60, width: 310, height: 340))
            introView.addSubview(introTips)
            introTips.numberOfLines = 0
            introTips.font = UIFont(name: "LilGrotesk-Regular", size: 23)
            introTips.textColor = Colors.text
            introTips.text = " - Visualize processes by connecting terms downward\n\n - After adding multiple terms, connect them using the plus icons\n\n - You can tap on terms to edit them\n\n - You can tap on connections to remove them"
        }
    }
    @objc func exitIntro(_ sender: UIButton) {
        let introView = sender.superview!
        UIView.animate(withDuration: 0.5, animations: {
            introView.alpha = 0
            introView.frame = CGRect(x: introView.frame.minX, y: introView.frame.minY + 800, width: introView.frame.width, height: introView.frame.height)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
            introView.removeFromSuperview()
        }
    }
    @objc func addButtonTapped(_ sender: UIButton) {
        currentEdit = -1
        
        let popupVC = WebTermEditorVC()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
        
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
            self.performSegue(withIdentifier: "webEditorVC_unwind", sender: nil)
            self.performSegue(withIdentifier: "webEditorVC_unwind", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func themeButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func back(_ sender: UIButton) {
        performSegue(withIdentifier: "webEditorVC_unwind", sender: nil)
    }
    
    @objc func handleBackTap(_ gestureRecognizer: UITapGestureRecognizer) {
        titleField.resignFirstResponder()
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        guard let movedView = gestureRecognizer.view else { return }

        let newX = movedView.center.x + translation.x
        let newY = movedView.center.y + translation.y
        movedView.center = CGPoint(x: newX, y: newY)
 
        gestureRecognizer.setTranslation(.zero, in: movedView)

        let rectI = rectangles.firstIndex(of: movedView)

        web[rectI!][2] = movedView.center.x
        web[rectI!][3] = movedView.center.y
        
        save()
        
        updateLines()
    }
    
    func save(){
        var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
        previousData[set]["set"] = web
        previousData[set]["name"] = name
        previousData[set]["date"] = "Last edited: " + dateString()
        defaults.set(previousData, forKey: "sets")
    }
    
    func updateLines(){
        for (i, term) in web.enumerated() {
            var newOrder: [Int] = []
            for j in (term[4] as! [Int]){
                if newOrder.isEmpty {
                    newOrder.append(j)
                }else{
                    for c in 0 ..< newOrder.count {
                        if ((web[j][2] as! CGFloat) <= (web[newOrder[c]][2] as! CGFloat)){
                            newOrder.insert(j, at: c)
                            break
                        }else if ((c + 1) == newOrder.count) {
                            newOrder.append(j)
                        }
                    }
                }
            }
            web[i][4] = newOrder
        }
        for (rectI, movedView) in rectangles.enumerated(){
            let outgoing = web[rectI][4] as? [Int]
            if(outgoing!.count > 0){
                for i in 0...outgoing!.count - 1 {
                    let thisButton = (movedView.subviews[2] as! UIStackView).arrangedSubviews[i]
                    var otherButtonI = -1
                    
                    for button in (rectangles[outgoing![i]].subviews[1] as! UIStackView).arrangedSubviews{
                        otherButtonI += 1
                        if(Int(button.accessibilityIdentifier!) == rectI){
                            break
                        }
                    }
                    
                    let otherButton = (rectangles[outgoing![i]].subviews[1] as! UIStackView).arrangedSubviews[otherButtonI]

                    let endPoint = otherButton.convert(otherButton.anchorPoint, to: thisButton)

                    let linePath = UIBezierPath()
                    linePath.move(to: CGPoint(x: 15, y: 15))
                    linePath.addLine(to: CGPoint(x: endPoint.x + 15, y: endPoint.y + 15))
                    (thisButton.layer.sublayers![1] as! CAShapeLayer).path = linePath.cgPath
                    
                }
            }
        }
    }
    
    @objc func editCard(_ gestureRecognizer: UITapGestureRecognizer) {
        let popupVC = WebTermEditorVC()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        
        let i = rectangles.firstIndex(of: gestureRecognizer.view!)!
        currentEdit = i
        popupVC.defField.text = web[i][1] as? String
        popupVC.termField.text = web[i][0] as? String
        popupVC.addingTerm = false
        
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func handleBackgroundPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - translation.x, y: scrollView.contentOffset.y - translation.y)
        gestureRecognizer.setTranslation(.zero, in: view)
    }
    
    func didAddTerm(data: [Any]){
        if(currentEdit == -1){
            let rectWidth: CGFloat = 180
            let rectHeight: CGFloat = 180
            
            let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
            let centerY = scrollView.contentOffset.y + scrollView.bounds.height / 2
            
            let newX = centerX - rectWidth / 2
            let newY = centerY - rectHeight / 2
            
            let rectangle = UIView(frame: CGRect(x: newX, y: newY, width: rectWidth, height: rectHeight))
            rectangle.backgroundColor = .clear
            
            let visible = UIView(frame: CGRect(x: 0, y: 30, width: rectWidth, height: rectHeight - 60))
            visible.backgroundColor = Colors.secondaryBackground
            visible.layer.cornerRadius = 10
            rectangle.addSubview(visible)
            
            let topConnections = UIStackView()
            let bottomConnections = UIStackView()
            topConnections.axis = .horizontal
            topConnections.alignment = .fill
            topConnections.distribution = .fillProportionally
            topConnections.translatesAutoresizingMaskIntoConstraints = false
            topConnections.isUserInteractionEnabled = true
            topConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            topConnections.autoresizesSubviews = false
            bottomConnections.axis = .horizontal
            bottomConnections.alignment = .fill
            bottomConnections.distribution = .fillProportionally
            bottomConnections.translatesAutoresizingMaskIntoConstraints = false
            bottomConnections.isUserInteractionEnabled = true
            bottomConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            bottomConnections.autoresizesSubviews = false
            
            let addConnection = UIButton()

            addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            addConnection.tintColor = Colors.highlight
            addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
            addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
            bottomConnections.addArrangedSubview(addConnection)
            addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
            addConnection.translatesAutoresizingMaskIntoConstraints = false
            addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
            rectangle.addSubview(topConnections)
            rectangle.addSubview(bottomConnections)
            NSLayoutConstraint.activate([
                topConnections.topAnchor.constraint(equalTo: rectangle.topAnchor),
                topConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
                bottomConnections.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor),
                bottomConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor)
            ])
            
            let termLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 170, height: 120))
            termLabel.text = data[0] as? String
            termLabel.textColor = Colors.text
            termLabel.font = UIFont(name: "LilGrotesk-Regular", size: 15)
            termLabel.textAlignment = .center
            termLabel.numberOfLines = 0
            visible.addSubview(termLabel)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            rectangle.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editCard(_:)))
            rectangle.addGestureRecognizer(tapGesture)
            
            scrollView.addSubview(rectangle)
            rectangles.append(rectangle)
            web.append([data[0], data[1], newX, newY, []])
            web[web.count - 1][2] = newX
            web[web.count - 1][3] = newY
            
            save()
        }else{
            web[currentEdit] = [data[0], data[1], web[currentEdit][2], web[currentEdit][3], web[currentEdit][4]]
            (rectangles[currentEdit].subviews[0].subviews[0] as! UILabel).text = data[0] as? String
            save()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @objc func newConnection(_ sender: UIButton){
        if(rectangles.count > 1){
            selectedButton = sender
            
            let index = rectangles.firstIndex(of: (sender.superview?.superview)!)
            for (i, rectangle) in rectangles.enumerated() {
                if(rectangle != sender.superview?.superview && !(web[index!][4] as! [Int]).contains(i)){
                    sender.isEnabled = false
                    let addConnection = UIButton()
                    addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                    
                    addConnection.tintColor = Colors.highlight
                    addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
                    addConnection.imageView!.layoutIfNeeded()
                    addConnection.accessibilityIdentifier = String(index!)
                    addConnection.addTarget(self, action: #selector(finishConnection(_:)), for: .touchUpInside)

                    (rectangle.subviews[1] as! UIStackView).addArrangedSubview(addConnection)
                    addConnection.translatesAutoresizingMaskIntoConstraints = false
                    addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
                    addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
                    addedButtons.append(addConnection)
                }
            }
            updateLines()
        }

    }
    
    @objc func finishConnection(_ sender: UIButton){

        selectedButton?.setImage(nil, for: .normal)
        selectedButton?.isEnabled = true
        sender.setImage(UIImage(systemName: "record.circle"), for: .normal)
        sender.tintColor = Colors.text
        sender.removeTarget(self, action: #selector(finishConnection(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)

        
        let addConnection = UIButton()
        addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addConnection.tintColor = Colors.highlight
        addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false

        addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
        (selectedButton?.superview as! UIStackView).addArrangedSubview(addConnection)
        
        addConnection.translatesAutoresizingMaskIntoConstraints = false
        addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        let endPoint = sender.convert(sender.anchorPoint, to: selectedButton)

        let lineLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 15, y: 15))
        linePath.addLine(to: CGPoint(x: endPoint.x + 15, y: endPoint.y + 15))
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = Colors.text.cgColor
        lineLayer.lineWidth = 2.0
        
        selectedButton!.layer.addSublayer(lineLayer)

        for _ in 0...addedButtons.count - 1 {
            if(addedButtons[0] != sender){
                addedButtons[0].removeFromSuperview()
            }
            addedButtons.remove(at: 0)
        }
        let rectI = rectangles.firstIndex(of: (selectedButton?.superview?.superview)!)! as Int
        let outI = rectangles.firstIndex(of: (sender.superview?.superview)!)! as Int
        if var webArray = web[rectI][4] as? [Int] {
            webArray.append(outI)
            web[rectI][4] = webArray
        }
        
        selectedButton?.removeTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
        selectedButton?.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
        selectedButton?.setImage(UIImage(systemName: "record.circle"), for: .normal)
        selectedButton?.tintColor = Colors.text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.updateLines()
        }
        save()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        name = textField.text!
        
        save()
    }
    
    @objc func editConnection(_ sender: UIButton){
        let thisIndex = rectangles.firstIndex(of: (sender.superview?.superview)!)
        if let topIndex = sender.accessibilityIdentifier {
            let topButtonStackI = (web[Int(topIndex)!][4] as! [Int]).firstIndex(of: thisIndex!)
            let topButton = (rectangles[Int(topIndex)!].subviews[2] as! UIStackView).arrangedSubviews[topButtonStackI!]
            topButton.removeFromSuperview()
            var a = (web[Int(topIndex)!][4] as! [Int])
            a.remove(at: topButtonStackI!)
            var b = web[Int(topIndex)!]
            b[4] = a
            web[Int(topIndex)!] = b
        }else{
            let topButtonStackI = (sender.superview as! UIStackView).arrangedSubviews.firstIndex(of: sender)
            let bottomI = (web[thisIndex!][4] as! [Int])[topButtonStackI!]
            var a = (web[thisIndex!][4] as! [Int])
            a.remove(at: topButtonStackI!)
            var b = web[thisIndex!]
            b[4] = a
            web[thisIndex!] = b
            for i in (rectangles[bottomI].subviews[1] as! UIStackView).arrangedSubviews {
                if let x = i.accessibilityIdentifier {
                    if Int(x) == thisIndex! {
                        i.removeFromSuperview()
                        break
                    }
                }
            }
        }
        sender.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.updateLines()
        }
        save()
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
    
    func deleteTerm() {
        print(web)
        for i in (web[currentEdit][4] as! [Int]){
            for button in (rectangles[i].subviews[1] as! UIStackView).arrangedSubviews {
                if button.accessibilityIdentifier == String(currentEdit){
                    button.removeFromSuperview()
                }
            }
        }
        rectangles[currentEdit].removeFromSuperview()
        rectangles.remove(at: currentEdit)
        web.remove(at: currentEdit)
        for (i, term) in web.enumerated() {
            if var indices = term[4] as? [Int] {
                for (j, I) in indices.enumerated() {
                    if I == currentEdit{
                        indices.remove(at: j)
                        (rectangles[i].subviews[2] as! UIStackView).arrangedSubviews[j].removeFromSuperview()
                    }
                    if I > currentEdit{
                        indices[j] = I - 1
                    }
                }
                web[i][4] = indices
            }
        }
        
        for rectangle in rectangles {
            for button in (rectangle.subviews[1] as! UIStackView).arrangedSubviews {
                if(button.accessibilityIdentifier != nil && Int(button.accessibilityIdentifier!)! > currentEdit){
                    button.accessibilityIdentifier = String(Int(button.accessibilityIdentifier!)! - 1)
                }
            }
        }
        
        save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.updateLines()
        }
    }
    
    @objc func changeImage(_ sender: UIButton) {
        var images = (defaults.value(forKey: "images") as! [Data?])
        if images[set] == Colors.placeholderI {
            present(imagePicker, animated: true, completion: nil)
        }else{
            images[set] = Colors.placeholderI
            defaults.setValue(images, forKey: "images")
            imageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = pickedImage.pngData() {
                var images = (defaults.value(forKey: "images") as! [Data?])
                images[set] = imageData
                defaults.setValue(images, forKey: "images")
                imageButton.setImage(UIImage(systemName: "rectangle.badge.xmark.fill"), for: .normal)
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
