import UIKit



class CustomTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelDateGame: UILabel!
    @IBOutlet weak var labelNumberCell: UILabel!
    @IBOutlet weak var titleScore: UILabel!
    @IBOutlet weak var titleDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with nameUserValue: String, and scoreUserValue: String, and dateUserValue: String ) {
        self.labelName.text = nameUserValue
        self.labelScore.text = scoreUserValue
        self.labelDateGame.text = dateUserValue
    }
    
}
