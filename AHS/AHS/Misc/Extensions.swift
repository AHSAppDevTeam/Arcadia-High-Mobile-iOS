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
    
    convenience init(hex: String, alpha: CGFloat = 1.0){
        
        var hex_copy = hex;
        let count = hex.count;
        
        if (count != 6 && count != 7){
            self.init(red: 0, green: 0, blue: 0, alpha: 0);
            return;
        }
        
        if (count == 7){
            hex_copy.removeFirst();
        }
        
        // FFFFFF - FF FF FF
        
        let r_s : String = "\(hex_copy[0])\(hex_copy[1])";
        let g_s : String = "\(hex_copy[2])\(hex_copy[3])";
        let b_s : String = "\(hex_copy[4])\(hex_copy[5])";
        
        //print("hex - \(r_s)\(g_s)\(b_s)")
        
        guard let r = UInt8(r_s, radix: 16) else{
            self.init(red: 0, green: 0, blue: 0, alpha: 0);
            return;
        }
        
        guard let g = UInt8(g_s, radix: 16) else{
            self.init(red: 0, green: 0, blue: 0, alpha: 0);
            return;
        }
        
        guard let b = UInt8(b_s, radix: 16) else{
            self.init(red: 0, green: 0, blue: 0, alpha: 0);
            return;
        }
        
        self.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: alpha);
        
    }
    
    // https://stackoverflow.com/a/61776608/
    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor {
                switch $0.userInterfaceStyle {
                case .dark:
                    return dark
                default:
                    return light
                }
            }
        } else {
            return light
        }
    }
    
    
    // https://stackoverflow.com/a/29779319/
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
    
}

extension UITextView {
    // https://stackoverflow.com/a/41387780
    func centerTextVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

// https://stackoverflow.com/a/30450559
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

// https://stackoverflow.com/a/41743706
extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}

extension UIViewController{
    // https://stackoverflow.com/a/27079103
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension UIImageView{
    func setImageURL(_ imageURL: String){
        self.sd_setImage(with: URL(string: imageURL));
    }
}

// https://stackoverflow.com/a/29779319/
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
