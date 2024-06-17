//
//  WebViewerVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/14/24.
//

import UIKit

class WebViewerVC: UIViewController, UIScrollViewDelegate {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background

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
        
        let titleField = UILabel()
        titleField.text = name
        titleField.frame = CGRect(x: 90, y: 30, width: 350, height: 50)
        titleField.font = UIFont(name: "LilGrotesk-Bold", size: 25)
        titleField.textColor = Colors.highlight
        //titleField.backgroundColor = Colors.secondaryBackground
        titleField.layer.cornerRadius = 10
        titleField.textAlignment = .left
//        let paddingView = UIView(frame: CGRectMake(0, 0, 15, titleField.frame.height))
//        titleField.leftView = paddingView
//        titleField.leftViewMode = .always
        
        view.addSubview(titleField)
        
//        let addButton = UIButton()
//        addButton.setTitle("+ Add term", for: .normal)
//        addButton.setTitleColor(Colors.highlight, for: .normal)
//        addButton.titleLabel?.font = UIFont(name: "LilGrotesk-Bold", size: 25)
//        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
//        addButton.frame = CGRect(x: view.frame.width - 300, y: 30, width: 150, height: 50)
//        addButton.backgroundColor = Colors.secondaryBackground
//        addButton.layer.cornerRadius = 10
//        
//        view.addSubview(addButton)
//        
//        let themesButton = UIButton()
//        themesButton.setTitle("Themes", for: .normal)
//        themesButton.setTitleColor(Colors.highlight, for: .normal)
//        themesButton.titleLabel?.font = UIFont(name: "LilGrotesk-Bold", size: 25)
//        themesButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
//        themesButton.frame = CGRect(x: view.frame.width - 140, y: 30, width: 110, height: 50)
//        themesButton.backgroundColor = Colors.secondaryBackground
//        themesButton.layer.cornerRadius = 10
//        
//        view.addSubview(themesButton)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackgroundPan(_:)))
        scrollView.addGestureRecognizer(panGesture)

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
            //topConnections.backgroundColor = .purple
            topConnections.alignment = .fill
            topConnections.distribution = .fillProportionally
            topConnections.translatesAutoresizingMaskIntoConstraints = false
            topConnections.isUserInteractionEnabled = true
            topConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            topConnections.autoresizesSubviews = false
            bottomConnections.axis = .horizontal
            //bottomConnections.backgroundColor = .orange
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
            
//            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//            rectangle.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editCard(_:)))
            rectangle.addGestureRecognizer(tapGesture)
            
            scrollView.addSubview(rectangle)
            rectangles.append(rectangle)
//            web.append([term[0], term[1], newX, newY, []])
//            web[web.count - 1][2] = newX
//            web[web.count - 1][3] = newY
        }
        for (i, rect) in rectangles.enumerated(){
            for connection in (web[i][4] as! [Int]){
                let connectButton = UIButton()
                //connectButton.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
                connectButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                connectButton.tintColor = .clear
                //connectButton.setImage(nil, for: .normal)
                connectButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                connectButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
                connectButton.translatesAutoresizingMaskIntoConstraints = false
                (rect.subviews[2] as! UIStackView).addArrangedSubview(connectButton)
                //connectButton.backgroundColor = .blue

                let otherButton = UIButton()
                //otherButton.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
                otherButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                otherButton.tintColor = .clear
                //otherButton.setImage(nil, for: .normal)
                otherButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                otherButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
                otherButton.translatesAutoresizingMaskIntoConstraints = false
                otherButton.accessibilityIdentifier = String(i)
                //otherButton.backgroundColor = .brown
                (rectangles[connection].subviews[1] as! UIStackView).addArrangedSubview(otherButton)


                let endPoint = otherButton.convert(otherButton.anchorPoint, to: connectButton)
                // print(sender.center)
                // print(endPoint)
                let lineLayer = CAShapeLayer()
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x: 15, y: 15))
                linePath.addLine(to: CGPoint(x: endPoint.x + 15, y: endPoint.y + 15))
                lineLayer.path = linePath.cgPath
                lineLayer.strokeColor = Colors.text.cgColor
                lineLayer.lineWidth = 2.0 // Adjust line width as needed
                
                connectButton.layer.addSublayer(lineLayer)
            }

//            let addConnection = UIButton()
//            addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//            addConnection.imageView?.tintColor = Colors.highlight
//            addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
//            //addConnection.backgroundColor = .red
//            addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
//            (rect.subviews[2] as! UIStackView).addArrangedSubview(addConnection)
////            rectangle.addSubview(addConnection)
////            addConnection.frame = CGRect(x: rectangle.frame.width / 2 - 15, y: rectangle.frame.height, width: 30, height: 30)
//            addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            addConnection.translatesAutoresizingMaskIntoConstraints = false
//            addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.updateLines()
            UIView.animate(withDuration: 0.25, animations: {
                self.loadingView.layer.opacity = 0
            }, completion: {_ in
                self.loadingView.removeFromSuperview()
            })
        }
    }
    
