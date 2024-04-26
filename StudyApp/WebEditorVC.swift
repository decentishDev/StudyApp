//
//  WebEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/16/24.
//

import UIKit

class WebEditorVC: UIViewController, UIScrollViewDelegate, EditorDelegate, UITextFieldDelegate {
    
    var name = "Revolutionary War"
    var rectangles: [UIView] = []
    var scrollView: UIScrollView!
    var web: [[Any]] = []
    var currentEdit: Int = -1
    var selectedButton: UIButton? = nil
    var addedButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        
        view.addSubview(scrollView)
        
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "arrowshape.backward.fill"), for: .normal)
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        backButton.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        backButton.backgroundColor = Colors.secondaryBackground
        backButton.layer.cornerRadius = 10
        backButton.tintColor = Colors.highlight
        
        view.addSubview(backButton)
        
        let titleField = UITextField()
        titleField.delegate = self
        titleField.text = name
        titleField.placeholder = "Set name"
        titleField.frame = CGRect(x: 90, y: 30, width: 350, height: 50)
        titleField.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 25)
        titleField.textColor = Colors.highlight
        titleField.backgroundColor = Colors.secondaryBackground
        titleField.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, titleField.frame.height))
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        
        view.addSubview(titleField)
        
        let addButton = UIButton()
//        addButton = UIButton(type: .custom)
        addButton.setTitle("+ Add term", for: .normal)
        addButton.setTitleColor(Colors.highlight, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 25)
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        addButton.frame = CGRect(x: view.frame.width - 300, y: 30, width: 150, height: 50)
        addButton.backgroundColor = Colors.secondaryBackground
        addButton.layer.cornerRadius = 10
        
        view.addSubview(addButton)
        
        let themesButton = UIButton()
//        addButton = UIButton(type: .custom)
        themesButton.setTitle("Themes", for: .normal)
        themesButton.setTitleColor(Colors.highlight, for: .normal)
        themesButton.titleLabel?.font = UIFont(name: "CabinetGroteskVariable-Bold_Bold", size: 25)
        themesButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        themesButton.frame = CGRect(x: view.frame.width - 140, y: 30, width: 110, height: 50)
        themesButton.backgroundColor = Colors.secondaryBackground
        themesButton.layer.cornerRadius = 10
        
        view.addSubview(themesButton)
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackgroundPan(_:)))
        scrollView.addGestureRecognizer(panGesture)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let popupVC = WebTermEditorVC()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
        
    }
    
    @objc func back(_ sender: UIButton) {
        performSegue(withIdentifier: "webEditorVC_unwind", sender: nil)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        guard let view = gestureRecognizer.view else { return }
        
//        if view != addButton {
            let newX = view.center.x + translation.x
            let newY = view.center.y + translation.y
            view.center = CGPoint(x: newX, y: newY)
//        } else {
//            print("yeah")
//            let newX = addButton.center.x + translation.x
//            let newY = addButton.center.y + translation.y
//            addButton.center = CGPoint(x: newX, y: newY)
//            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - translation.x, y: scrollView.contentOffset.y - translation.y)
//        }
//        
        gestureRecognizer.setTranslation(.zero, in: view)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let rectangle = gestureRecognizer.view else { return }
        rectangle.backgroundColor = Colors.darkHighlight
    }
    
    @objc func handleBackgroundPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - translation.x, y: scrollView.contentOffset.y - translation.y)
        gestureRecognizer.setTranslation(.zero, in: view)
    }
    
    func didAddTerm(data: [Any]){
        if(currentEdit == -1){
            let rectWidth: CGFloat = 180
            let rectHeight: CGFloat = 120
            
            let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
            let centerY = scrollView.contentOffset.y + scrollView.bounds.height / 2
            
            let newX = centerX - rectWidth / 2
            let newY = centerY - rectHeight / 2
            
            let rectangle = UIView(frame: CGRect(x: newX, y: newY, width: rectWidth, height: rectHeight))
            rectangle.backgroundColor = Colors.secondaryBackground
            rectangle.layer.cornerRadius = 10
            
            let topConnections = UIStackView()
            let bottomConnections = UIStackView()
            topConnections.axis = .horizontal
            //topConnections.backgroundColor = .red
            topConnections.alignment = .fill
            topConnections.distribution = .fillProportionally
            topConnections.translatesAutoresizingMaskIntoConstraints = false
            topConnections.isUserInteractionEnabled = true
            topConnections.heightAnchor.constraint(equalToConstant: 30).isActive = true
            topConnections.widthAnchor.constraint(equalToConstant: 30).isActive = true
            bottomConnections.axis = .horizontal
            //bottomConnections.backgroundColor = .green
            bottomConnections.alignment = .fill
            bottomConnections.distribution = .fillProportionally
            bottomConnections.translatesAutoresizingMaskIntoConstraints = false
            bottomConnections.isUserInteractionEnabled = true
            bottomConnections.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let addConnection = UIButton()


            addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            //addConnection.backgroundColor = .blue
            addConnection.addTarget(self, action: #selector(newConnection(_:)), for: .touchUpInside)
            bottomConnections.addArrangedSubview(addConnection)
//            rectangle.addSubview(addConnection)
//            addConnection.frame = CGRect(x: rectangle.frame.width / 2 - 15, y: rectangle.frame.height, width: 30, height: 30)
            addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
            addConnection.translatesAutoresizingMaskIntoConstraints = false
            addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
//            addConnection.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor).isActive = true
//            addConnection.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor).isActive = true
            rectangle.addSubview(topConnections)
            rectangle.addSubview(bottomConnections)
            NSLayoutConstraint.activate([
                topConnections.topAnchor.constraint(equalTo: rectangle.topAnchor),
                topConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
                bottomConnections.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor),
                bottomConnections.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor)
            ])
            
            let termLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 125))
            termLabel.text = data[0] as? String
            termLabel.textColor = Colors.text
            termLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Normal", size: 15)
            termLabel.textAlignment = .center
            rectangle.addSubview(termLabel)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            rectangle.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            rectangle.addGestureRecognizer(tapGesture)
            
            scrollView.addSubview(rectangle)
            rectangles.append(rectangle)
            web.append([data[0], data[1], newX, newY, []])
            web[web.count - 1][2] = newX
            web[web.count - 1][3] = newY
            
