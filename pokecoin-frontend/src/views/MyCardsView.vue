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
        <h1 class="text-center text-danger mb-5">Toutes mes cartes Pokémon 🃏</h1>

        <!-- Affichage des cartes -->
        <div class="row row-cols-1 row-cols-md-3 g-4">
          <div v-for="card in cards" :key="card.id" class="col">
            <div class="card-top h-100 shadow-sm rounded-3 hover-effect">
              <!-- Ajout de la classe hover-effect -->
              <div
                class="card-img-wrapper mb-3 mt-3 overflow-hidden rounded-3 d-flex justify-content-center align-items-center"
                @click="openModal(card.image_url)"
              >
                <img :src="'/images/' + card.image_url" class="card-img-top img-fluid mt-3" alt="Image de la carte" />
              </div>

              <div class="card-body">
                <h5 class="card-title text-dark text-center">{{ card.name }}</h5>
                <p class="card-text text-muted text-center">Rareté : <span class="text-primary">{{ card.rarity }}</span></p>
                <p class="card-text text-center">Dernier prix : <strong class="text-success">{{ card.last_price }} USD</strong></p>

                <!-- Affichage et gestion du bouton "Vendre" / "Annuler la vente" -->
                <div class="d-flex justify-content-center mt-3" v-if="card.state === 'non à vendre' ">
                  <button class="btn btn-warning" @click="changeCardState(card, 'à vendre')">Vendre</button>
                </div>
                <div class="d-flex justify-content-center mt-3" v-else-if="card.state === 'à vendre'">
                  <button class="btn btn-danger" @click="changeCardState(card, 'non à vendre')">Annuler la vente</button>
                </div>
              </div>
            </div>
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
import api from '@/services/api'
import Navbar from '@/components/AppNavbar.vue'
import Sidebar from '@/components/AppSidebar.vue'

const user = ref(null)
const cards = ref([]) // Pour stocker les cartes de l'utilisateur
const router = useRouter()

// Variables pour la modale
const isModalOpen = ref(false)
const selectedImage = ref(null)

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
  const token = localStorage.getItem('token')
  if (!token) {
    router.push('/login') // Redirige si non connecté
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
        Authorization: `Bearer ${token}`,
      },
    })
    // Filtrer les cartes pour n'afficher que celles de l'utilisateur connecté
    cards.value = response.data.filter((card) => card.user_id === user.value.id)
  } catch (error) {
    console.error(error)
  }
})

// Méthode pour changer l'état d'une carte
const changeCardState = async (card, newState) => {
  const token = localStorage.getItem('token') // Récupérer le token du localStorage

  if (!token) {
    console.error('Utilisateur non authentifié')
    return
  }

  try {
    const response = await api.patch(
      `/cards/${card.id}`,
      {
        state: newState,
      },
      {
        headers: {
          Authorization: `Bearer ${token}`, // Envoie le token JWT dans l'en-tête
        },
      }
    )

    // Met à jour l'état de la carte dans la vue
    const updatedCard = response.data
    const index = cards.value.findIndex((c) => c.id === updatedCard.id)
    if (index !== -1) {
      cards.value[index] = updatedCard
    }
  } catch (error) {
    console.error("Erreur lors de la mise à jour de l'état de la carte :", error)
  }
}
</script>

<style scoped>
.main-content {
  margin-left: 250px; /* Espace pour la sidebar */
  padding: 20px;
  opacity: 0; /* Commence avec une opacité de 0 */
  transform: translateY(20px); /* Décale légèrement vers le bas */
  animation: fadeIn 0.6s ease forwards; /* Animation de fondu */
}

@keyframes fadeIn {
  to {
    opacity: 1; /* Opacité finale */
    transform: translateY(0); /* Position finale */
  }
}

.card-top {
  transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transition pour l'effet de survol */
}

.card-top:hover {
  transform: scale(1.05); /* Agrandit légèrement la carte */
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2); /* Ajoute une ombre */
}

.card-img-wrapper {
  max-height: 150px; /* Limite la hauteur du conteneur de l'image */
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