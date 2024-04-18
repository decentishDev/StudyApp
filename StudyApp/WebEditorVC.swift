//
//  WebEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/16/24.
//

import UIKit

class WebEditorVC: UIViewController, UIScrollViewDelegate, EditorDelegate {
    
    var rectangles: [UIView] = []
    var scrollView: UIScrollView!
    var addButton: UIButton!
    var web: [[Any]] = []
    var currentEdit: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        addButton = UIButton(type: .system)
        addButton.setTitle("Add term", for: .normal)
        addButton.setTitleColor(Colors.highlight, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "CabinetGroteskVariable-Bold_Normal", size: 15)
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        addButton.frame = CGRect(x: 20, y: 20, width: 120, height: 40)
        
        view.addSubview(addButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackgroundPan(_:)))
        scrollView.addGestureRecognizer(panGesture)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "editWebTerm", sender: nil)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        guard let view = gestureRecognizer.view else { return }
        
        if view != addButton {
            let newX = view.center.x + translation.x
            let newY = view.center.y + translation.y
            view.center = CGPoint(x: newX, y: newY)
        } else {
            let newX = addButton.center.x + translation.x
            let newY = addButton.center.y + translation.y
            addButton.center = CGPoint(x: newX, y: newY)
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - translation.x, y: scrollView.contentOffset.y - translation.y)
        }
        
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
        let rectWidth: CGFloat = 175
        let rectHeight: CGFloat = 125
        
        let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        let centerY = scrollView.contentOffset.y + scrollView.bounds.height / 2
        
        let newX = centerX - rectWidth / 2
        let newY = centerY - rectHeight / 2
        
        let rectangle = UIView(frame: CGRect(x: newX, y: newY, width: rectWidth, height: rectHeight))
        rectangle.backgroundColor = Colors.secondaryBackground
        rectangle.layer.cornerRadius = 10
        
        let termLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 125))
        termLabel.text = data[0] as? String
        termLabel.textColor = Colors.text
        termLabel.font = UIFont(name: "CabinetGroteskVariable-Bold_Normal", size: 15)
        rectangle.addSubview(termLabel)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        rectangle.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        rectangle.addGestureRecognizer(tapGesture)
        
        scrollView.addSubview(rectangle)
        rectangles.append(rectangle)
        
        web.append(data)
        web[web.count - 1][2] = newX
        web[web.count - 1][3] = newY
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWebTerm" {
            if let popupVC = segue.destination as? WebTermEditorVC {
                popupVC.delegate = self
                popupVC.preferredContentSize = CGSize(width: 140, height: 140)
                segue.destination.presentedViewController?.preferredContentSize = CGSize(width: 140, height: 140)
            }
        }
    }
}
