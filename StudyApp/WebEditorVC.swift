//
//  WebEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/16/24.
//

import UIKit

class WebEditorVC: UIViewController, UIScrollViewDelegate {
    
    var rectangles = [UIView]()
    var scrollView: UIScrollView!
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        addButton = UIButton(type: .system)
        addButton.setTitle("Add term", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        addButton.frame = CGRect(x: 20, y: 20, width: 120, height: 40)
        
        view.addSubview(addButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackgroundPan(_:)))
        scrollView.addGestureRecognizer(panGesture)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let rectWidth: CGFloat = 100
        let rectHeight: CGFloat = 100
        
        let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        let centerY = scrollView.contentOffset.y + scrollView.bounds.height / 2
        
        let randomX = centerX - rectWidth / 2
        let randomY = centerY - rectHeight / 2
        
        let rectangle = UIView(frame: CGRect(x: randomX, y: randomY, width: rectWidth, height: rectHeight))
        rectangle.backgroundColor = .blue
        rectangle.layer.borderWidth = 1
        rectangle.layer.borderColor = UIColor.black.cgColor
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        rectangle.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        rectangle.addGestureRecognizer(tapGesture)
        
        scrollView.addSubview(rectangle)
        rectangles.append(rectangle)
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
        rectangle.backgroundColor = .red
    }
    
    @objc func handleBackgroundPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - translation.x, y: scrollView.contentOffset.y - translation.y)
        gestureRecognizer.setTranslation(.zero, in: view)
    }
}
