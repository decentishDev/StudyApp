//
//  DrawingEditorVC.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/19/24.
//

import UIKit
import PencilKit
protocol DrawingEditorDelegate: AnyObject {
    func updateDrawing()
}
class DrawingEditorVC: UIViewController, PKCanvasViewDelegate {
    weak var delegate: DrawingEditorDelegate?
    var set = 0
    var i = 0
    var term = true
    let canvas = PKCanvasView()
    var usingEraser = false
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: (view.frame.width - 161), height: 2*(view.frame.width - 161)/3))
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
        
        canvas.frame = CGRect(x: 0, y: 0, width: centeredView.frame.width, height: centeredView.frame.height)
        canvas.layer.cornerRadius = 10
        canvas.clipsToBounds = true
        canvas.backgroundColor = Colors.background
        canvas.tool = Colors.pen
        canvas.overrideUserInterfaceStyle = .light
        canvas.allowsFingerDrawing = defaults.value(forKey: "fingerDrawing") as! Bool
        
        let card = ((UserDefaults.standard.value(forKey: "sets") as! [Dictionary<String, Any>])[set]["set"] as! [[Any]])

        if(term){
            do {
                try canvas.drawing = recolor(PKDrawing(data: card[i][1] as! Data))
            } catch {
                
            }
                
        }else{
            do {
                try canvas.drawing = recolor(PKDrawing(data: card[i][3] as! Data))
            } catch {
                
            }
        }
        canvas.delegate = self
        centeredView.addSubview(canvas)
        
        let doneButton = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        doneButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        doneButton.contentMode = .scaleAspectFit
        doneButton.tintColor = Colors.highlight
        doneButton.backgroundColor = Colors.secondaryBackground
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        centeredView.addSubview(doneButton)
        let clearButton = UIButton(frame: CGRect(x: 70, y: 10, width: 50, height: 50))
        clearButton.setImage(UIImage(systemName: "arrow.circlepath"), for: .normal)
        clearButton.contentMode = .scaleAspectFit
        clearButton.tintColor = Colors.highlight
        clearButton.backgroundColor = Colors.secondaryBackground
        clearButton.layer.cornerRadius = 10
        clearButton.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        centeredView.addSubview(clearButton)
        let eraserButton = UIButton(frame: CGRect(x: 130, y: 10, width: 50, height: 50))
        eraserButton.setImage(UIImage(systemName: "eraser.fill"), for: .normal)
        eraserButton.contentMode = .scaleAspectFit
        eraserButton.tintColor = Colors.highlight
        eraserButton.backgroundColor = Colors.secondaryBackground
        eraserButton.layer.cornerRadius = 10
        eraserButton.addTarget(self, action: #selector(eraser(_:)), for: .touchUpInside)
        centeredView.addSubview(eraserButton)
    }
    
    @objc func dismissIt(_ sender: UITapGestureRecognizer){
        delegate?.updateDrawing()
        dismiss(animated: true, completion: nil)
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        var card = ((UserDefaults.standard.value(forKey: "sets") as! [Dictionary<String, Any>])[set]["set"] as! [[Any]])
        if(term){
            card[i][1] = canvasView.drawing.dataRepresentation()
        }else{
            card[i][3] = canvasView.drawing.dataRepresentation()
        }
        var originalset = (UserDefaults.standard.value(forKey: "sets") as! [Dictionary<String, Any>])[set]
        originalset["set"] = card
        var allsets = UserDefaults.standard.value(forKey: "sets") as! [Dictionary<String, Any>]
        allsets[set] = originalset
        UserDefaults.standard.setValue(allsets, forKey: "sets")
    }
    
    @objc func back(_ sender: UIButton) {
        delegate?.updateDrawing()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func eraser(_ sender: UIButton) {
        if(usingEraser){
            sender.setImage(UIImage(systemName: "eraser.fill"), for: .normal)
            canvas.tool = PKInkingTool(.pen, color: Colors.text, width: PKInkingTool.InkType.pen.defaultWidth)
        }else{
            sender.setImage(UIImage(systemName: "pencil"), for: .normal)
            canvas.tool = PKEraserTool(.vector)
        }
        usingEraser = !usingEraser
    }
    
    @objc func clear(_ sender: UIButton) {
        canvas.drawing = recolor(PKDrawing())
    }
}
