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
          <h1 class="text-center text-danger mb-5">Historique des Transactions</h1>
  
          <!-- Affichage des transactions -->
          <div class="table-responsive card transaction-card shadow-sm mb-4">
            <table class="table table-hover table-striped">
              <thead class="table-dark">
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
                  <td class="date-cell">{{ transaction.transaction_date || 'N/A' }}</td>
                  <td class="card-name-cell">{{ transaction.card_name || 'N/A' }}</td>
                  <td>{{ transaction.seller_name || 'N/A' }}</td>
                  <td class="text-success fw-bold">{{ transaction.amount ? transaction.amount + ' USD' : 'N/A' }}</td>
                  <td>
                    <span
                      v-if="user && transaction.buyer_id === user.id"
                      class="badge bg-success"
                    >
                      Achat
                    </span>
                    <span v-else class="badge bg-danger">Vente</span>
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
  import Sidebar from '@/components/AppSideBar.vue'
  
  const user = ref(null)
  const transactions = ref([]) // Pour stocker les transactions de l'utilisateur
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
        headers: { Authorization: `Bearer ${token}` },
      })
      user.value = response.data
    } catch (error) {
      console.error('Erreur lors du chargement des informations utilisateur :', error)
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
        headers: { Authorization: `Bearer ${token}` },
      })
      transactions.value = response.data
    } catch (error) {
      console.error('Erreur lors du chargement des transactions :', error)
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
  
  .transaction-card {
    border-radius: 15px;
    overflow: hidden;
  }
  
  .table {
    margin-bottom: 0;
  }
  
  .table-hover tbody tr:hover {
    background-color: #f8f9fa; /* Couleur de survol */
  }
  
  .table-striped tbody tr:nth-of-type(odd) {
    background-color: #f9f9f9; /* Couleur des lignes impaires */
  }
  
  .table-dark {
    background-color: #343a40;
    color: #fff;
  }
  
  .badge {
    font-size: 0.9rem;
    padding: 0.5em 0.75em;
  }
  
  .badge.bg-success {
    background-color: #28a745;
  }
  
  .badge.bg-danger {
    background-color: #dc3545;
  }
  
  .date-cell {
    font-weight: bold;
  }
  
  .card-name-cell {
    font-style: italic;
  }
  </style>