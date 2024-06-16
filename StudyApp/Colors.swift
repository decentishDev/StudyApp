import UIKit
import PencilKit
struct Colors {
    static var background = UIColor(red: 0.110, green: 0.082, blue: 0.102, alpha: 1.0)
    static var secondaryBackground = UIColor(red: 0.220, green: 0.161, blue: 0.2, alpha: 1.0)
    static var darkHighlight = UIColor(red: 0.231, green: 0.322, blue: 0.286, alpha: 1.0)
    static var highlight = UIColor(red: 0.318, green: 0.596, blue: 0.447, alpha: 1.0)
    static var lightHighlight = UIColor(red: 0.643, green: 0.706, blue: 0.580, alpha: 1.0)
    static var text = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    
    
    static var green = UIColor(red: 0.318, green: 0.596, blue: 0.447, alpha: 1.0)
    static var pen = PKInkingTool(.pen, color: Colors.text, width: PKInkingTool.InkType.pen.defaultWidth)
    static var red = UIColor.init(red: 0.6, green: 0.3, blue: 0.3, alpha: 1)
    static let placeholderI = UIImage(named: "color1.png")?.pngData()
    
    
    static let themes : [[Any]] = [
        ["Dark",
         UIColor(red: 0.110, green: 0.082, blue: 0.102, alpha: 1.0),
         UIColor(red: 0.220, green: 0.161, blue: 0.2, alpha: 1.0),
         UIColor(red: 0.231, green: 0.322, blue: 0.286, alpha: 1.0),
         UIColor(red: 0.318, green: 0.596, blue: 0.447, alpha: 1.0),
         UIColor(red: 0.643, green: 0.706, blue: 0.580, alpha: 1.0),
         UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)],
        ["Light",
         UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0),
         UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0),
         UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.0),
         UIColor(red: 0.318, green: 0.596, blue: 0.447, alpha: 1.0),
         UIColor(red: 0.0, green: 0.75, blue: 0.5, alpha: 1.0),
         UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)],
        ["Blues and Orange",
         UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0),
         UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0),
         UIColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1.0),
         UIColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 1.0),
         UIColor(red: 0.9, green: 0.6, blue: 0.5, alpha: 1.0),
         UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)],
        ["Purples and Teal",
         UIColor(red: 0.15, green: 0.12, blue: 0.16, alpha: 1.0),
         UIColor(red: 0.25, green: 0.18, blue: 0.28, alpha: 1.0),
         UIColor(red: 0.22, green: 0.3, blue: 0.32, alpha: 1.0),
         UIColor(red: 0.34, green: 0.5, blue: 0.52, alpha: 1.0),
         UIColor(red: 0.6, green: 0.7, blue: 0.7, alpha: 1.0),
         UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)],
        ["Underwater Blues",
         UIColor(red: 0.05, green: 0.1, blue: 0.15, alpha: 1.0),
         UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0),
         UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 1.0),
         UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1.0),
         UIColor(red: 0.5, green: 0.7, blue: 0.8, alpha: 1.0),
         UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)],
        ["Arctic Frost",
         UIColor(red: 0.055, green: 0.102, blue: 0.204, alpha: 1.0),
         UIColor(red: 0.110, green: 0.220, blue: 0.408, alpha: 1.0),
         UIColor(red: 0.133, green: 0.286, blue: 0.545, alpha: 1.0),
         UIColor(red: 0.188, green: 0.447, blue: 0.761, alpha: 1.0),
         UIColor(red: 0.537, green: 0.580, blue: 0.706, alpha: 1.0),
         UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)]]
    
    static let version: Int = 1

}
