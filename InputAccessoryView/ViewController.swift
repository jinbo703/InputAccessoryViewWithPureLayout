//
//  ViewController.swift
//  InputAccessoryView
//
//  Created by John Nik on 1/29/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

let AnswerComposerHeight: CGFloat = 45.0

class ViewController: UIViewController {

    let cellId = "cellId"
    
    //MARK: - Accessors
    
    /// A table View to show the messages entered through the textView.
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView.newAutoLayout()
        
        tableView.dataSource = self
        
        // Important to allow pan down to dismiss the keyboard.
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        
        return tableView
    }()
    
    /// The UIView subclass with a UITextView and a UIButton to enter text.
    /// This subclass will be returned as the UIResponder inputAccessoryView.
    lazy var answerComposer: AnswerComposer = {
        
        let frame = CGRect(x: 0.0,
                           y: UIScreen.main.bounds.midY - AnswerComposerHeight,
                           width: 320.0,
                           height: AnswerComposerHeight)
        
        let answerComposer = AnswerComposer(frame: frame)
        
        answerComposer.delegate = self
        
        return answerComposer
    }()

    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        registerCells()
        
        updateViewConstraints()
        
        view.backgroundColor = UIColor.orange
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - UIResponder
    
    override var inputAccessoryView: UIView? {
        
        return answerComposer
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        /*-----------------------*/
        
        tableView.autoPinEdge(toSuperviewEdge: .top)
        
        tableView.autoPinEdge(toSuperviewEdge: .left)
        
        tableView.autoPinEdge(toSuperviewEdge: .right)
        
        tableView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    //MARK: - RegisterCells
    
    func registerCells() {
        
        tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: cellId)
    }
    
    // MARK: - NotificationActions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardInfo = notification.userInfo as? [String : AnyObject],
            let keyboardFrameEndValue = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardFrameBeginValue = keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            // CGRect from NSValue
            let keyboardFrameEndRect = keyboardFrameEndValue.cgRectValue
            let keyboardFrameBeginRect = keyboardFrameBeginValue.cgRectValue
            
            // Store contentOffset.y before changing contentInset. Sometimes get updated after updating contentInset.
            let contentOffsetY = tableView.contentOffset.y
            
            // Origin y change
            let keyboardOriginYChange = keyboardFrameBeginRect.origin.y - keyboardFrameEndRect.origin.y
            
            // Update contentInset and contentOffset to avoid jumps while sowing the keyboard
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                                  left: 0.0,
                                                  bottom: keyboardFrameEndRect.midY,
                                                  right: 0.0)
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                              y: contentOffsetY + keyboardOriginYChange)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardInfo = notification.userInfo as? [String : AnyObject],
            let keyboardFrameEndValue = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardFrameBeginValue = keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            // CGRect from NSValue
            let keyboardFrameEndRect = keyboardFrameEndValue.cgRectValue
            let keyboardFrameBeginRect = keyboardFrameBeginValue.cgRectValue
            
            // Origin y change
            let keyboardOriginYChange = keyboardFrameBeginRect.origin.y - keyboardFrameEndRect.origin.y
            
            // Update contentInset and contentOffset to avoid jumps while sowing the keyboard
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                                  left: 0.0,
                                                  bottom: keyboardFrameEndRect.midY,
                                                  right: 0.0)
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                              y: tableView.contentOffset.y + keyboardOriginYChange)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UITableViewDataSource {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 21
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = "row: \(indexPath.row)"
        return cell
    }
}

extension ViewController: AnswerComposerDelegate {
    
}