//    @objc func addButtonTapped(_ sender: UIButton) {
//        currentEdit = -1
//        
//        let popupVC = WebTermEditorVC()
//        popupVC.delegate = self
//        popupVC.modalPresentationStyle = .overCurrentContext
//        popupVC.modalTransitionStyle = .crossDissolve
//        present(popupVC, animated: true, completion: nil)
//        
//    }
    
//    @objc func themeButtonTapped(_ sender: UIButton) {
//        //print("themes")
//        
//    }
    
    @objc func back(_ sender: UIButton) {
        performSegue(withIdentifier: "webViewerVC_unwind", sender: nil)
    }
    
//    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: view)
//        guard let movedView = gestureRecognizer.view else { return }
//
//        let newX = movedView.center.x + translation.x
//        let newY = movedView.center.y + translation.y
//        movedView.center = CGPoint(x: newX, y: newY)
// 
//        gestureRecognizer.setTranslation(.zero, in: movedView)
//
//        let rectI = rectangles.firstIndex(of: movedView)
//
//        web[rectI!][2] = movedView.center.x
//        web[rectI!][3] = movedView.center.y
//        
//        save()
//        
//        updateLines()
//    }
    
//    func save(){
//        var previousData = defaults.object(forKey: "sets") as! [Dictionary<String, Any>]
//        previousData[set]["set"] = web
//        previousData[set]["name"] = name
//        defaults.set(previousData, forKey: "sets")
//    }
    
    func updateLines(){
        for (rectI, movedView) in rectangles.enumerated(){
//            let rectI = rectangles.firstIndex(of: movedView)
            let outgoing = web[rectI][4] as? [Int]
            if(outgoing!.count > 0){
                for i in 0...outgoing!.count - 1 {
                    let thisButton = (movedView.subviews[2] as! UIStackView).arrangedSubviews[i]
                    var otherButtonI = -1
                    
                    for button in (rectangles[outgoing![i]].subviews[1] as! UIStackView).arrangedSubviews{
                        otherButtonI += 1
                        if(Int(button.accessibilityIdentifier!) == rectI){ //Unexpectedly found nil while unwrapping an optional value
                            break
                        }
                    }
                    
                    let otherButton = (rectangles[outgoing![i]].subviews[1] as! UIStackView).arrangedSubviews[otherButtonI]
                    //print(otherButtonI)
                    let endPoint = otherButton.convert(otherButton.anchorPoint, to: thisButton)
                    //print(thisButton.center)
                    let linePath = UIBezierPath()
                    linePath.move(to: CGPoint(x: 15, y: 15))
                    linePath.addLine(to: CGPoint(x: endPoint.x + 15, y: endPoint.y + 15))
                    
                    //print(thisButton.layer.sublayers!.count)
                    //print(thisButton.layer.sublayers!)
                    (thisButton.layer.sublayers![1] as! CAShapeLayer).path = linePath.cgPath //Could not cast value of type '_UILabelLayer' (0x1f494d310) to 'CAShapeLayer' (0x1f49a2870).
                    
                }
            }
        }
    }
    
    @objc func editCard(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let rectangle = gestureRecognizer.view else { return }
        //rectangle.backgroundColor = Colors.darkHighlight
        let i = rectangles.firstIndex(of: rectangle)!
        if(web[i][0] as? String == (rectangle.subviews[0].subviews[0] as! UILabel).text){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                (rectangle.subviews[0].subviews[0] as! UILabel).text = self.web[i][1] as? String
                (rectangle.subviews[0].subviews[0] as! UILabel).layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            }
            UIView.animate(withDuration: 0.5, animations: {
                rectangle.subviews[0].layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            })
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                (rectangle.subviews[0].subviews[0] as! UILabel).text = self.web[i][0] as? String
                (rectangle.subviews[0].subviews[0] as! UILabel).layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
            }
            UIView.animate(withDuration: 0.5, animations: {
                rectangle.subviews[0].layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0)
            })
        }
        
//        let popupVC = WebTermEditorVC()
//        popupVC.delegate = self
//        popupVC.modalPresentationStyle = .overCurrentContext
//        popupVC.modalTransitionStyle = .crossDissolve
//        
//        let i = rectangles.firstIndex(of: gestureRecognizer.view!)!
//        currentEdit = i
//        popupVC.defField.text = web[i][1] as? String
//        popupVC.termField.text = web[i][0] as? String
//        popupVC.addingTerm = false
//        
//        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func handleBackgroundPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - translation.x, y: scrollView.contentOffset.y - translation.y)
        gestureRecognizer.setTranslation(.zero, in: view)
    }
    
