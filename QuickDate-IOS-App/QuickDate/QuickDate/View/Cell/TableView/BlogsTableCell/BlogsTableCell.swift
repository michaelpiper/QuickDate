

import UIKit

class BlogsTableCell: UITableViewCell {
    @IBOutlet weak var descriptionlabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryBg: UIView!
    @IBOutlet weak var blogCategoryLabel: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ object: Blog) {
        self.titleLabel.text = object.title
        let date = Date(timeIntervalSince1970: TimeInterval(object.created_at))
        self.timeLabel.text = Date().timeAgo(from: date)//setTimestamp(epochTime: "\(object.created_at)")
        self.descriptionlabel.text = object.description.htmlAttributedString
        self.blogCategoryLabel.text = object.category_name
        if let avatarURL = URL(string: object.thumbnail) {
            self.blogImage.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
        } else {
            self.blogImage.image = UIImage(named: "no_profile_image")
        }
    }
}

extension Date {
 // Returns the number of years
 func yearsCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
 }
 // Returns the number of months
 func monthsCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
 }
 // Returns the number of weeks
 func weeksCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
 }
 // Returns the number of days
 func daysCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
 }
 // Returns the number of hours
 func hoursCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
 }
 // Returns the number of minutes
func minutesCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
 }
 // Returns the number of seconds
 func secondsCount(from date: Date) -> Int {
    return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
 }
 // Returns time ago by checking if the time differences between two dates are in year or months or weeks or days or hours or minutes or seconds
 func timeAgo(from date: Date) -> String {
    if yearsCount(from: date)   > 0 { return "\(yearsCount(from: date)) years ago"   }
    if monthsCount(from: date)  > 0 { return "\(monthsCount(from: date)) months ago"  }
    if weeksCount(from: date)   > 0 { return "\(weeksCount(from: date)) weeks ago"   }
    if daysCount(from: date)    > 0 { return "\(daysCount(from: date)) days ago"    }
    if hoursCount(from: date)   > 0 { return "\(hoursCount(from: date)) hours ago"   }
    if minutesCount(from: date) > 0 { return "\(minutesCount(from: date)) minutes ago" }
    if secondsCount(from: date) > 0 { return "\(secondsCount(from: date)) seconds ago" }
    return ""
  }
}
