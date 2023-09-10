//
//  AddChildView.swift
//  Gululu
//
//  Created by Ray Xu on 28/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import CoreData

enum CellSelectType {
    case changeChild
    case addChild
}

protocol AddChildViewDelegate: NSObjectProtocol {
    func connectBottleToSetSSID(_ index: Int)
    func didSelectoCellAction(_ selectType: CellSelectType, selectIndex: Int)
}

class AddChildView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, ChildCollectionCellDelegate,  UIScrollViewDelegate {
    @IBOutlet weak var childrenCollectionView: UICollectionView!
    
    var container: UIViewController!
    var childrenView: UIView!
    var cellNums: Int!
    var delegate : AddChildViewDelegate?
    var childrenList = NSArray()
    var buttonWidth:CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout AddChildView
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddChildView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0]
        return view as! UIView
    }
    
    func xibSetup()
    {
        childrenView = loadViewFromNib()
        childrenView.frame = bounds
        childrenView.layer.shadowRadius = 11
        childrenView.layer.shadowOpacity = 0.5
        childrenView.layer.shadowColor = UIColor.clear.cgColor
        childrenView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        childrenCollectionView.dataSource = self
        childrenCollectionView.delegate = self
        
        let childListNib = UINib(nibName: "ChildCollectionCell", bundle: nil)
        childrenCollectionView.register(childListNib, forCellWithReuseIdentifier: "cellchild")
        
        let addChildNib = UINib(nibName: "ChildCellView", bundle: nil)
        childrenCollectionView.register(addChildNib, forCellWithReuseIdentifier: "cell")
        addSubview(childrenView)
        
        childrenCollectionView.reloadData()
    }
    
    // MARK: - UICollection DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        cellNums = childrenList.count
        return cellNums + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell:ChildCollectionCell
        
        if indexPath == IndexPath(row: cellNums, section: 0) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellchild", for: indexPath) as! ChildCollectionCell
            
            let child = childrenList.object(at: (indexPath as NSIndexPath).row) as! Children
            cell.reloadChildCollectionCell(child, tag: (indexPath as NSIndexPath).row)
            if cell.delegate == nil { cell.delegate = self }
        }
        
        cell.backgroundColor = .clear
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath == IndexPath(row: cellNums, section: 0) {
            return CGSize(width: frame.width-1, height: frame.width * 150/260)
        }
//        childrenCollectionView.reloadData()
        childrenCollectionView.collectionViewLayout.invalidateLayout()
        childrenCollectionView.setCollectionViewLayout(collectionViewLayout, animated: false)

        return CGSize(width: frame.width-1, height: frame.width * 190/260)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: frame.height * 52/667, left: 0, bottom: frame.height * 52/667, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: cellNums, section: 0){
            let selectedCell = collectionView.cellForItem(at: indexPath) as! ChildCellView
            
            UIView.animate(withDuration: 0.2, delay:0.14,options:.curveEaseInOut, animations: {                selectedCell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                selectedCell.alpha = 0.8
                
            }, completion: { (success) in
                UIView.animate(withDuration: 0.15, animations: {
                    selectedCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    selectedCell.alpha = 1.0
                    
                }, completion: { (success) in
                    self.delegate?.didSelectoCellAction(CellSelectType.addChild, selectIndex: (indexPath as NSIndexPath).row)
                })
            })
        }else {
            let selectedCell = collectionView.cellForItem(at: indexPath) as! ChildCollectionCell
            
            UIView.animate(withDuration: 0.15, animations: {
                selectedCell.ChilldAvatar.transform = CGAffineTransform(scaleX: 1.05,y: 1.05)
                selectedCell.ChilldAvatar.alpha = 0.8
            }, completion: { (success) in
                UIView.animate(withDuration: 0.15, animations: {
                    selectedCell.ChilldAvatar.transform = CGAffineTransform(scaleX: 1.05,y: 1.05)
                    selectedCell.ChilldAvatar.alpha = 1.0
                    self.childrenView.layer.shadowColor = UIColor.clear.cgColor
                }, completion: { (success) in
                    self.delegate?.didSelectoCellAction(CellSelectType.changeChild, selectIndex: (indexPath as NSIndexPath).row)
                })
            })
        }
    }
    
    // MARK: - Calculate point of mask view
    func calculatePoint(_ row: Int, section: Int) -> (point: CGPoint, tipTop: Bool)   {
        self.layoutIfNeeded()
        
        var point: CGPoint = CGPoint(x: 0.0, y: 0.0)
        var tipTop: Bool = false
        let indexPath = IndexPath(row: 0, section: section)
        var cell = self.childrenCollectionView.cellForItem(at: indexPath) as? ChildCollectionCell
        if cell == nil {
            let targetIndexPath = IndexPath(row: row, section: section)
            childrenCollectionView.scrollToItem(at: targetIndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            childrenCollectionView.reloadData()
            childrenCollectionView.layoutIfNeeded()
            cell = childrenCollectionView.cellForItem(at: targetIndexPath) as? ChildCollectionCell
            
            if cell == nil {
                return (CGPoint(x: 0,y: 0), false)
            }
        }
        
        let targetIndexPath = IndexPath(row: row, section: section)
        childrenCollectionView.scrollToItem(at: targetIndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        
        var pointY = FIT_SCREEN_WIDTH(54) + cell!.addCupButton.center.y + cell!.frame.height*CGFloat(row)
        
        let radius = FIT_SCREEN_HEIGHT(61)
        if pointY > SCREEN_HEIGHT - radius {
            tipTop = true
            pointY = SCREEN_HEIGHT - (cell!.frame.height - cell!.addCupButton.center.y)
        }
        point = CGPoint(x: cell!.addCupButton.center.x + 12.0, y: pointY)
        return (point, tipTop)
    }
    
    // MARK: - ChildCollectionCell Delegate
    func connectBottle(tag: Int) {
        delegate?.connectBottleToSetSSID(tag)
    }
    
    func tapChildAction(tag: Int) {
        let indexPath = NSIndexPath(row: tag, section: 0)
        
        let selectedCell = childrenCollectionView.cellForItem(at: indexPath as IndexPath) as! ChildCollectionCell
        
        UIView.animate(withDuration: 0.2, delay:0.14,options:.curveEaseInOut, animations: {
            selectedCell.ChilldAvatar.transform = CGAffineTransform(scaleX: 1.05,y: 1.05)
            selectedCell.ChilldAvatar.alpha = 0.8
            }, completion: { (success) in
                UIView.animate(withDuration: 0.15, animations: {
                    selectedCell.ChilldAvatar.transform = CGAffineTransform(scaleX: 1.05,y: 1.05)
                    selectedCell.ChilldAvatar.alpha = 1.0
                    self.childrenView.layer.shadowColor = UIColor.clear.cgColor
                    
                    }, completion: { (success) in
                        self.delegate?.didSelectoCellAction(CellSelectType.changeChild, selectIndex: indexPath.row)
                })
        })
    }
    
}
