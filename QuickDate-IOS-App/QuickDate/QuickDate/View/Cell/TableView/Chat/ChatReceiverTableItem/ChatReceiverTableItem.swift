//
//  ChatReceiverTableItem.swift
//  DeepSoundiOS
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ChatReceiverTableItem: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        self.bgView.setRoundCornersBY(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner,.layerMinXMinYCorner], cornerRaduis: 12)
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func bind(_ object: ChatModel) {
        let text = object.text.htmlAttributedString
        let seen = object.created_at
        self.titleLabel.text = text
        self.dateLabel.text = getDate(unixdate: seen, timezone: "GMT")
    }
}

func getDate(unixdate: Int, timezone: String) -> String {
    if unixdate == 0 {return ""}
    let date = Date(timeIntervalSince1970: TimeInterval(unixdate))
    let dayTimePeriodFormatter = DateFormatter()
    if date.getDayMonthYearFormat() == Date().getDayMonthYearFormat() {
        dayTimePeriodFormatter.dateFormat = "h:mm a"
    }else {
        dayTimePeriodFormatter.dateStyle = .short
//        dayTimePeriodFormatter.timeStyle = .short
    }
    dayTimePeriodFormatter.timeZone = .current
    let dateString = dayTimePeriodFormatter.string(from: date)
    return "\(dateString)"
}

extension String {
    public func convertFormatStringToDate(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        dateFormatter.timeZone = .init(abbreviation: "GMT")
        dateFormatter.dateFormat = format
        let convertedDate = dateFormatter.date(from: self)
        return convertedDate
    }
}
