//
//  layout.swift
//  StudyApp
//
//  Created by Matthew Lundeen on 5/10/24.
//

import Foundation
import UIKit
import PencilKit

func con(_ sender: UIView, _ x: CGFloat, _ y: CGFloat){
    sender.widthAnchor.constraint(equalToConstant: x).isActive = true
    sender.heightAnchor.constraint(equalToConstant: y).isActive = true
}

func conW(_ sender: UIView, _ x: CGFloat){
    sender.widthAnchor.constraint(equalToConstant: x).isActive = true
}

func conH(_ sender: UIView, _ y: CGFloat){
    sender.heightAnchor.constraint(equalToConstant: y).isActive = true
}

func recolor(_ drawing: PKDrawing) -> PKDrawing {
    var newStrokes = [PKStroke]()
    for stroke in drawing.strokes {
        let newInk = PKInk(stroke.ink.inkType, color: Colors.text)
        let newStroke = PKStroke(ink: newInk, path: stroke.path, transform: stroke.transform, mask: stroke.mask)
        newStrokes.append(newStroke)
    }
    return PKDrawing(strokes: newStrokes)
}

func centerDrawing(_ canvasView: PKCanvasView) {
        let drawing = canvasView.drawing
        let boundingBox = calculateBoundingBox(for: drawing)
        
        guard !boundingBox.isNull else { return }
        
        let canvasSize = canvasView.bounds.size
        let offset = calculateOffsetToCenterBoundingBox(boundingBox, in: canvasSize)
        
        canvasView.contentOffset = offset
    }
    
    func calculateBoundingBox(for drawing: PKDrawing) -> CGRect {
        var boundingBox = CGRect.null
        
        for stroke in drawing.strokes {
            let path = stroke.path
            let step: CGFloat = 1.0
            
            for t in stride(from: 0, to: CGFloat(path.count), by: step) {
                let point = path.interpolatedLocation(at: t)
                let pointRect = CGRect(x: point.x, y: point.y, width: 1, height: 1)
                boundingBox = boundingBox.union(pointRect)
            }
        }
        
        return boundingBox
    }
    
    func calculateOffsetToCenterBoundingBox(_ boundingBox: CGRect, in canvasSize: CGSize) -> CGPoint {
        let centeredX = (canvasSize.width - boundingBox.width) / 2 - boundingBox.origin.x
        let centeredY = (canvasSize.height - boundingBox.height) / 2 - boundingBox.origin.y
        return CGPoint(x: centeredX, y: centeredY)
    }
	
func dateString() -> String {
        let currentDate = Date()
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        

        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"

        let monthString = monthFormatter.string(from: currentDate)
        let dayString = dayFormatter.string(from: currentDate)
        let yearString = yearFormatter.string(from: currentDate)
        
        let dayInt = Int(dayString) ?? 0
        let daySuffix: String
        switch dayInt {
        case 11, 12, 13:
            daySuffix = "th"
        default:
            switch dayInt % 10 {
            case 1:
                daySuffix = "st"
            case 2:
                daySuffix = "nd"
            case 3:
                daySuffix = "rd"
            default:
                daySuffix = "th"
            }
        }
        
        let formattedDate = "\(monthString) \(dayString)\(daySuffix), \(yearString)"
        
        return formattedDate
    }

func getImage(_ name: String) -> UIImage{
    if let image = UserDefaults.standard.value(forKey: name) as? Data{
        return UIImage(data: image)!
    }
    return UIImage(named: "color1.png")!
}

func setDrawing(_ name: String, _ canvas: PKCanvasView){
    if let drawing = UserDefaults.standard.value(forKey: name) as? Data{
        do {
            try canvas.drawing = recolor(PKDrawing(data: drawing))
        } catch {
            canvas.drawing = PKDrawing()
        }
    }else{
        canvas.drawing = PKDrawing()
    }
}

func generateRandomID(_ length: Int) -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let charactersArray = Array(characters)
    var randomID = ""

    for _ in 0..<length {
        let randomIndex = Int(arc4random_uniform(UInt32(charactersArray.count)))
        randomID.append(charactersArray[randomIndex])
    }

    return randomID
}

func getVersion() -> String {
    return "0.3"
}
