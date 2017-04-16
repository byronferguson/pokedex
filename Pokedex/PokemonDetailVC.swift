//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Byron Ferguson on 4/11/17.
//  Copyright © 2017 Byron Ferguson. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLable: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pokemon are create with this basic info
        // additional details are lazy loaded async
        nameLabel.text = pokemon.name
        pokedexLabel.text = "\(pokemon.pokedexId)"
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = image
        currentEvoImage.image = image
        
        pokemon.downloadPokemonDetail {
            // runs after download complete
            // Update UI
            self.updateUI()
        }
    }
    
    func updateUI() {

        attackLabel.text = pokemon.attack
        defenseLable.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        typeLabel.text = pokemon.type
        descriptionLabel.text = pokemon.description
        
        evoLabel.text = pokemon.nextEvolutionText
        
        if pokemon.nextEvolutionName == "" {
            nextEvoImage.isHidden = true
        }
        else {
            nextEvoImage.image = UIImage(named: "\(pokemon.nextEvolutionId)")
        }
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
