//
//  NewSetVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/11/24.
//

import UIKit
import Foundation
protocol NewSetDelegate: AnyObject {
    func newSetType(type: String)// "", "Web", "Standard", "Import424", "Search123"
    func newImport()
}
class NewSetVC: UIViewController, UIDocumentPickerDelegate {
    
    weak var delegate: NewSetDelegate?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: 560, height: 450))
        centeredView.backgroundColor = Colors.background
        centeredView.isUserInteractionEnabled = true
        view.addSubview(centeredView)
        centeredView.center = view.center
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
//        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(cancelTap(_:))))
        
        centeredView.backgroundColor = Colors.background
        centeredView.layer.cornerRadius = 20
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissIt(_:)))
        view.addGestureRecognizer(gesture)
        
        let newStandard = UIButton()
        newStandard.frame = CGRect(x: 30, y: 30, width: 500, height: 75)
        newStandard.backgroundColor = Colors.secondaryBackground
        newStandard.addTarget(self, action: #selector(newStandard(_:)), for: .touchUpInside)
        newStandard.layer.cornerRadius = 10
        centeredView.addSubview(newStandard)
        let standardIcon = UIImageView(image: UIImage(systemName: "plus.app.fill"))
        standardIcon.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        standardIcon.tintColor = Colors.highlight
        standardIcon.contentMode = .scaleAspectFit
        newStandard.addSubview(standardIcon)
        let standardText = UILabel(frame: CGRect(x: 75, y: 0, width: 410, height: 75))
        standardText.text = "Create new standard set"
        standardText.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        standardText.textColor = Colors.text
        newStandard.addSubview(standardText)
        
        let newWeb = UIButton()
        newWeb.frame = CGRect(x: 30, y: 135, width: 500, height: 75)
        newWeb.backgroundColor = Colors.secondaryBackground
        newWeb.addTarget(self, action: #selector(newWeb(_:)), for: .touchUpInside)
        newWeb.layer.cornerRadius = 10
        centeredView.addSubview(newWeb)
        let webIcon = UIImageView(image: UIImage(systemName: "plus.app.fill"))
        webIcon.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        webIcon.tintColor = Colors.highlight
        webIcon.contentMode = .scaleAspectFit
        newWeb.addSubview(webIcon)
        let webText = UILabel(frame: CGRect(x: 75, y: 0, width: 410, height: 75))
        webText.text = "Create new web set"
        webText.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        webText.textColor = Colors.text
        newWeb.addSubview(webText)
        
        let importButton = UIButton()
        importButton.frame = CGRect(x: 30, y: 240, width: 500, height: 75)
        importButton.backgroundColor = Colors.secondaryBackground
        importButton.addTarget(self, action: #selector(importSet(_:)), for: .touchUpInside)
        importButton.layer.cornerRadius = 10
        centeredView.addSubview(importButton)
        let importIcon = UIImageView(image: UIImage(systemName: "doc.badge.arrow.up.fill"))
        importIcon.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        importIcon.tintColor = Colors.highlight
        importIcon.contentMode = .scaleAspectFit
        importButton.addSubview(importIcon)
        let importText = UILabel(frame: CGRect(x: 75, y: 0, width: 410, height: 75))
        importText.text = "Import set"
        importText.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        importText.textColor = Colors.text
        importButton.addSubview(importText)
        
        let searchButton = UIButton()
        searchButton.frame = CGRect(x: 30, y: 345, width: 500, height: 75)
        searchButton.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.3)
        //searchButton.addTarget(self, action: #selector(searchForSet(_:)), for: .touchUpInside)
        searchButton.layer.cornerRadius = 10
        centeredView.addSubview(searchButton)
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        searchIcon.tintColor = Colors.darkHighlight
        searchIcon.contentMode = .scaleAspectFit
        searchButton.addSubview(searchIcon)
        let searchText = UILabel(frame: CGRect(x: 75, y: 0, width: 410, height: 75))
        searchText.text = "Search for sets"
        searchText.font = UIFont(name: "LilGrotesk-Regular", size: 30)
        searchText.textColor = Colors.secondaryBackground
        searchButton.addSubview(searchText)
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
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    @objc func searchForSet(_ sender: UIButton){
        
    }
    
    @objc func dismissIt(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            print("No file selected")
            return
        }
        
        do {
            if fileURL.pathExtension == "dlset" {
                let data = try Data(contentsOf: fileURL)
                if let decodedCards = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] {
                    
//                    if let image = decodedCards["image"] as? Data {
//                        var images = defaults.array(forKey: "images") as? [Data?] ?? []
//                        images.append(image)
//                        defaults.setValue(images, forKey: "images")
//                    }
                    if let version = decodedCards["version"] as? Int{
                        if(version == 0){
                            
                        }
                    }
                    
                        
                    var images = defaults.array(forKey: "images") as? [Data?] ?? []
                    images.append(Colors.placeholderI)
                    defaults.setValue(images, forKey: "images")
                    
                    var sets = defaults.array(forKey: "sets") as? [[String: Any]] ?? []
                    sets.append(decodedCards)
                    defaults.setValue(sets, forKey: "sets")
                    
                    
                    delegate?.newImport()
                    dismiss(animated: true, completion: nil)
                } else {
                    print("Failed to decode cards file")
                }
            }
        } catch {
            print("Error importing cards: \(error.localizedDescription)")
        }
    }

    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}
