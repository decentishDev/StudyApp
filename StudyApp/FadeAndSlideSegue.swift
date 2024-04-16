import UIKit

class FadeAndSlideSegue: UIStoryboardSegue {
    override func perform() {
        fadeSlide()
    }
    
    func fadeSlide(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { success in
            // Adjusting preferredContentSize
            toViewController.preferredContentSize = fromViewController.view.frame.size
            // Presenting with a full screen modal presentation style
            toViewController.modalPresentationStyle = .fullScreen
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}