//    func didAddTerm(data: [Any]){
//        if(currentEdit == -1){
//            let rectWidth: CGFloat = 180
//            let rectHeight: CGFloat = 180
//            
//            let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
//            let centerY = scrollView.contentOffset.y + scrollView.bounds.height / 2
//            
//            let newX = centerX - rectWidth / 2
//            let newY = centerY - rectHeight / 2
//            
//            let rectangle = UIView(frame: CGRect(x: newX, y: newY, width: rectWidth, height: rectHeight))
//            rectangle.backgroundColor = .clear
//            
//            let visible = UIView(frame: CGRect(x: 0, y: 30, width: rectWidth, height: rectHeight - 60))
//            visible.backgroundColor = Colors.secondaryBackground
//            visible.layer.cornerRadius = 10
//            rectangle.addSubview(visible)
//            
//            let topConnections = UIStackView()
//            let bottomConnections = UIStackView()
//            topConnections.axis = .horizontal
//            //topConnections.backgroundColor = .purple
//            topConnections.alignment = .fill
//            topConnections.distribution = .fillProportionally
//            topConnections.translatesAutoresizingMaskIntoConstraints = false
//            topConnections.isUserInteractionEnabled = true
//            topConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            topConnections.autoresizesSubviews = false
//            bottomConnections.axis = .horizontal
//            //bottomConnections.backgroundColor = .orange
//            bottomConnections.alignment = .fill
//            bottomConnections.distribution = .fillProportionally
//            bottomConnections.translatesAutoresizingMaskIntoConstraints = false
//            bottomConnections.isUserInteractionEnabled = true
//            bottomConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            bottomConnections.autoresizesSubviews = false
//            
//            let addConnection = UIButton()
//
//            addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//            addConnection.imageView?.tintColor = Colors.highlight
//            addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
//            //addConnection.backgroundColor = .red
//            addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
//            bottomConnections.addArrangedSubview(addConnection)
////            rectangle.addSubview(addConnection)
////            addConnection.frame = CGRect(x: rectangle.frame.width / 2 - 15, y: rectangle.frame.height, width: 30, height: 30)
//            addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            addConnection.translatesAutoresizingMaskIntoConstraints = false
//            addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
////            addConnection.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor).isActive = true
////            addConnection.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor).isActive = true
//            rectangle.addSubview(topConnections)
//            rectangle.addSubview(bottomConnections)
//            NSLayoutConstraint.activate([
//                topConnections.topAnchor.constraint(equalTo: rectangle.topAnchor),
//                topConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
//                bottomConnections.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor),
//                bottomConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor)
//            ])
//            
//            let termLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
//            termLabel.text = data[0] as? String
//            termLabel.textColor = Colors.text
//            termLabel.font = UIFont(name: "LilGrotesk-Normal", size: 15)
//            termLabel.textAlignment = .center
//            rectangle.addSubview(termLabel)
//            
//            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//            rectangle.addGestureRecognizer(panGesture)
//            
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editCard(_:)))
//            rectangle.addGestureRecognizer(tapGesture)
//            
//            scrollView.addSubview(rectangle)
//            rectangles.append(rectangle)
//            web.append([data[0], data[1], newX, newY, []])
//            web[web.count - 1][2] = newX
//            web[web.count - 1][3] = newY
//            
////            print(bottomConnections.frame)
////            print(addConnection.frame)
//            
//            save()
//        }else{
//            web[currentEdit] = [data[0], data[1], web[currentEdit][2], web[currentEdit][3], web[currentEdit][4]]
//            (rectangles[currentEdit].subviews[3] as! UILabel).text = data[0] as? String
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
//    @objc func newConnection(_ sender: UIButton){
//        //sender.backgroundColor = .red
//        if(rectangles.count > 1){
//            selectedButton = sender
//            
//            let index = rectangles.firstIndex(of: (sender.superview?.superview)!)
//            for (i, rectangle) in rectangles.enumerated() {
//                if(rectangle != sender.superview?.superview && !(web[index!][4] as! [Int]).contains(i)){
//                    sender.isEnabled = false
//                    let addConnection = UIButton()
//                    addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//                    
//                    addConnection.imageView?.tintColor = Colors.highlight
//                    addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
//                    addConnection.imageView!.layoutIfNeeded()
//                    addConnection.accessibilityIdentifier = String(index!)
//                    //addConnection.backgroundColor = .green
//                    addConnection.addTarget(self, action: #selector(finishConnection(_:)), for: .touchUpInside)
////                    addConnection.layoutIfNeeded()
//                    (rectangle.subviews[1] as! UIStackView).addArrangedSubview(addConnection)
//                    addConnection.translatesAutoresizingMaskIntoConstraints = false
//                    addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
//                    addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
//                    addedButtons.append(addConnection)
//                }
//            }
//            updateLines()
//        }
//        //print(addedButtons)
//        //print(addedButtons.count)
//    }
    
