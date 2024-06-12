//
//  WebSetVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 4/13/24.
//

import UIKit

class WebSetVC: UIViewController {

    let defaults = UserDefaults.standard
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var set = 0 //No need to pass actual web with the content since we can't view it on this screen
    var goToEditor = false
    
    var name: String = ""
    var date: String = ""
    
    var image: Data? = Colors.placeholderI

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goToEditor {
            //UIView.setAnimationsEnabled(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.performSegue(withIdentifier: "editWebSet", sender: self)
            }
            //UIView.setAnimationsEnabled(true)
        }
        
        //cards = data["set"] as! [[Any]]
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func setup(){
        let sets = defaults.value(forKey: "sets") as! [Dictionary<String, Any>]
        if(sets.count == set){
            performSegue(withIdentifier: "webSetVC_unwind", sender: nil)
        }else{
            let data = sets[set]
            if(name != "" && (name != data["name"] as! String)){
                performSegue(withIdentifier: "webSetVC_unwind", sender: nil)
            }
            name = data["name"] as! String
            date = data["date"] as! String
            image = (defaults.value(forKey: "images") as! [Data?])[set]
            
            for subview in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            stackView.removeFromSuperview()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            if(image == Colors.placeholderI){
                view.backgroundColor = Colors.background
            }else{
                let backgroundImage = UIImageView(image: UIImage(data: image!))
                backgroundImage.contentMode = .scaleAspectFill
                view.addSubview(backgroundImage)
                backgroundImage.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                    backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
            }
            stackView.axis = .vertical
            stackView.spacing = 0
            stackView.alignment = .leading
            scrollView.addSubview(stackView)
            view.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50),
                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -100)
            ])
            
            let backButton = UIButton()
            backButton.setTitle("< Back", for: .normal)
            backButton.titleLabel!.font = UIFont(name: "LilGrotesk-Bold", size: 20)
            backButton.addTarget(self, action: #selector(self.backButton(sender:)), for: .touchUpInside)
            backButton.setTitleColor(Colors.highlight, for: .normal)
            stackView.addArrangedSubview(backButton)
            
            let breakView0 = UIView()
            breakView0.widthAnchor.constraint(equalToConstant: 15).isActive = true
            breakView0.heightAnchor.constraint(equalToConstant: 15).isActive = true
            stackView.addArrangedSubview(breakView0)
            
            let titleLabel = UILabel()
            titleLabel.text = name
            titleLabel.font = UIFont(name: "LilGrotesk-Black", size: 50)
            titleLabel.textColor = Colors.text
            titleLabel.sizeToFit()
            stackView.addArrangedSubview(titleLabel)
            
            let dateLabel = UILabel()
            dateLabel.text = date
            dateLabel.font = UIFont(name: "LilGrotesk-Light", size: 20)
            dateLabel.textColor = Colors.text
            dateLabel.sizeToFit()
            stackView.addArrangedSubview(dateLabel)
            
            let breakView5 = UIView()
            breakView5.widthAnchor.constraint(equalToConstant: 30).isActive = true
            breakView5.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(breakView5)
            
            let shareButton = UIButton()
            con(shareButton, 200, 30)
            shareButton.addTarget(self, action: #selector(self.export(sender:)), for: .touchUpInside)
            shareButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(shareButton)
            let shareIcon = UIImageView()
            shareIcon.translatesAutoresizingMaskIntoConstraints = false
            con(shareIcon, 30, 30)
            shareButton.addSubview(shareIcon)
            shareIcon.image = UIImage(systemName: "arrow.down.square.fill")
            shareIcon.leadingAnchor.constraint(equalTo: shareButton.leadingAnchor).isActive = true
            shareIcon.tintColor = Colors.highlight
            shareIcon.contentMode = .scaleAspectFit
            let shareText = UILabel()
            shareText.translatesAutoresizingMaskIntoConstraints = false
            shareButton.addSubview(shareText)
            conH(shareText, 30)
            shareText.leadingAnchor.constraint(equalTo: shareIcon.trailingAnchor, constant: 10).isActive = true
            shareText.trailingAnchor.constraint(equalTo: shareButton.trailingAnchor).isActive = true
            shareText.text = "Download"
            shareText.font = UIFont(name: "LilGrotesk-Regular", size: 20)
            shareText.textColor = Colors.highlight
            
            let breakView1 = UIView()
            breakView1.widthAnchor.constraint(equalToConstant: 30).isActive = true
            breakView1.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(breakView1)
            
            let viewButton = createButton(withTitle: "View")
            let studyButton = createButton(withTitle: "Study")
            let editButton = createButton(withTitle: "Edit")
            let spacer = UIView()
            
            let buttonsStackView = UIStackView(arrangedSubviews: [viewButton, studyButton, editButton, spacer])
            buttonsStackView.axis = .horizontal
            buttonsStackView.widthAnchor.constraint(equalToConstant: 400).isActive = true
            buttonsStackView.spacing = 20
            buttonsStackView.distribution = .fill
            stackView.addArrangedSubview(buttonsStackView)
        }
//        let icon = UIImageView(image: UIImage(named: "DendriticLearningIcon-01.svg")?.withRenderingMode(.alwaysTemplate))
//        icon.tintColor = Colors.highlight
//        icon.contentMode = .scaleAspectFit
//        view.addSubview(icon)
//        icon.frame = CGRect(x: view.frame.width / 2.5, y: view.frame.height / 2.5, width: max(view.frame.width, view.frame.height), height: max(view.frame.width, view.frame.height))
//        icon.transform = icon.transform.rotated(by: -(.pi / 8))
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel!.font = UIFont(name: "LilGrotesk-Bold", size: 30)
        button.setTitleColor(Colors.text, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        conW(button, (title as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "LilGrotesk-Bold", size: 30)!]).width + 40)
        button.layer.masksToBounds = true

        if(image == Colors.placeholderI){
            button.backgroundColor = Colors.secondaryBackground
        }else{
            var blurEffect = UIBlurEffect(style: .systemThinMaterial)
            if(Colors.text == UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)){
                blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
            }else if(Colors.text == UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)){
                blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
            }
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = button.bounds
            blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurredEffectView.isUserInteractionEnabled = false
            button.insertSubview(blurredEffectView, at: 0)
        }

        return button
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "View":
            viewWeb()
        case "Study":
            studyWeb()
        case "Edit":
            editWeb()
        default:
            break
        }
    }

    @objc func viewWeb() {
        performSegue(withIdentifier: "webViewer", sender: self)
    }

    @objc func studyWeb() {
        performSegue(withIdentifier: "webStudy", sender: self)
    }

    @objc func editWeb() {
        performSegue(withIdentifier: "editWebSet", sender: self)
    }
    
    @objc func backButton(sender: UIButton){
        performSegue(withIdentifier: "webSetVC_unwind", sender: nil)
    }
    
    @objc func export(sender: UIButton){
        var cardsDictionary: [String: Any] = (defaults.object(forKey: "sets") as! [Dictionary<String, Any>])[set]
        //cardsDictionary["images"] = (defaults.object(forKey: "images") as! [Data?])[set]
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: cardsDictionary, requiringSecureCoding: false) else {
            print("Failed to archive data.")
            return
        }
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let timeString = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(name).appendingPathExtension("dlset")
        
        do {
            try data.write(to: fileURL)
            
            let documentPicker = UIDocumentPickerViewController(url: fileURL, in: .exportToService)
            documentPicker.shouldShowFileExtensions = true
            self.present(documentPicker, animated: true, completion: nil)
        } catch {
            print("Error exporting cards: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if let destination = segue.destination as? WebEditorVC{
            destination.set = set
        }
        if let destination = segue.destination as? WebStudyVC{
            destination.set = set
        }
        if let destination = segue.destination as? WebViewerVC{
            destination.set = set
        }
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue){
        
    }
}
