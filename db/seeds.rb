10.times do |i|
    pokemon_id = i + 1
    card = Card.create!(
      name: "Carte Pokémon ##{pokemon_id}",
      rarity: ["Commun", "Rare", "Épique", "Légendaire"].sample,
      image_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/#{pokemon_id}.png",
      last_price: [10.0, 20.0, 50.0, 100.0].sample,
      state: ["non à vendre", "à vendre"].sample,
      user_id: nil
    )
    
    puts "Carte Pokémon ##{pokemon_id} ajoutée !"
  end

# Créer un utilisateur de test
User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123",
  username: "TestUser",
  balance: 1000.0
)

puts "Utilisateur de test créé : test@example.com"

# Si vous voulez créer plusieurs utilisateurs
users_data = [
  { email: "user1@example.com", password: "password123", username: "User1", balance: 500.0 },
  { email: "user2@example.com", password: "password123", username: "User2", balance: 750.0 },
  { email: "admin@example.com", password: "admin123", username: "Admin", role: "admin", balance: 10000.0 }
]

users_data.each do |user_attrs|
  User.create!(user_attrs)
  puts "Utilisateur #{user_attrs[:email]} créé !"
end