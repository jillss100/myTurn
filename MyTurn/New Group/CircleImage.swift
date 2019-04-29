//
//  CircleImage.swift
//  MyTurn
//
//  Created by Jill Uhl on 1/13/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.layer.borderWidth = 0.0
        self.clipsToBounds = true
    }

}
