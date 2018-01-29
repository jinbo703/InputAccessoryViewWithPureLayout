//
//  TextView.swift
//  InputAccessoryView
//
//  Created by John Nik on 1/29/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

protocol TextViewDelegate: NSObjectProtocol {
    func textDidChange(textView: UITextView)
}

class TextView: UITextView {
    
    weak var textViewDelegate: TextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupNotification()
    }
    
    func setupNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(textview:)), name: .UITextViewTextDidChange, object: self)
    }
    
    @objc func textDidChange(textview: UITextView) {
        self.textViewDelegate?.textDidChange(textView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
