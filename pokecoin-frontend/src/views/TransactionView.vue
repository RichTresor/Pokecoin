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
          <h2 class="text-danger">Mes Transactions</h2>
  
          <!-- Affichage des transactions -->
          <div class="table-responsive">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th scope="col">Date</th>
                  <th scope="col">Carte</th>
                  <th scope="col">Nom du vendeur</th>
                  <th scope="col">Prix</th>
                  <th scope="col">Type</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="transaction in transactions || []" :key="transaction.id">
                  <td>{{ transaction.transaction_date || 'N/A' }}</td>
                  <td>{{ transaction.card_name || 'N/A' }}</td>
                  <td>{{ transaction.seller_name || 'N/A' }}</td>
                  <td>{{ transaction.amount ? transaction.amount + ' USD' : 'N/A' }}</td>
                  <td>
                    <span v-if="user && transaction.buyer_id === user.id">Achat</span>
                    <span v-else>Vente</span>
                  </td>
                </tr>
              </tbody>
            </table>
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
  const transactions = ref([])  // Pour stocker les transactions de l'utilisateur
  const router = useRouter()
  
  // Charger les informations de l'utilisateur depuis l'API
  const loadUserData = async () => {
    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')
      return
    }
  
    try {
      const response = await api.get('/user', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      user.value = response.data
    } catch (error) {
      console.error("Erreur lors du chargement des informations utilisateur :", error)
    }
  }
  
  // Charger les transactions de l'utilisateur
  const loadTransactions = async () => {
    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')
      return
    }
  
    try {
      const response = await api.get('/transactions', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      transactions.value = response.data
    } catch (error) {
      console.error("Erreur lors du chargement des transactions :", error)
    }
  }
  
  onMounted(() => {
    loadUserData()
    loadTransactions()
  })
</script>
  
  <style scoped>
  .main-content {
    margin-left: 250px;
    padding: 20px;
  }
  </style>
  