<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-yellow-100 to-red-200 px-4">
    <div class="text-center flex flex-col items-center">
      <!-- IMAGE réduite -->
      <img
        src="/pokecoin.jpeg"
        alt="PokéCoin Hero"
        class="w-20 h-auto mb-6 rounded-xl shadow-lg"
      />

      <!-- TITRE -->
      <h1 class="text-4xl font-bold mb-2">Bienvenue sur PokéCoin 🪙</h1>
      <p class="mb-6 text-lg text-gray-700">La marketplace de cartes Pokémon virtuelles</p>

      <!-- BOUTONS -->
      <div class="flex gap-4">
        <router-link
          to="/login"
          class="px-6 py-2 bg-red-500 text-white rounded-xl hover:bg-red-600 transition"
        >
          Se connecter
        </router-link>
        <router-link
          to="/signup"
          class="px-6 py-2 bg-red-500 text-white rounded-xl hover:bg-red-600 transition"
        >
          S’inscrire
        </router-link>
      </div>
    </div>
  </div>
</template>
