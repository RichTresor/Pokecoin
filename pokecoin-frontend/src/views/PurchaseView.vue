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
              <div class="card-top h-100 shadow-sm">
                <div class="card-img-wrapper mb-3 overflow-hidden rounded-3">
                  <!-- Image de la carte avec taille limitée via Bootstrap -->
                  <img :src="'/images/' + card.image_url" class="card-img-top img-fluid" alt="Image de la carte" />
                </div>
  
                <div class="card-body">
                  <h5 class="card-title text-dark text-center">{{ card.name }}</h5>
                  <p class="card-text text-muted text-center">Rareté : <span class="text-primary">{{ card.rarity }}</span></p>
                  <p class="card-text text-center">Prix : <strong class="text-success">{{ card.last_price }} USD</strong></p>
  
                  <!-- Bouton acheter si la carte est "à vendre" et sans propriétaire -->
                  <div>
                    <div class="d-flex justify-content-center">
                      <button class="btn btn-success" @click="confirmPurchase(card)">Acheter</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  
    <!-- Modal de confirmation -->
    <div v-if="showConfirmation" class="modal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="confirmationModalLabel">Confirmer l'achat</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="showConfirmation = false">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p>Êtes-vous sûr de vouloir acheter cette carte pour {{ selectedCard.last_price }} USD ?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="showConfirmation = false">Annuler</button>
            <button type="button" class="btn btn-primary" @click="buyCard(selectedCard)">Confirmer</button>
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
  const selectedCard = ref(null)  // Carte sélectionnée pour l'achat
  const showConfirmation = ref(false)  // Afficher ou non la fenêtre de confirmation
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
      const response = await api.get('/cards', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
      cards.value = response.data.filter(card => card.state === 'à vendre' && card.user_id !== user.value.id)
    } catch (error) {
      console.error(error)
    }
  })
  
  const confirmPurchase = (card) => {
    selectedCard.value = card
    showConfirmation.value = true  // Affiche la fenêtre de confirmation
  }
  
  const buyCard = async (card) => {
    try {
      const token = localStorage.getItem('token')
      await api.post(`/cards/${card.id}/buy`, {}, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
  
      // Ferme la fenêtre de confirmation et affiche le message de succès
      showConfirmation.value = false
      alert("Achat réussi !")
  
      // Actualiser l'affichage des cartes
      onMounted()
  
    } catch (error) {
      console.error('Erreur lors de l\'achat de la carte :', error)
      alert("Une erreur est survenue lors de l'achat.")
    }
  }
  </script>
  
  <style scoped>
  .main-content {
    margin-left: 250px; /* Espace pour la sidebar */
    padding: 20px;
  }
  
  .modal {
    display: block;
  }
  </style>
  