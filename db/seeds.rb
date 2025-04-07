10.times do |i|
    card = Card.create!(
      name: "Carte Pokémon ##{i + 1}",
      rarity: ["Commun", "Rare", "Épique", "Légendaire"].sample,  # La rareté choisie aléatoirement
      image_url: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{(i + 1).to_s.rjust(3, '0')}.png",  # Image Pokémon générique
      last_price: [10.0, 20.0, 50.0, 100.0].sample,  # Le prix est choisi aléatoirement
      state: ["non à vendre", "à vendre"].sample,  # Etat de la carte, soit "à vendre" ou "non à vendre"
      user_id: nil  # Aucun utilisateur n'est assigné par défaut (carte sans propriétaire)
    )
    
    puts "Carte Pokémon ##{i + 1} ajoutée !"
  end