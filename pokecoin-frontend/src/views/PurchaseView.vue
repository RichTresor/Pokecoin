<template>
    <div class="d-flex">
      <!-- Sidebar uniquement si l'utilisateur est connecté -->
      <Sidebar v-if="user" />
  
      <!-- Main Content -->
      <div class="main-content flex-grow-1">
        <!-- Navbar uniquement si l'utilisateur est connecté -->
        <Navbar v-if="user" />
  
        <!-- Page Content -->
        <div class="container mt-5">
          <h2 class="text-danger">Faire des achats</h2>
  
          <!-- Affichage des cartes -->
          <div class="row row-cols-1 row-cols-md-3 g-4">
            <div v-for="card in cards" :key="card.id" class="col">
              <div class="card h-100 shadow-sm">
                <div class="card-img-wrapper mb-3 overflow-hidden rounded-3">
                  <img :src="'/images/' + card.image_url" class="card-img-top img-fluid" alt="Image de la carte" />
                </div>
  
                <div class="card-body">
                  <h5 class="card-title text-dark">{{ card.name }}</h5>
                  <p class="card-text text-muted">Rareté : <span class="text-primary">{{ card.rarity }}</span></p>
                  <p class="card-text">Prix : <strong class="text-success">{{ card.last_price }} USD</strong></p>
  
                  <!-- Affichage du nom du propriétaire, s'il y en a un -->
                  <p v-if="card.user_id" class="card-text">Propriétaire : <span class="text-info">{{ card.owner_name }}</span></p>
                  <p v-else class="card-text text-danger">Carte sans propriétaire</p>
  
                  <!-- Bouton acheter si la carte est "à vendre" et sans propriétaire -->
                  <div v-if="card.state === 'à vendre' && !card.user_id">
                    <button class="btn btn-success" @click="buyCard(card)">Acheter</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import api from '@/services/api'
  import Navbar from '@/components/AppNavbar.vue'
  import Sidebar from '@/components/AppSidebar.vue'
  
  const user = ref(null)
  const cards = ref([])  // Pour stocker les cartes disponibles à la vente
  const router = useRouter()
  
  onMounted(async () => {
    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')  // Redirige si non connecté
      return
    }
  
    const storedUser = localStorage.getItem('user')
    if (storedUser) {
      user.value = JSON.parse(storedUser)
    }
  
    try {
      // Récupérer toutes les cartes sans propriétaire (user_id: null) ou à vendre
      const response = await api.get('/cards', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
  
      // Filtrer les cartes qui sont sans propriétaire ou en vente par un autre utilisateur
      cards.value = response.data.filter(card => card.state === 'à vendre' && (card.user_id === null || card.user_id !== user.value.id))
      
      // Ajouter le nom du propriétaire, si présent
      cards.value.forEach(card => {
        if (card.user_id) {
          const owner = response.data.find(u => u.id === card.user_id)
          card.owner_name = owner ? owner.username : 'Inconnu'
        }
      })
    } catch (error) {
      console.error('Erreur lors de la récupération des cartes :', error)
    }
  })
  
  // Méthode pour acheter une carte
  const buyCard = async (card) => {
    try {
      // Ici, tu peux implémenter la logique d'achat
      console.log(`Achat de la carte ${card.name} pour ${card.last_price} USD`)
      // Une fois l'achat effectué, tu pourrais aussi mettre à jour l'état de la carte (par exemple, changer son propriétaire)
    } catch (error) {
      console.error('Erreur lors de l\'achat de la carte :', error)
    }
  }
  </script>
  
  <style scoped>
  .main-content {
    margin-left: 250px; /* Espace pour la sidebar */
    padding: 20px;
  }
  </style>
  