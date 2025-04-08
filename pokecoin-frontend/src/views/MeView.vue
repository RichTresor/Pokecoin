<template>
    <div class="d-flex">
      <!-- Sidebar only if the user is logged in -->
      <Sidebar v-if="user" />
  
      <!-- Main Content -->
      <div class="main-content flex-grow-1">
        <!-- Navbar only if the user is logged in -->
        <Navbar v-if="user" />
  
        <!-- Page Content -->
        <div class="container mt-5">
          <h1 class="text-center text-danger mb-5">Bienvenue, {{ user?.username }} </h1>
          <p class="text-muted text-center">Gérez vos cartes et achats Pokémon ici !</p>
  
          <!-- Aperçu des cartes -->
          <div class="mt-5">
            <h3>Mes cartes</h3>
  
            <!-- Liste des cartes (afficher les 3 premières) -->
            <div class="row row-cols-1 row-cols-md-3 g-4">
              <div v-for="card in userCards.slice(0, 3)" :key="card.id" class="col">
                <div class="card-top shadow-sm">
                  <img :src="'/images/' + card.image_url" class="card-img-top" alt="Image de la carte" />
                  <div class="card-body">
                    <h5 class="card-title">{{ card.name }}</h5>
                    <p class="card-text text-muted">Rareté : <span class="text-primary">{{ card.rarity }}</span></p>
                    <p class="card-text">Dernier prix : <strong class="text-success">{{ card.last_price }} USD</strong></p>
                  </div>
                </div>
              </div>
            </div>
  
            <!-- Bouton pour voir toutes les cartes -->
            <div class="mt-3">
              <button class="btn btn-primary" @click="goToMyCards">Voir toutes mes cartes</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import Navbar from '@/components/AppNavbar.vue'
  import Sidebar from '@/components/AppSidebar.vue'
  import api from '@/services/api' // Import the API service
  
  const user = ref(null)
  const userCards = ref([])  // Pour stocker les cartes de l'utilisateur
  const router = useRouter()
  
  onMounted(async () => {
    const storedUser = localStorage.getItem('user')
    const token = localStorage.getItem('token')
  
    if (!token || !storedUser) {
      router.push('/login')  // Redirige si non connecté
      return
    }
  
    user.value = JSON.parse(storedUser)
  
    // Récupérer les cartes de l'utilisateur depuis l'API
    try {
      const response = await api.get('/cards', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
      // Filtrer les cartes de l'utilisateur connecté
      userCards.value = response.data.filter(card => card.user_id === user.value.id)
    } catch (error) {
      console.error('Erreur lors de la récupération des cartes :', error)
    }
  })
  
  const goToMyCards = () => {
    router.push('/my-cards')  // Redirige vers la page des cartes
  }
  </script>
  
  <style scoped>
  .main-content {
    margin-left: 250px;
    padding: 20px;
  }
  .card-img-top {
  max-width: 200px;  /* Limite la largeur maximale de l'image */
  max-height: 300px; /* Limite la hauteur maximale de l'image */
}
.card-top {
  max-width: 200px;  /* Limite la largeur maximale de l'image */
  max-height: 600px; /* Limite la hauteur maximale de l'image */
}
  </style>
  