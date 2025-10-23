puts "== Seeding users =="

# 1) Créer d'abord les utilisateurs
seed_users = [
  { email: "test@example.com",  username: "TestUser", balance: 1000.0, password: "password123" },
  { email: "user1@example.com", username: "User1",    balance: 500.0,  password: "password123" },
  { email: "user2@example.com", username: "User2",    balance: 750.0,  password: "password123" },
  { email: "admin@example.com", username: "Admin",    balance: 10_000.0, password: "admin123" }
]

users = seed_users.map do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.username = attrs[:username]
  user.balance = attrs[:balance]
  user.password = attrs[:password]
  user.password_confirmation = attrs[:password]
  user.save!
  puts "Utilisateur créé/présent: #{user.email}"
  user
end

puts "== Seeding cards (vraies cartes Pokémon TCG assignées à des utilisateurs) =="

# 2) Créer des cartes TCG avec de vraies images (Pokémon TCG image CDN)
# Format: https://images.pokemontcg.io/<set>/<number>_hires.png
# Référence (exemples Base Set Holo 1–16)
tcg_cards = [
  { name: "Alakazam",   set: "base1", num: 1 },
  { name: "Blastoise",  set: "base1", num: 2 },
  { name: "Chansey",    set: "base1", num: 3 },
  { name: "Charizard",  set: "base1", num: 4 },
  { name: "Clefairy",   set: "base1", num: 5 },
  { name: "Gyarados",   set: "base1", num: 6 },
  { name: "Hitmonchan", set: "base1", num: 7 },
  { name: "Machamp",    set: "base1", num: 8 },
  { name: "Magneton",   set: "base1", num: 9 },
  { name: "Mewtwo",     set: "base1", num: 10 },
  { name: "Nidoking",   set: "base1", num: 11 },
  { name: "Ninetales",  set: "base1", num: 12 },
  { name: "Poliwrath",  set: "base1", num: 13 },
  { name: "Raichu",     set: "base1", num: 14 },
  { name: "Venusaur",   set: "base1", num: 15 },
  { name: "Zapdos",     set: "base1", num: 16 }
]

rarities = ["Commun", "Rare", "Épique", "Légendaire"]
prices   = [10.0, 20.0, 50.0, 100.0]
states   = ["non à vendre", "à vendre"]

tcg_cards.first(10).each_with_index do |c, i|
  owner = users[i % users.length] # round-robin sur les utilisateurs
  image_url = "https://images.pokemontcg.io/#{c[:set]}/#{c[:num]}_hires.png"

  card = Card.create!(
    name: c[:name],
    rarity: rarities.sample,
    image_url: image_url,
    last_price: prices.sample,
    state: states.sample,
    user: owner
  )

  puts "Carte TCG '#{card.name}' ajoutée ! (propriétaire: #{owner.username})"
end