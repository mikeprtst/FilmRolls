//
//  FilmViewModel.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit


class FilmViewModel{
    
    static let shared = FilmViewModel()
    
    
    private var filmRolls: [RollModel] = [] {
        didSet{
            callBack?()
        }
    }
    private var filteredFilmRolls: [RollModel] = []
    var searchIsActive: Bool = false {
        didSet{
            if searchIsActive{
                filteredFilmRolls = filmRolls
            } else {
                filteredFilmRolls = []
                callBack?()
            }
        }
    }
    var callBack: (() -> Void)?
    

    func fetch(_ completion: (()->Void)? = nil){
        let endpoint = "https://filmapi.vercel.app/api/films#"
        NetworkManager.shared.fetchData(stringURL: endpoint) { (result: Result<[RollData],Error>) in
            
            defer { completion?() }
            switch result{
            case .success(let rolls): self.filmRolls = rolls.map{RollModel(data: $0)}
            case .failure(_): return
            }
        }
    }
    
    
    func updateSearch(withText text: String){
        let text = text.lowercased()
        if text.count == 0 {
            filteredFilmRolls = filmRolls
        } else {
            filteredFilmRolls = filmRolls.filter{$0.name.contains(text) || $0.brand.contains(text)}
        }
        callBack?()
    }
    
    
    func updateSearch(withScope index: Int){
        switch index{
        case 0: filteredFilmRolls = filmRolls
        case 1: filteredFilmRolls = filmRolls.filter{$0.info[1].contains("Color Film")}
        case 2: filteredFilmRolls = filmRolls.filter{$0.info[1].contains("Black and White Film")}
        case 3: filteredFilmRolls = filmRolls.filter{$0.info[0][1].range(of: "35") != nil}
        case 4: filteredFilmRolls = filmRolls.filter{$0.info[0][1].range(of: "120") != nil}
        default:
            filteredFilmRolls = filmRolls
        }
        callBack?()
    }

    
    func getRoll(forIndex index: Int) -> RollModel {
        return searchIsActive ? filteredFilmRolls[index] : filmRolls[index]
    }
    
    func numberOfRows() -> Int {
        searchIsActive ? filteredFilmRolls.count : filmRolls.count
    }
}


