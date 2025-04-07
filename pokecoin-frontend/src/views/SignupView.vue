<template>
    <div class="min-vh-100 d-flex flex-column justify-content-center align-items-center bg-white text-center p-4">
      <div class="w-100" style="max-width: 400px;">
        <h2 class="mb-4 text-warning">Inscription 📝</h2>
        <form @submit.prevent="handleSignup">
          <div class="mb-3 text-start">
            <label for="username" class="form-label">Nom d'utilisateur</label>
            <input v-model="username" type="text" class="form-control" id="username" required />
          </div>
          <div class="mb-3 text-start">
            <label for="email" class="form-label">Email</label>
            <input v-model="email" type="email" class="form-control" id="email" required />
          </div>
          <div class="mb-3 text-start">
            <label for="password" class="form-label">Mot de passe</label>
            <input v-model="password" type="password" class="form-control" id="password" required />
          </div>
          <div class="mb-3 text-start">
            <label for="confirmPassword" class="form-label">Confirmation</label>
            <input v-model="confirmPassword" type="password" class="form-control" id="confirmPassword" required />
          </div>
          <button type="submit" class="btn btn-warning w-100 mt-3 text-white">S’inscrire</button>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
import api from '@/services/api'
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const username = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')

const router = useRouter()

const handleSignup = async () => {
  if (password.value !== confirmPassword.value) {
    alert('Les mots de passe ne correspondent pas')
    return
  }

  try {
    const response = await api.post('/signup', {
      username: username.value,
      email: email.value,
      password: password.value,
      password_confirmation: confirmPassword.value,
    })

    const token = response.data.token
    const userData = response.data.user

    localStorage.setItem('token', token)
    localStorage.setItem('user', JSON.stringify(userData))

    alert('Compte créé avec succès 🎉')
    router.push('/me') // ✅ Redirection immédiate
  } catch (error) {
    alert("Erreur lors de l'inscription")
    console.error(error)
  }
}
  </script>
  