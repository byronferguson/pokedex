//
//  Pokemon.swift
//  Pokedex
//
//  Created by Byron Ferguson on 4/9/17.
//  Copyright © 2017 Byron Ferguson. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _pokemonURL: String!
    
    private var _pokedexId: Int!
    private var _name: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _defense: String!
    private var _description: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _nextEvolutionTxt: String!
    
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var name: String {
        return _name
    }
    
    var type: String {
        return _type ?? ""
    }
    
    var height: String {
        return _height ?? ""
    }
    
    var weight: String {
        return _weight ?? ""
    }
    
    var attack: String {
        return _attack ?? ""
    }
    
    var defense: String {
        return _defense ?? ""
    }
    
    var description: String {
        return _description ?? ""
    }
    
    var nextEvolutionName: String {
        return _nextEvolutionName ?? ""
    }
    
    var nextEvolutionId: String {
        return _nextEvolutionId ?? ""
    }
    
    var nextEvolutionLvl: String {
        return _nextEvolutionLvl ?? ""
    }
    
    var nextEvolutionText: String {
        
        if nextEvolutionName == "" || nextEvolutionLvl == "" {
            return "Final Evolution"
        }
        else {
            return "Next Evolution: \(nextEvolutionName) LVL \(nextEvolutionLvl)"
        }
    }

    
    init(name: String, pokedexId: Int) {
        self._name = name.capitalized
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
             
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>], descriptions.count > 0 {
                    
                    if let uri = descriptions[0]["resource_uri"] {
                        
                        let url = "\(URL_BASE)\(uri)"
                        print(url)
                       
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let desc = descDict["description"] as? String {
                                    let newDesc = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                }
                            }
                            
                            completed()
                        })
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                        }
                    }
                    
                    if let uri = evolutions[0]["resource_uri"] as? String {
                        let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                        
                        self._nextEvolutionId = nextEvoId
                    }
                    
                    if let lvl = evolutions[0]["level"] as? Int {
                        self._nextEvolutionLvl = "\(lvl)"
                    }
                    
                }
                
                print("Height : \(self._height)")
                print("Weight : \(self._weight)")
                print("Attack : \(self._attack)")
                print("Defense: \(self._defense)")
                
            } // outer response
            
            // Final step of the response is to inform the caller the response has completed
            completed()
        }
    }
}
