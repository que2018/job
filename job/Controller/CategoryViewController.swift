
import UIKit

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categoryCollectionview: UICollectionView!
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 4,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = columnLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        
        categoryCollectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoryCollectionview.dataSource = self
        categoryCollectionview.delegate = self
        categoryCollectionview.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "category_cell")

        categoryCollectionview.contentInsetAdjustmentBehavior = .always
        categoryCollectionview.showsVerticalScrollIndicator = false
        categoryCollectionview.backgroundColor = UIColor.white
        
        self.view.addSubview(categoryCollectionview)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionview.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as! CategoryCollectionViewCell
        
        return cell
    }
}
