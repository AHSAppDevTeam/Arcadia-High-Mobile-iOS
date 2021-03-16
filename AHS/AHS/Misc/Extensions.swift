//
//  Extensions.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

extension UIColor{
    static func rgb(_ r: Double, _ g: Double, _ b: Double) -> UIColor{
        return UIColor.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(1.0));
    }
}

class pageViewController: UIViewController{ // UIViewController for main pages
    public var pageName : String = "";
    public var secondaryPageName : String = "";
}
