//
//  RollViewController.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit

class RollViewController: UIViewController {
    
    var roll: RollModel!
    var featuresButton: UIBarButtonItem!
    var featuresTable: FeaturesTableViewController!

    
    init(roll: RollModel){
        self.roll = roll
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetUp()
        featuresButton = UIBarButtonItem(title: "features", style: .plain, target: self, action: #selector(toggleFeatures))
        navigationItem.rightBarButtonItem = featuresButton
    }
    

    
    private func viewSetUp() {
        
        view.backgroundColor = #colorLiteral(red: 0.1763378084, green: 0.2606173754, blue: 0.2889331877, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        
        let scrollView = UIScrollView(frame: view.bounds)
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
            imageView.contentMode = .scaleAspectFill
            Task {
                imageView.image = try await roll.image
            }
            return imageView
        }()
        scrollView.addSubview(imageView)
        
        let label: UILabel = {
            let label = UILabel(frame: CGRect(x: 12, y: view.frame.size.width + 15, width: view.frame.size.width - 24, height: 60))
            label.font = UIFont(name: "Helvetica Bold", size: 33)
            label.textColor = #colorLiteral(red: 0.6786612868, green: 0.8234902024, blue: 0.8753830194, alpha: 1)
            label.text = roll.name
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        scrollView.addSubview(label)
        
        let textView: UITextView = {
            let textView = UITextView(frame: CGRect(x: 10, y: view.frame.size.width + 80, width: view.frame.size.width - 20, height: view.frame.size.height))
            textView.text = roll.description
            textView.font = UIFont(name: "Helvetica", size: 20)
            textView.textColor = .white
            textView.backgroundColor = .clear
            textView.isEditable = false
            textView.sizeToFit()
            return textView
        }()
        scrollView.addSubview(textView)

        let subviewsSize: CGRect = scrollView.subviews.reduce(into: .zero){$0 = $0.union($1.frame)}
        scrollView.contentSize = subviewsSize.size
       
        view.addSubview(scrollView)
    }
    
    
    @objc private func toggleFeatures(){
      
        featuresButton.isSelected = !featuresButton.isSelected
        
        if featuresButton.isSelected{
            featuresTable = FeaturesTableViewController(features: roll.info)
            if let sheet = featuresTable.sheetPresentationController{
                sheet.delegate = self
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            present(featuresTable, animated: true)
        } else {
            featuresTable.dismiss(animated: true)
            featuresTable = nil
        }
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        featuresTable?.dismiss(animated: true)
    }

}



// MARK: - SheetPresentationControllerDelegateMethod

extension RollViewController: UISheetPresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        
        featuresButton.isSelected = false
        featuresTable = nil
    }

}
