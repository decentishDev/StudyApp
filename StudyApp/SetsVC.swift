//
//  SetsVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 3/25/24.
//

import UIKit
import Foundation

class SetsVC: UIViewController, UIDocumentPickerDelegate {
    
    var name: String = "FirstName"
    var date: String = "1/2/3"
    var cards: [[Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(systemName: "xmark")?.pngData()
        cards = [["t","string", "t", "answer"], ["i", image as Any, "t", "yeahimage"], ["t", "term3", "t", "yeah"]]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func importCards(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func exportCards(_ sender: UIButton) {
        let cardsDictionary: [String: Any] = ["name": name, "date": date, "cards": cards]
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: cardsDictionary, requiringSecureCoding: false) else {
            print("Failed to archive data.")
            return
        }
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let timeString = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let fileURL = temporaryDirectoryURL.appendingPathComponent("examplename_" + timeString).appendingPathExtension("dlset")
        
        do {
            try data.write(to: fileURL)
            
            let documentPicker = UIDocumentPickerViewController(url: fileURL, in: .exportToService)
            documentPicker.shouldShowFileExtensions = true
            self.present(documentPicker, animated: true, completion: nil)
        } catch {
            print("Error exporting cards: \(error.localizedDescription)")
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            print("no file selected")
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            if let decodedCards = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] {
                if let importedName = decodedCards["name"] as? String {
                    name = importedName
                }
                if let importedDate = decodedCards["date"] as? String{
                    date = importedDate
                }
                if let importedCards = decodedCards["cards"] as? [[Any]] {
                    cards = importedCards
                }
                print("cards imported successfully")
                print(name)
                print(date)
                print(cards)
            }else{
                print("failed to decode cards file")
            }
        } catch {
            print("Error importing cards: \(error.localizedDescription)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
    @IBAction func PlaceholderStandardSetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "viewStandardSet", sender: self)
    }
    
    @IBAction func PlaceholderWebSetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "viewWebSet", sender: self)
    }
    
}
