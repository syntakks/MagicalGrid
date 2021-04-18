//
//  ViewController.swift
//  MagicalGrid
//
//  Created by Steve Wall on 4/17/21.
//

import UIKit

class ViewController: UIViewController {
    
    let rowCount = 30
    var cells = [String: UIView]()
    
    let animationScale: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrid()
    }

    /// This function sets up our grid with square views.
    func setupGrid() {
        // Calculate side length and column count.
        let width = view.frame.width / CGFloat(rowCount)
        let columnCount = Int(view.frame.height / width)
        // Add rows and columns of square views.
        for column in 0...columnCount {
            for row in 0...rowCount {
                // Setup Cell
                let cellView = UIView()
                cellView.backgroundColor = randomColor()
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                cellView.frame = CGRect(x: CGFloat(row) * width, y: CGFloat(column) * width, width: width, height: width)
                view.addSubview(cellView)
                // Add view to cells dictionary
                let key = keyForPosition(x: row, y: column)
                cells[key] = cellView
            }
        }
        // Add Gesture Recognizer
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    /// Returns a random UIColor
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    /// Returns dictionary key for cell view
    func keyForPosition(x: Int, y: Int) -> String {
        return "\(x)|\(y)"
    }
    
    // Property to track current previous cell
    var selectedCell: UIView?
    
    /// Handles pan gesture on cell view
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        // Pan Location
        let location = gesture.location(in: view)
        
        // Square View Width
        let width = view.frame.width / CGFloat(rowCount)
        
        // Get X/Y
        let x = Int(location.x / width)
        let y = Int(location.y / width)
        
        // Get Key
        let key = keyForPosition(x: x, y: y)
        
        // Get Cell
        guard let cellView = cells[key] else { return }
        
        // Scale down previous cell
        if selectedCell != cellView {
            if let selectedCell = self.selectedCell {
                scaleDown(cellView: selectedCell)
            }
        }
        
        // Set Current cell as selected
        self.selectedCell = cellView
        // Scale up current cell
        view.bringSubviewToFront(cellView)
        scaleUp(cellView: cellView)
        
        // Check for gesture end
        if gesture.state == .ended {
            scaleDown(cellView: cellView)
        }
        
    }
    
    /// Animation: Scales up a UIView
    func scaleUp(cellView: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cellView.layer.transform = CATransform3DMakeScale(self.animationScale, self.animationScale, self.animationScale)
        }, completion: nil)
    }
    
    /// Animation: Returns UIView scale to identity
    func scaleDown(cellView: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cellView.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    

}

