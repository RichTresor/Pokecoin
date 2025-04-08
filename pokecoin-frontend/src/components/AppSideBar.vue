<template>
  <div class="sidebar bg-dark text-white d-flex flex-column align-items-center p-4">
    <!-- Profil utilisateur -->
    <div class="user-info text-center mb-4">
    
      <h5 class="mt-2">{{ user?.username }}</h5>
      <p class="text-muted">Solde : <strong class="text-success">{{ user?.balance }} USD</strong></p>
    </div>

    <!-- Navigation -->
    <div class="nav-buttons w-100">
      <button class="btn btn-outline-light w-100 mb-3 d-flex align-items-center" @click="goToMyCards">
        <i class="bi bi-card-list me-2"></i> Voir mes cartes
      </button>
      <button class="btn btn-outline-light w-100 mb-3 d-flex align-items-center" @click="goToPurchases">
        <i class="bi bi-cart me-2"></i> Faire des achats
      </button>
      <button class="btn btn-outline-light w-100 mb-3 d-flex align-items-center" @click="goToTransactions">
        <i class="bi bi-clock-history me-2"></i> Transactions
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const user = ref(null)
const router = useRouter()

// Charger l'utilisateur depuis le localStorage
onMounted(() => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    user.value = JSON.parse(storedUser) // Récupérer les informations utilisateur depuis le localStorage
  }
})

const goToMyCards = () => {
  router.push('/my-cards') // Redirige vers la page des cartes
}

const goToPurchases = () => {
  router.push('/purchase') // Logique pour aller à la page des achats
}

const goToTransactions = () => {
  router.push('/transaction') // Logique pour aller à la page des transactions
}
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  position: fixed;
  left: 0;
  top: 0;
  background-color: #343a40; /* Couleur de fond sombre */
  color: #fff;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.user-info img {
  border: 2px solid #fff; /* Bordure blanche autour de l'avatar */
}

.user-info h5 {
  margin: 0;
  font-size: 1.2rem;
}

.user-info p {
  font-size: 0.9rem;
}

.nav-buttons button {
  font-size: 1rem;
  text-align: left;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

.nav-buttons button i {
  font-size: 1.2rem;
}

.nav-buttons button:hover {
  background-color: #495057; /* Couleur de survol */
  color: #fff;
}
</style>