//            print(bottomConnections.frame)
//            print(addConnection.frame)
        }else{
            web[currentEdit] = [data[0], data[1], web[currentEdit][2], web[currentEdit][3], web[currentEdit][4]]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editWebTerm" {
//            if let popupVC = segue.destination as? WebTermEditorVC {
//                popupVC.delegate = self
//                popupVC.preferredContentSize = CGSize(width: 140, height: 140)
//                segue.destination.presentedViewController?.preferredContentSize = CGSize(width: 140, height: 140)
//            }
//        }
        
//        if let popupVC = segue.destination as? WebTermEditorVC {
//            popupVC.delegate = self
//            popupVC.modalPresentationStyle = .popover
//            popupVC.preferredContentSize = CGSize(width: 600, height: 800)
//        }
    }
    
    @objc func newConnection(_ sender: UIButton){
        //sender.backgroundColor = .red
        print("hi")
        selectedButton = sender
        sender.isEnabled = false
        for rectangle in rectangles {
            if(rectangle != sender.superview?.superview){
                let addConnection = UIButton()
                addConnection.widthAnchor.constraint(equalToConstant: 30).isActive = true
                addConnection.heightAnchor.constraint(equalToConstant: 30).isActive = true
                addConnection.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                //addConnection.backgroundColor = .blue
                addConnection.addTarget(self, action: #selector(finishConnection(_:)), for: .touchUpInside)
                (rectangle.subviews[0] as! UIStackView).addArrangedSubview(addConnection)
                addedButtons.append(addConnection)
            }
        }
    }
    
    @objc func finishConnection(_ sender: UIButton){
        
        selectedButton?.setImage(nil, for: .normal)
        selectedButton?.isEnabled = true
        sender.setImage(nil, for: .normal)
        
        let lineLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 90, y: 120))
        linePath.addLine(to: CGPoint(x: sender.center.x - selectedButton!.center.x, y: selectedButton!.center.y - sender.center.y))
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = Colors.text.cgColor
        lineLayer.lineWidth = 10.0
        selectedButton?.superview?.superview?.layer.addSublayer(lineLayer)
        print(lineLayer)
        print(selectedButton?.superview?.superview?.layer as Any)
        print(linePath)
        for rectangle in rectangles {
            if(rectangle != sender.superview?.superview){
                (rectangle.subviews[0] as! UIStackView).removeArrangedSubview(addedButtons[0])
                addedButtons.remove(at: 0)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
    
}