//    @objc func finishConnection(_ sender: UIButton){
//        //print(sender)
//        //print(sender.frame)
//        selectedButton?.setImage(nil, for: .normal)
//        selectedButton?.isEnabled = true
//        sender.setImage(nil, for: .normal)
//        sender.removeTarget(self, action: #selector(finishConnection(_:)), for: .touchUpInside)
//        sender.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
////        guard let senderSuperview = sender.superview?.superview,
////              let selectedSuperview = selectedButton?.superview?.superview else { return }
//        
//        let addConnection = UIButton()
//        addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//        addConnection.imageView?.tintColor = Colors.highlight
//        addConnection.imageView?.translatesAutoresizingMaskIntoConstraints = false
////        addConnection.accessibilityIdentifier = String((selectedButton?.superview as! UIStackView).arrangedSubviews.count)
//        //addConnection.backgroundColor = .blue
//        addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
//        (selectedButton?.superview as! UIStackView).addArrangedSubview(addConnection)
//        
//        addConnection.translatesAutoresizingMaskIntoConstraints = false
//        addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            
//        let endPoint = sender.convert(sender.anchorPoint, to: selectedButton)
//        //print(sender.center)
//        //print(endPoint)
//        let lineLayer = CAShapeLayer()
//        let linePath = UIBezierPath()
//        linePath.move(to: CGPoint(x: 15, y: 15))
//        linePath.addLine(to: CGPoint(x: endPoint.x + 15, y: endPoint.y + 15))
//        lineLayer.path = linePath.cgPath
//        lineLayer.strokeColor = Colors.text.cgColor
//        lineLayer.lineWidth = 2.0 // Adjust line width as needed
//        
//        selectedButton!.layer.addSublayer(lineLayer)
//        updateLines()
////        print(lineLayer)
////        print(selectedButton?.superview?.superview?.layer as Any)
////        print(linePath)
//        for _ in 0...addedButtons.count - 1 {
//            //print(addedButtons)
//            if(addedButtons[0] != sender){
//                //                (rectangle.subviews[0] as! UIStackView).removeArrangedSubview(addedButtons[0])
//                addedButtons[0].removeFromSuperview()
//            }
//            addedButtons.remove(at: 0)
//            updateLines()
//        }
//        let rectI = rectangles.firstIndex(of: (selectedButton?.superview?.superview)!)! as Int
//        let outI = rectangles.firstIndex(of: (sender.superview?.superview)!)! as Int
//        if var webArray = web[rectI][4] as? [Int] {
//            webArray.append(outI)
//            web[rectI][4] = webArray
//            updateLines()
//        }
//        
//        selectedButton?.removeTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
//        selectedButton?.addTarget(self, action: #selector(editConnection(_:)), for: .touchUpInside)
//        
//        updateLines()
//        
//        save()
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        //print(textField.text!)
//        name = textField.text!
//        
//        save()
//    }
    
//    @objc func editConnection(_ sender: UIButton){
//        
//    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
    
//    func deleteTerm() {
//        for i in (web[currentEdit][4] as! [Int]){
//            for button in (rectangles[i].subviews[1] as! UIStackView).arrangedSubviews { //Swift/ContiguousArrayBuffer.swift:600: Fatal error: Index out of range
//                if button.accessibilityIdentifier == String(currentEdit){
//                    button.removeFromSuperview()
//                }
//            }
//        }
//        rectangles[currentEdit].removeFromSuperview()
//        rectangles.remove(at: currentEdit)
//        web.remove(at: currentEdit)
//        for (i, term) in web.enumerated() {
//            if var indices = term[4] as? [Int], let index = indices.firstIndex(of: currentEdit) {
//                indices.remove(at: index)
//                for (j, I) in indices.enumerated() {
//                    if I > currentEdit{
//                        indices.remove(at: j)
//                    }
//                }
//                web[i][4] = indices // Update the original array with the modified one
//                (rectangles[i].subviews[2] as! UIStackView).arrangedSubviews[index].removeFromSuperview()
//            }
//        }
//        
//        for rectangle in rectangles {
//            for button in (rectangle.subviews[1] as! UIStackView).arrangedSubviews {
//                if(button.accessibilityIdentifier != nil && Int(button.accessibilityIdentifier!)! > currentEdit){
//                    button.accessibilityIdentifier = String(Int(button.accessibilityIdentifier!)! - 1)
//                }
//            }
//        }
//        
//        save()
//    }

}
