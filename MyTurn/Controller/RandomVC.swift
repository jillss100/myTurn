//
//  RandomVC.swift
//  My Turn
//
//  Created by Jill Uhl on 1/7/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class RandomVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pickTurnBtn: RoundedCorners!

    @IBOutlet var vcView: UIView!
    
    var sound: AVAudioPlayer?
    
    var userArray: [User] = []

    let shapeLayer = CAShapeLayer()
    let replicationLayer = CAReplicatorLayer()
    let replicationLayer2 = CAReplicatorLayer()
    
    let fireworkGreen = UIColor(red: 0/255, green: 128/255, blue: 86/255, alpha: 1.0)
    let fireworkBlue = UIColor(red: 0/255, green: 0/255, blue: 242/255, alpha: 1.0)
    let activityGreen = UIColor(red: 119/255, green: 204/255, blue: 41/255, alpha: 1.0)
    
    override func viewDidLayoutSubviews() {
        //draw circle around userImage
        let center = userImage.center
        let radius = CGFloat(userImage.frame.width) / 2
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        //track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        
        //circle layer
        shapeLayer.path = circularPath.cgPath
        //shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.strokeColor = activityGreen.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        attemptFetch()
        
        userName.text = ""
        
        if userArray.count == 0 {
            userImage.image = nil
        }
        
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
        
        //animated circle and rotation thru images
        if userArray.count > 0 {
                playSound()
            sender.isEnabled = false
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
            userImage.image = nil //trying, seems to work
            userImage.startAnimating()
            
            //stop animation in imageview and show selected user
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                self.userImage.layer.removeAllAnimations()
                
                UIView.transition(with: self.userImage, duration: 0.3, options: .transitionCrossDissolve, animations: { self.userImage.image = selectedUser?.photo as? UIImage }, completion: nil)
                //self.userImage.image = selectedUser?.photo as? UIImage
                self.userName.text = selectedUser?.name
            }
            
            //fireworks
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.view.layer.addSublayer(self.firework(at: CGPoint(x: 80, y: 140)))
            }
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                self.view.layer.addSublayer(self.firework2(at: CGPoint(x: self.view.center.x + 130, y: 160)))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
                self.replicationLayer.removeAllAnimations()
                self.replicationLayer.removeFromSuperlayer()
                self.replicationLayer2.removeFromSuperlayer()
                sender.isEnabled = true
            }
        } else {
            let dialogMessage = UIAlertController(title: "No Turn Takers", message: "Add Turn Takers to use Random Turn", preferredStyle: .alert)
            let go = UIAlertAction(title: "Go", style: .default, handler: { (ACTION) -> Void in
                self.tabBarController?.selectedIndex = 2
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            dialogMessage.addAction(go)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func firework(at atPoint: CGPoint) -> CAReplicatorLayer {
        
        replicationLayer.position = atPoint
        replicationLayer.instanceCount = 20
        replicationLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi/10), 0, 0, 1)
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: -20))
        linePath.addLine(to: CGPoint(x: 0, y: -60))
        
        let linePath2 = UIBezierPath()
        linePath2.move(to: CGPoint(x: 0, y: -35))
        linePath2.addLine(to: CGPoint(x: 0, y: -60))
        linePath2.apply(CGAffineTransform(rotationAngle: CGFloat(Double.pi/20)))

        let line = CAShapeLayer()
        line.path = linePath.cgPath
        //line.strokeColor = UIColor.cyan.cgColor
        line.strokeColor = activityGreen.cgColor
        line.strokeEnd = 0
        replicationLayer.addSublayer(line)

        let line2 = CAShapeLayer()
        line2.path = linePath2.cgPath
        line2.lineDashPattern = [20,2]
        //line2.strokeColor = UIColor.green.cgColor
        line2.strokeColor = activityGreen.cgColor
        line2.strokeEnd = 0
        replicationLayer.addSublayer(line2)
        
        self.view.layer.addSublayer(replicationLayer)
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = 1
        lineAnimation.duration = 0.75
        lineAnimation.fillMode = .forwards
        lineAnimation.autoreverses = true
        lineAnimation.repeatCount = 1
        lineAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        line.add(lineAnimation, forKey: "lineAnimate")
        line2.add(lineAnimation, forKey: "line2Animate")
        
        return replicationLayer
    }
    
    func firework2(at atPoint: CGPoint) -> CAReplicatorLayer {
        
        replicationLayer2.position = atPoint
        replicationLayer2.instanceCount = 20
        replicationLayer2.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi/10), 0, 0, 1)
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: -10))
        linePath.addLine(to: CGPoint(x: 0, y: -50))
        
        let linePath2 = UIBezierPath()
        linePath2.move(to: CGPoint(x: 0, y: -25))
        linePath2.addLine(to: CGPoint(x: 0, y: -50))
        linePath2.apply(CGAffineTransform(rotationAngle: CGFloat(Double.pi/20)))
        
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.strokeColor = activityGreen.cgColor
        line.strokeEnd = 0
        replicationLayer2.addSublayer(line)
        
        let line2 = CAShapeLayer()
        line2.path = linePath2.cgPath
        line2.lineDashPattern = [20,2]
        line2.strokeColor = activityGreen.cgColor
        line2.strokeEnd = 0
        replicationLayer2.addSublayer(line2)
        
        self.view.layer.addSublayer(replicationLayer2)
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = 1
        lineAnimation.duration = 0.75
        lineAnimation.fillMode = .forwards
        lineAnimation.autoreverses = true
        lineAnimation.repeatCount = 1
        lineAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        line.add(lineAnimation, forKey: "lineAnimate")
        line2.add(lineAnimation, forKey: "line2Animate")
        
        return replicationLayer2
    }
    
    func playSound() {
        guard let audioURL = Bundle.main.url(forResource: "drumRoll2", withExtension: "m4a" ) else { return }
        do {
            try sound = AVAudioPlayer(contentsOf: audioURL)
        } catch {
            print("drum roll sound error")
        }
        sound?.play()
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

