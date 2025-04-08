<template>
  <div class="sidebar bg-dark text-white p-3">
    <div class="mb-4 text-center">
      <h5 class="mt-2">{{ user?.username }}</h5>
    </div>
 
    <div class="d-flex flex-column">
      <button class="btn btn-outline-light mb-3" @click="goToMyCards">Voir mes cartes</button>
      <button class="btn btn-outline-light mb-3" @click="goToPurchases">Faire des achats</button>
      <button class="btn btn-outline-light mb-3" @click="goToTransactions">Transactions</button>
      <p class="text-white mt-3">Solde : <strong class="text-success">{{ user?.balance }} USD</strong></p> 
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
    user.value = JSON.parse(storedUser)  // Récupérer les informations utilisateur depuis le localStorage
  }
})

const goToMyCards = () => {
  router.push('/my-cards')  // Redirige vers la page des cartes
}

const goToPurchases = () => {
  router.push('/purchase') // Logique pour aller à la page des achats
}

const goToTransactions = () => {
  router.push('/transaction') // Logique pour aller à la page des achats
}
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  position: fixed;
  left: 0;
}

.main-content {
  margin-left: 250px; /* Espace pour la sidebar */
  padding: 20px;
}

.sidebar img {
  object-fit: cover;
  margin-bottom: 20px;
}
</style>
