//
//  FilmTableViewController.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit

class FilmTableViewController: UITableViewController {
    
    let viewModel = FilmViewModel.shared
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FilmTableViewCell", bundle: nil), forCellReuseIdentifier: "filmCell")
        
        viewSetUp()
        searchControllerSetUp()
        interactionSetUp()
        
        viewModel.callBack = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetch()
    }
    
    
    private func viewSetUp(){
        let appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = #colorLiteral(red: 0.4265339971, green: 0.6128998995, blue: 0.669922173, alpha: 1).withAlphaComponent(0.8)
            let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: .bold, width: .expanded), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2202457786, green: 0.3190936446, blue: 0.3538730741, alpha: 1) ]
            appearance.titleTextAttributes = titleAttribute as [NSAttributedString.Key : Any]
            return appearance
        }()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        title = "Film Rolls"

        let backView: UIImageView = {
            let image = UIImage(named: "background")
            let view = UIImageView(image: image)
            view.frame = self.view.bounds
            view.contentMode = .scaleAspectFill
            view.alpha = 0.3
            return view
        }()
        tableView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        tableView.backgroundView = backView
    }

    private func searchControllerSetUp(){
        searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.scopeButtonTitles = ["all", "color", "b&w", "35mm", "120"]
        navigationItem.searchController = searchController
    }
    
    private func interactionSetUp(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                              #selector(refreshPulled),
                                              for: .valueChanged)
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleTapped)))
    }
    
    @objc private func refreshPulled() {
        viewModel.fetch(){ [weak self] in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc private func titleTapped(){
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    private func pushRollVC(atIndex index: Int){
        let roll = viewModel.getRoll(forIndex: index)
        let rollVC = RollViewController(roll: roll)
        navigationController?.pushViewController(rollVC, animated: true)
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmTableViewCell

        let roll = viewModel.getRoll(forIndex: indexPath.row)
        
        cell.firstLabel.text = roll.brand
        cell.secondLabel.text = roll.name
        cell.cancelableTask = Task {
            cell.cellImage.image = try await roll.thumbnail
        }

        return cell
    }
       

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        pushRollVC(atIndex: indexPath.row)
    }

}




// MARK: - SearchDelegates

extension FilmTableViewController: UISearchControllerDelegate, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearch(withText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.updateSearch(withScope: selectedScope)
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.searchIsActive = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.selectedScopeButtonIndex = 0
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.searchIsActive = false
        searchController.searchBar.showsScopeBar = false
    }
    
}
