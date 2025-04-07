<template>
    <div class="min-vh-100 d-flex flex-column justify-content-center align-items-center bg-white text-center p-4">
      <div class="w-100" style="max-width: 400px;">
        <h2 class="mb-4 text-danger">Connexion 🔐</h2>
        <form @submit.prevent="handleLogin">
          <div class="mb-3 text-start">
            <label for="email" class="form-label">Email</label>
            <input v-model="email" type="email" class="form-control" id="email" required />
          </div>
          <div class="mb-3 text-start">
            <label for="password" class="form-label">Mot de passe</label>
            <input v-model="password" type="password" class="form-control" id="password" required />
          </div>
          <button type="submit" class="btn btn-danger w-100 mt-3">Se connecter</button>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
    import api from '@/services/api'
    import { ref } from 'vue'
    import { useRouter } from 'vue-router'

    const email = ref('')
    const password = ref('')
    const router = useRouter()

    const handleLogin = async () => {
  try {
    const response = await api.post('/login', {
      email: email.value,
      password: password.value,
    })

    const token = response.data.token
    const userData = response.data.user

    localStorage.setItem('token', token)
    localStorage.setItem('user', JSON.stringify(userData))

    alert('Connexion réussie ✅')
    router.push('/me')
  } catch (error) {
    alert('Erreur de connexion ❌')
    console.error(error)
  }
}

  </script>
  