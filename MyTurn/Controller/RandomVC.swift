//
//  RandomVC.swift
//  My Turn
//
//  Created by Jill Uhl on 1/7/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData

class RandomVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pickTurnBtn: RoundedCorners!
    
    var userArray: [User] = []

    let shapeLayer = CAShapeLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        
        userName.text = ""
  
        attemptFetch()
        
        //draw circle around userImage
        let center = userImage.center
        let radius = CGFloat(userImage.frame.width)
        print(radius)
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        //track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        
        //circle layer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)

        //slower rotation thru images
        if userArray.count > 0 {
        let shuffledUsers = userArray.shuffle()
        let imageArray = shuffledUsers.map { $0.photo }

        let slowImages = UIImage.animatedImage(with: imageArray as! [UIImage], duration: 4.0)
        userImage.image = slowImages
        }
    }

    @IBAction func pickButton(_ sender: UIButton) {
        
        userName.text = ""
        sender.isEnabled = false
       
        //animated circle and rotation thru images
        if userArray.count > 0 {

            //circular animation
            let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
            circleAnimation.toValue = 1
            circleAnimation.duration = 2.0
            circleAnimation.fillMode = .forwards
            circleAnimation.isRemovedOnCompletion = false
            shapeLayer.add(circleAnimation, forKey: "animate")
            
            let shuffledUsers = userArray.shuffle()
            let imageArray = shuffledUsers.map { $0.photo } as! [UIImage]
            
//            let fastImages = UIImage.animatedImage(with: imageArray, duration: 0.5)
//            userImage.image = fastImages
//            userImage.animationDuration = 1
            
            let selectedUser = shuffledUsers.randomItem()
            
            userImage.animationImages = imageArray
            userImage.animationDuration = 0.5
            userImage.animationRepeatCount = 0
            userImage.startAnimating()
            
            //stop animation in imageview and show selected user
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                self.userImage.layer.removeAllAnimations()
                
                UIView.transition(with: self.userImage, duration: 0.3, options: .transitionCrossDissolve, animations: { self.userImage.image = selectedUser?.photo as? UIImage }, completion: nil)
                //self.userImage.image = selectedUser?.photo as? UIImage
                self.userName.text = selectedUser?.name
                sender.isEnabled = true
            }
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let users = try context.fetch(fetchRequest)
            userArray = users
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
