//
//  UIView+Additions.swift
//  Alamofire
//
//  Created by Gennady Berezovsky on 10.03.18.
//

import Foundation

extension UIView {
    
    public class func gb_nibUsingClassName() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    public class func gb_loadFromDefaultNib() -> Self? {
        guard let view = self.gb_nibUsingClassName().instantiate(withOwner: nil, options: nil).first as? UIView else {
            return nil
        }
        return unsafeDowncast(view, to: self)
    }
    
}
