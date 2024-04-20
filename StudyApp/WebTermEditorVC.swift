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
        
        // Set preferred content size
//        preferredContentSize = CGSize(width: 600, height: 600)
        
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        termField.placeholder = "Term"
        termField.textAlignment = .center
        termField.backgroundColor = Colors.secondaryBackground
        termField.layer.cornerRadius = 5
        termField.frame = CGRect(x: 20, y: 40, width: 260, height: 40)
        view.addSubview(termField)
        
        defField.placeholder = "Definition"
        defField.textAlignment = .center
        defField.backgroundColor = Colors.secondaryBackground
        defField.layer.cornerRadius = 5
        defField.frame = CGRect(x: 20, y: 100, width: 260, height: 40)
        view.addSubview(defField)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Colors.text, for: .normal)
        cancelButton.backgroundColor = Colors.darkHighlight
        cancelButton.layer.cornerRadius = 5
        cancelButton.frame = CGRect(x: 20, y: 160, width: 120, height: 40)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Add Term", for: .normal)
        confirmButton.setTitleColor(Colors.text, for: .normal)
        confirmButton.backgroundColor = Colors.darkHighlight
        confirmButton.layer.cornerRadius = 5
        confirmButton.frame = CGRect(x: 160, y: 160, width: 120, height: 40)
        confirmButton.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
        view.addSubview(confirmButton)
    }
    
    @objc func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirm(_ sender: UIButton) {
        delegate?.didAddTerm(data: [termField.text ?? "", defField.text ?? "", 0, 0, []])
        dismiss(animated: true, completion: nil)
    }
}
