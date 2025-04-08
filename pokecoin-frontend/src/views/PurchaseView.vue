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
          <h1 class="text-center text-danger mb-5">Faire des achats</h1>
  
          <!-- Affichage des cartes -->
          <div class="row row-cols-1 row-cols-md-3 g-4">
            <div v-for="card in cards" :key="card.id" class="col">
              <div class="card-top h-100 shadow-sm">
                <div
                  class="card-img-wrapper mb-3 overflow-hidden rounded-3 d-flex justify-content-center align-items-center"
                  @click="openModal(card.image_url)"
                >
                  <!-- Image de la carte avec taille limitée -->
                  <img :src="'/images/' + card.image_url" class="card-img-top img-fluid mt-3" alt="Image de la carte" />
                </div>
  
                <div class="card-body">
                  <h5 class="card-title text-dark text-center">{{ card.name }}</h5>
                  <p class="card-text text-muted text-center">Rareté : <span class="text-primary">{{ card.rarity }}</span></p>
                  <p class="card-text text-center">Prix : <strong class="text-success">{{ card.last_price }} USD</strong></p>
  
                  <!-- Bouton acheter -->
                  <div class="d-flex justify-content-center">
                    <button class="btn btn-success mb-3" @click="confirmPurchase(card)">Acheter</button>
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
  
    <!-- Modale de confirmation pour l'achat -->
    <div v-if="showConfirmation" class="modal-overlay">
      <div class="modal-content confirmation-modal">
        <h5 class="modal-title text-center mb-4">Confirmer l'achat</h5>
        <p class="text-center">Êtes-vous sûr de vouloir acheter cette carte pour <strong>{{ selectedCard.last_price }} USD</strong> ?</p>
        <div class="d-flex justify-content-center mt-4">
          <button class="btn btn-secondary me-3" @click="showConfirmation = false">Annuler</button>
          <button class="btn btn-primary" @click="buyCard(selectedCard)">Confirmer</button>
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
  const cards = ref([]) // Pour stocker les cartes disponibles à la vente
  const selectedCard = ref(null) // Carte sélectionnée pour l'achat
  const showConfirmation = ref(false) // Afficher ou non la fenêtre de confirmation
  const isModalOpen = ref(false) // État de la modale
  const selectedImage = ref(null) // Image sélectionnée pour la modale
  const router = useRouter()
  
  // Charger les cartes disponibles à la vente
  const loadCards = async () => {
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
      const response = await api.get('/cards', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      // Récupérer uniquement les cartes disponibles à la vente
      cards.value = response.data.filter((card) => card.state === 'à vendre' && card.user_id !== user.value.id)
    } catch (error) {
      console.error(error)
    }
  }
  
  // Appeler `loadCards` pour charger les cartes dès le montage du composant
  onMounted(loadCards)
  
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
  
  const confirmPurchase = (card) => {
    selectedCard.value = card
    showConfirmation.value = true // Affiche la fenêtre de confirmation
  }
  
  const buyCard = async (card) => {
    try {
      const token = localStorage.getItem('token')
      await api.post(`/cards/${card.id}/buy`, {}, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
  
      // Ferme la fenêtre de confirmation et affiche le message de succès
      showConfirmation.value = false
      alert('Achat réussi !')
  
      // Rafraîchir les cartes après l'achat
      loadCards()
  
      // Mettre à jour le solde de l'utilisateur dans localStorage et user.value
      const updatedUser = { ...user.value, balance: user.value.balance - card.last_price }
      localStorage.setItem('user', JSON.stringify(updatedUser))
      user.value = updatedUser // Mettre à jour le ref `user` avec les nouvelles données
    } catch (error) {
      console.error("Erreur lors de l'achat de la carte :", error)
      alert("Une erreur est survenue lors de l'achat.")
    }
  }
  </script>
  
  <style scoped>
  .main-content {
    margin-left: 250px; /* Espace pour la sidebar */
    padding: 20px;
  }
  
  .card-top {
    border-radius: 15px; /* Bords arrondis */
    overflow: hidden; /* Assure que le contenu respecte les bords arrondis */
    transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transition pour l'effet de survol */
    animation: fadeIn 0.5s ease; /* Animation pour le motion */
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
    background: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    animation: fadeIn 0.3s ease;
  }
  
  .modal-image {
    width: 30%;
    height: auto;
    border-radius: 10px;
  }
  
  /* Animation pour le motion */
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  </style>