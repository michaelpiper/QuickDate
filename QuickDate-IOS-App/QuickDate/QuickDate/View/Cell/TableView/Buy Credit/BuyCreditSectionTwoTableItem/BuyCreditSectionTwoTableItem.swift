//
//  BuyCreditSectionTwoTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit


var dataSetTwoArray = [dataSetTwo]()

protocol BuyCreditDelegate {
    func selectedCreditType(_ index: Int, Amount: Int)
}

class BuyCreditSectionTwoTableItem: UITableViewCell {
    
    @IBOutlet weak var buyCreditLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: BuyCreditDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    private func setupUI(){
        self.buyCreditLabel.text = NSLocalizedString("Buy Credit", comment: "Buy Credit")
        dataSetTwoArray = [
            dataSetTwo(title: NSLocalizedString("Bag of Credits", comment: "Bag of Credits"), Credit: "1000", itemImage: UIImage(named: "ic_bag_ofcredits"), ammount: "$ 50"),
            dataSetTwo(title:NSLocalizedString("Box of Credits", comment: "Box of Credits") , Credit: "5000", itemImage: UIImage(named: "ic_box_of_credits"), ammount: "$ 100"),
            dataSetTwo(title:NSLocalizedString("Chest of Credits", comment: "Chest of Credits") , Credit: "10000", itemImage: UIImage(named: "ic_chest_of_credits"), ammount: "$ 150")
        ]
        collectionView.register(UINib(resource:R.nib.buyCreditSectionTwoCollectionItem), forCellWithReuseIdentifier: R.reuseIdentifier.buyCreditSectionTwoCollectionItem.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}
extension BuyCreditSectionTwoTableItem:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSetTwoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.buyCreditSectionTwoCollectionItem.identifier, for: indexPath) as? BuyCreditSectionTwoCollectionItem
        let object = dataSetTwoArray[indexPath.row]
        cell!.bind(object)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = dataSetTwoArray[indexPath.row]
        let amount = indexPath.row == 0 ? 50 : indexPath.row == 1 ? 100 : 150
        self.delegate?.selectedCreditType(indexPath.row, Amount: amount)
    }
}

extension BuyCreditSectionTwoTableItem: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}
