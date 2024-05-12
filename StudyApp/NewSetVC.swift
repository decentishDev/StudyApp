//
//  NewSetVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/11/24.
//

import UIKit
protocol NewSetDelegate: AnyObject {
    func newSetType(type: String)// "", "Web", "Standard", "Import424", "Search123"
}
class NewSetVC: UIViewController {
    
    weak var delegate: NewSetDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 500))
        centeredView.backgroundColor = Colors.background
        view.addSubview(centeredView)
        centeredView.center = view.center
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
//        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(cancelTap(_:))))
        
        centeredView.backgroundColor = Colors.background
        centeredView.layer.cornerRadius = 20
        
        let newStandard = UIButton()
        newStandard.frame = CGRect(x: 50, y: 50, width: 225, height: 100)
        newStandard.setTitle("Create new standard set", for: .normal)
        newStandard.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 30)
        newStandard.backgroundColor = Colors.secondaryBackground
        newStandard.titleLabel!.textColor = Colors.text
        newStandard.addTarget(self, action: #selector(newStandard(_:)), for: .touchUpInside)
        newStandard.layer.cornerRadius = 10
        centeredView.addSubview(newStandard)
        
        let newWeb = UIButton()
        newWeb.frame = CGRect(x: 325, y: 50, width: 225, height: 100)
        newWeb.setTitle("Create new web set", for: .normal)
        newWeb.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 30)
        newWeb.backgroundColor = Colors.secondaryBackground
        newWeb.titleLabel!.textColor = Colors.text
        newWeb.addTarget(self, action: #selector(newWeb(_:)), for: .touchUpInside)
        newWeb.layer.cornerRadius = 10
        centeredView.addSubview(newWeb)
        
        let importButton = UIButton()
        importButton.frame = CGRect(x: 50, y: 200, width: 500, height: 100)
        importButton.setTitle("Import set", for: .normal)
        importButton.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 30)
        importButton.backgroundColor = Colors.secondaryBackground
        importButton.titleLabel!.textColor = Colors.text
        importButton.addTarget(self, action: #selector(importSet(_:)), for: .touchUpInside)
        importButton.layer.cornerRadius = 10
        centeredView.addSubview(importButton)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: 50, y: 350, width: 500, height: 100)
        searchButton.setTitle("Search for sets", for: .normal)
        searchButton.titleLabel!.font = UIFont(name: "CabinetGroteskVariable-Bold_Regular", size: 30)
        searchButton.backgroundColor = Colors.secondaryBackground
        searchButton.titleLabel!.textColor = Colors.text
        searchButton.addTarget(self, action: #selector(searchForSet(_:)), for: .touchUpInside)
        searchButton.layer.cornerRadius = 10
        centeredView.addSubview(searchButton)
    }
    
    @objc func newStandard(_ sender: UIButton){
        delegate?.newSetType(type: "Standard")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newWeb(_ sender: UIButton){
        delegate?.newSetType(type: "Web")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func importSet(_ sender: UIButton){
        
    }
    
    @objc func searchForSet(_ sender: UIButton){
        
    }
}
