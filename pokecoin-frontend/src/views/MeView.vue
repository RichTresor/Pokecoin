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
        <h1 class="text-center text-danger mb-5">Bienvenue, {{ user?.username }}</h1>
        <p class="text-muted text-center">Gérez vos cartes et achats Pokémon ici !</p>

        <!-- Aperçu des cartes -->
        <div class="mt-5">
          <h3>Mes cartes</h3>

          <!-- Liste des cartes (afficher les 3 premières) -->
          <div class="row row-cols-1 row-cols-md-3 g-4">
            <div v-for="card in userCards.slice(0, 3)" :key="card.id" class="col">
              <div class="card-top shadow-sm">
                <div
                  class="card-img-wrapper mb-3 overflow-hidden rounded-3 d-flex justify-content-center align-items-center"
                  @click="openModal(card.image_url)"
                >
                  <img :src="'/images/' + card.image_url" class="card-img-top img-fluid mt-3" alt="Image de la carte" />
                </div>
                <div class="card-body">
                  <h5 class="card-title text-center">{{ card.name }}</h5>
                  <p class="card-text text-muted text-center">Rareté : <span class="text-primary">{{ card.rarity }}</span></p>
                  <p class="card-text text-center mb-3">Dernier prix : <strong class="text-success">{{ card.last_price }} USD</strong></p>
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

  <!-- Modale pour afficher l'image en grand -->
  <div v-if="isModalOpen" class="modal-overlay" @click="closeModal">
    <div class="modal-content">
      <img :src="'/images/' + selectedImage" alt="Image agrandie" class="modal-image" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/AppNavbar.vue'
import Sidebar from '@/components/AppSideBar.vue'
import api from '@/services/api'

const user = ref(null)
const userCards = ref([]) // Pour stocker les cartes de l'utilisateur
const isModalOpen = ref(false) // État de la modale
const selectedImage = ref(null) // Image sélectionnée pour la modale
const router = useRouter()

// Ouvrir la modale avec l'image sélectionnée
const openModal = (imageUrl) => {
  selectedImage.value = imageUrl
  isModalOpen.value = true
}

// Fermer la modale
const closeModal = () => {
  isModalOpen.value = false
  selectedImage.value = null
}

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  const token = localStorage.getItem('token')

  if (!token || !storedUser) {
    router.push('/login') // Redirige si non connecté
    return
  }

  user.value = JSON.parse(storedUser)

  // Récupérer les cartes de l'utilisateur depuis l'API
  try {
    const response = await api.get('/cards', {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    // Filtrer les cartes de l'utilisateur connecté
    userCards.value = response.data.filter((card) => card.user_id === user.value.id)
  } catch (error) {
    console.error('Erreur lors de la récupération des cartes :', error)
  }
})

const goToMyCards = () => {
  router.push('/my-cards') // Redirige vers la page des cartes
}
</script>

<style scoped>
.main-content {
  margin-left: 250px;
  padding: 20px;
}

.card-top {
  border-radius: 15px; /* Bords arrondis */
  overflow: hidden; /* Assure que le contenu respecte les bords arrondis */
  transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transition pour l'effet de survol */
}

.card-top:hover {
  transform: scale(1.05); /* Agrandit légèrement la carte au survol */
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2); /* Ajoute une ombre au survol */
}

.card-img-wrapper {
  border-radius: 15px; /* Bords arrondis pour l'image */
  overflow: hidden; /* Cache les débordements */
  cursor: pointer; /* Change le curseur pour indiquer que l'image est cliquable */
}

.card-img-top {
  height: 150px; /* Réduit la hauteur des images */
  width: auto; /* Garde les proportions */
  object-fit: cover; /* Ajuste l'image pour qu'elle s'adapte à la nouvelle taille */
  transition: transform 0.3s ease; /* Transition pour l'effet de survol */
}

.card-img-wrapper:hover .card-img-top {
  transform: scale(1.1); /* Agrandit légèrement l'image au survol */
}

/* Styles pour la modale */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  max-width: 90%;
  max-height: 90%;
}

.modal-image {
  width: 30%;
  height: auto;
  border-radius: 10px;
}
</style>