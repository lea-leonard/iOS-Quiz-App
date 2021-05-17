//
//  AdminQuestionTextViewCell.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

protocol AdminQuestionTextViewCellDelegate: AnyObject {
    func textViewDidChange(_ textView: UITextView, inCell cell: AdminQuestionTextViewCell, heightChanged: Bool)
    func checkboxViewChanged(inCell cell: AdminQuestionTextViewCell, checkboxView: CheckboxView)
    func tappedDeleteButton(inCell cell: AdminQuestionTextViewCell)
}

class AdminQuestionTextViewCell: BaseTableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var questionAnswerLabel: UILabel!
    
    @IBOutlet weak var correctChoiceLabel: UILabel!
    
    @IBOutlet weak var correctChoiceCheckbox: CheckboxView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var indentConstraint: NSLayoutConstraint!
    
    var previousTextViewHeight: CGFloat?
    
    weak var delegate: AdminQuestionTextViewCellDelegate?
    
    override class var reuseIdentifier: String {
        "AdminQuestionTextViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
        
        self.textView.layer.cornerRadius = 6
        self.textView.layer.cornerCurve = .continuous
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.systemGray4.cgColor
        
        self.correctChoiceCheckbox.setBoxType(.radio)
        
        self.correctChoiceCheckbox.addValueChangedAction({ [weak self] checkboxView in
            self?.checkboxViewChanged(checkboxView: checkboxView)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state oaeu
    }
    
    func setDeleteButtonActive(_ active: Bool) {
        self.deleteButton.setTitleColor(active ? .systemRed : .secondaryLabel, for: .normal)
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        var heightChanged = false
        textView.sizeToFit()
        let textViewHeight = textView.frame.size.height
        if let previousTextViewHeight = self.previousTextViewHeight {
            if textViewHeight != previousTextViewHeight {
                heightChanged = true
            }
        }
        self.previousTextViewHeight = textViewHeight
        self.delegate?.textViewDidChange(textView, inCell: self, heightChanged: heightChanged)
    }
    
    
    func checkboxViewChanged(checkboxView: CheckboxView) {
        self.delegate?.checkboxViewChanged(inCell: self, checkboxView: checkboxView)
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        self.delegate?.tappedDeleteButton(inCell: self)
    }
    
}
