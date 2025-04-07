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
          <h2 class="text-danger">Toutes mes cartes Pokémon 🃏</h2>
  
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
                  <p class="card-text">Dernier prix : {{ card.last_price }} USD</p>
  
                  <!-- Affichage et gestion du bouton "Vendre" / "Annuler la vente" -->
                  <div v-if="card.state === 'non à vendre'">
                    <button class="btn btn-warning" @click="changeCardState(card, 'à vendre')">Vendre</button>
                  </div>
                  <div v-else-if="card.state === 'à vendre'">
                    <button class="btn btn-danger" @click="changeCardState(card, 'non à vendre')">Annuler la vente</button>
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
  const cards = ref([])  // Pour stocker les cartes de l'utilisateur
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
      // Récupérer les cartes de l'utilisateur depuis l'API
      const response = await api.get('/cards', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
      // Filtrer les cartes pour n'afficher que celles de l'utilisateur connecté
      cards.value = response.data.filter(card => card.user_id === user.value.id)
    } catch (error) {
      console.error(error)
    }
  })
  
  // Méthode pour changer l'état d'une carte
  const changeCardState = async (card, newState) => {
  const token = localStorage.getItem('token')  // Récupérer le token du localStorage

  if (!token) {
    console.error("Utilisateur non authentifié")
    return
  }

  try {
    const response = await api.patch(`/cards/${card.id}`, {
      state: newState
    }, {
      headers: {
        'Authorization': `Bearer ${token}`  // Envoie le token JWT dans l'en-tête
      }
    })

    // Met à jour l'état de la carte dans la vue
    const updatedCard = response.data
    const index = cards.value.findIndex(c => c.id === updatedCard.id)
    if (index !== -1) {
      cards.value[index] = updatedCard
    }
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'état de la carte :', error)
  }
}

  </script>
  
  <style scoped>
  .main-content {
    margin-left: 250px; /* Espace pour la sidebar */
    padding: 20px;
  }
  </style>
  