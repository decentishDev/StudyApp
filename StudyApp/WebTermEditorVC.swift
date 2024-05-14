import UIKit

protocol EditorDelegate: AnyObject {
    func didAddTerm(data: [Any])
    func deleteTerm()
}

class WebTermEditorVC: UIViewController {
    
    var termField = UITextField()
    var defField = UITextField()
    var addingTerm = true
    
    weak var delegate: EditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set preferred content size
        self.definesPresentationContext = true
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 320))
        if !addingTerm {
            centeredView.frame = CGRect(x: 0, y: 0, width: 500, height: 390)
        }
        view.addSubview(centeredView)
        centeredView.center = view.center
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
//        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(cancelTap(_:))))
        
        centeredView.backgroundColor = Colors.background
        centeredView.layer.cornerRadius = 20
        centeredView.addSubview(termField)
//        centeredView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(backgroundTap(_:))))
        termField.placeholder = "Term"
        termField.textAlignment = .center
        termField.backgroundColor = Colors.secondaryBackground
        termField.layer.cornerRadius = 5
        termField.frame = CGRect(x: 50, y: 50, width: 400, height: 50)
        
        centeredView.addSubview(defField)
        defField.placeholder = "Definition"
        defField.textAlignment = .center
        defField.backgroundColor = Colors.secondaryBackground
        defField.layer.cornerRadius = 5
        defField.frame = CGRect(x: 50, y: 120, width: 400, height: 50)
        
        let cancelButton = UIButton(type: .system)
        centeredView.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Colors.text, for: .normal)
        cancelButton.backgroundColor = Colors.darkHighlight
        cancelButton.layer.cornerRadius = 5
        cancelButton.frame = CGRect(x: 50, y: 220, width: 190, height: 50)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        
        let confirmButton = UIButton(type: .system)
        centeredView.addSubview(confirmButton)
        if addingTerm {
            confirmButton.setTitle("Add Term", for: .normal)
        }else{
            confirmButton.setTitle("Update", for: .normal)
        }
        confirmButton.setTitleColor(Colors.text, for: .normal)
        confirmButton.backgroundColor = Colors.darkHighlight
        confirmButton.layer.cornerRadius = 5
        confirmButton.frame = CGRect(x: 260, y: 220, width: 190, height: 50)
        confirmButton.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
        if !addingTerm {
            let deleteButton = UIButton(type: .system)
            centeredView.addSubview(deleteButton)
            deleteButton.setTitle("Delete term", for: .normal)
            deleteButton.setTitleColor(Colors.text, for: .normal)
            deleteButton.backgroundColor = .init(red: 0.6, green: 0.3, blue: 0.3, alpha: 1)
            deleteButton.layer.cornerRadius = 5
            deleteButton.frame = CGRect(x: 50, y: 290, width: 400, height: 50)
            deleteButton.addTarget(self, action: #selector(deleteTerm(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.subviews[0].center = view.center
    }
    
    @objc func deleteTerm(_ sender: UIButton){
        delegate?.deleteTerm()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirm(_ sender: UIButton) {
        delegate?.didAddTerm(data: [termField.text ?? "", defField.text ?? "", 0, 0, []])
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backgroundTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        resignFirstResponder()
    }
}
