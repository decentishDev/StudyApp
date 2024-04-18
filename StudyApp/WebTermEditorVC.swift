//
//  WebTermEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/17/24.
//

import UIKit

protocol EditorDelegate: AnyObject {
    func didAddTerm(data: [Any])
}

class WebTermEditorVC: UIViewController {
    
    var termField = UITextField()
    var defField = UITextField()
    
    weak var delegate: EditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 140, height: 140)
        view.addSubview(termField)
        view.addSubview(defField)
        termField.frame = CGRect(x: 20, y: 20, width: 100, height: 20)
        defField.frame = CGRect(x: 20, y: 60, width: 100, height: 20)
        termField.backgroundColor = .red
        defField.backgroundColor = .orange
        
        let cancelButton = UIButton()
        view.addSubview(cancelButton)
        cancelButton.frame = CGRect(x: 20, y: 100, width: 40, height: 20)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Colors.highlight, for: .normal)
        cancelButton.backgroundColor = .yellow
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        
        let confirmButton = UIButton()
        view.addSubview(confirmButton)
        confirmButton.frame = CGRect(x: 80, y: 100, width: 40, height: 20)
        confirmButton.setTitle("Add term", for: .normal)
        confirmButton.setTitleColor(Colors.highlight, for: .normal)
        confirmButton.backgroundColor = .green
        confirmButton.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
    }
    
    @objc func cancel(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirm(_ sender: UIButton){
        delegate?.didAddTerm(data: [termField.text, defField.text, 0, 0, []])
        dismiss(animated: true, completion: nil)
    }
}
