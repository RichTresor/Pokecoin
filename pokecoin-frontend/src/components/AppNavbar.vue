<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container-fluid">
      <div class="d-flex justify-content-between w-100">
        <span class="navbar-brand text-danger">PokéCoin</span>

        <div class="d-flex align-items-center">
          <img :src=" '/images/profil.jpeg'" class="rounded-circle" width="40" height="40" alt="Profile">
          <button class="btn btn-outline-danger ms-3" @click="logout">Déconnexion</button>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()
// eslint-disable-next-line no-unused-vars
const user = localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')) : null

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')  // Redirige vers la page de connexion après la déconnexion
}
</script>

<style scoped>
.navbar {
  border-bottom: 2px solid #ef4444;
}
</style>
