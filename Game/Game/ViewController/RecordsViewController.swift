import UIKit



class RecordsViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variable
    var scoreResult = [(nameUserValue:String, scoreUserValue:String, dateUserValue: String )]()
    private var score: [ScoreUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButtonBack()
        self.createlabelTitiePage(title: "Records".localized())
        self.createCustomTableViewCellPrize()
        self.createCustomTableViewCell()
        self.score = ScoreManager.shared.getSettings()
        guard let scoreArray = score else {return}
        for element in scoreArray{
            guard let arrayName = element.name else {return}
            guard let arrayScore = element.score else {return}
            guard let arrayDate = element.date else {return}
            self.scoreResult.append((nameUserValue: arrayName, scoreUserValue: String(arrayScore), dateUserValue: arrayDate))
        }
        self.sortedResultArray()
    }
    
    func sortedResultArray(){
        self.scoreResult.sort(by: {$0.scoreUserValue > $1.scoreUserValue})
    }
    
    func createCustomTableViewCellPrize() {
        let nibTableViewCell = UINib(nibName: "CustomPrizePlaceTableViewCell", bundle: nil)
        self.tableView.register(nibTableViewCell, forCellReuseIdentifier: "CustomPrizePlaceTableViewCell")
    }
    
    func createCustomTableViewCell() {
        let nibTableViewCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(nibTableViewCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
    
}

extension RecordsViewController:  UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreResult.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 3 {
            let cellPrize = tableView.dequeueReusableCell(withIdentifier: "CustomPrizePlaceTableViewCell", for: indexPath) as! CustomPrizePlaceTableViewCell
            let imageView = UIImageView(frame: CGRect(x:15, y: 0, width: cellPrize.frame.width - 30, height: cellPrize.frame.height - 15))
            let image = UIImage(named: "bg-table-records")
            imageView.image = image
            cellPrize.backgroundView = UIView()
            cellPrize.backgroundView!.addSubview(imageView)
            cellPrize.configure(with: "\(scoreResult[indexPath.row].nameUserValue)", and: "\(scoreResult[indexPath.row].scoreUserValue)", and: " \(scoreResult[indexPath.row].dateUserValue)")
            switch indexPath.row {
            case 0 :
                cellPrize.imagePlace.image = UIImage(named: "place_one")
            case 1 :
                cellPrize.imagePlace.image = UIImage(named: "place_two")
            case 2 :
                cellPrize.imagePlace.image = UIImage(named: "place_three")
            default:
                break
            }
            return cellPrize
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            let imageView = UIImageView(frame: CGRect(x:15, y: 0, width: cell.frame.width - 30, height: cell.frame.height - 15))
            let image = UIImage(named: "bg-table-records")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            cell.configure(with: "\(scoreResult[indexPath.row].nameUserValue) ", and: "\(scoreResult[indexPath.row].scoreUserValue)", and: " \(scoreResult[indexPath.row].dateUserValue)")
            cell.labelNumberCell.text = "\(indexPath.row+1)."
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
