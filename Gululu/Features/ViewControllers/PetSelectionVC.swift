//
//  PetSelectionVC.swift
//  Gululu
//
//  Created by Ray Xu on 22/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class PetSelectionVC: BaseViewController ,UICollectionViewDelegate , UICollectionViewDataSource{
    
    let CELL_WIDTH : CGFloat = (SCREEN_WIDTH)/3
    let CELL_HEIGHT : CGFloat = SCREEN_HEIGHT*2/7
    let LAYOUT_LEFTORRIGHT_WIDTH : CGFloat = (SCREEN_WIDTH-40)/5 + 20

    var collectionView : UICollectionView!
    var petNameArray : NSArray?
    
    @IBOutlet weak var Caption: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var CapConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var petNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false

        Caption.text = GPet.share.getPetSelectTitle()
        
        nextButton.setTitle(NEXT, for: .normal)
        
        getPetName()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func createCollectView() {
        let layout = CDFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.sectionInset = UIEdgeInsetsMake(0, LAYOUT_LEFTORRIGHT_WIDTH, 0, LAYOUT_LEFTORRIGHT_WIDTH)
        layout.headerReferenceSize = CGSize(width: CELL_WIDTH, height: 0)
        layout.footerReferenceSize = CGSize(width: CELL_WIDTH, height: 0)
        layout.itemSize = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 150, width: SCREEN_WIDTH, height: CELL_HEIGHT), collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CDViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CDViewCell.self))
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        view.addSubview(collectionView)
        
        loadFirstPetImage()
        
        let index = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }
    
    func loadFirstPetImage() {
        GPet.share.chosePetName = petNameArray?.object(at: 1) as! String
        changePet()
    }
    
    func getPetName() {
        GPet.share.getGamePets{ result in
            self.petNameArray = result
            if self.petNameArray?.count == 0 || self.petNameArray == nil{
                return
            }else{
                DispatchQueue.main.async {
                    self.createCollectView()
                }
            }
            
        }
    }
    
    //UICollectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petNameArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CDViewCell.self), for: indexPath) as! CDViewCell
        loadCellImage(petNameArray?[indexPath.row] as! String,cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        GPet.share.chosePetName =  petNameArray?.object(at: indexPath.row) as! String
        changePet()
    }
    
    func loadCellImage(_ petName: String,cell : CDViewCell) {
        let bundle = Bundle.main
        let petFile = GPet.share.getPetImageName(petName)
        let URLPet = bundle.url(forResource: petFile, withExtension: "gif")
        let dataPet = try! Data(contentsOf: URLPet!, options: NSData.ReadingOptions.mappedIfSafe)
        cell.petImageView.animatedImage = FLAnimatedImage(animatedGIFData:(dataPet))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var stayCollectCell = Int(scrollView.contentOffset.x/CELL_WIDTH)
        if stayCollectCell > 2{
            stayCollectCell = 2
        }
        if stayCollectCell < 0{
            stayCollectCell = 0
        }
        GPet.share.chosePetName =  petNameArray?.object(at: stayCollectCell) as! String
        changePet()
    }
    
    func changePet() {
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        
        petNameLabel.text = GPet.share.changePetName(petName: GPet.share.chosePetName)
        
        descriptionTextView.text = GPet.share.petDesp[GPet.share.getPetImageName(GPet.share.chosePetName)]
        descriptionTextView.textAlignment = NSTextAlignment.center
        descriptionTextView.font = UIFont(name: BASEFONT, size: 18)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goChosePetNextVC(_ sender: AnyObject) {
        goto(vcName: "confirmPet", boardName: "ChosePet")
    }

}
