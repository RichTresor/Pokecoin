<template>
  <div class="min-vh-100 d-flex flex-column justify-content-center align-items-center bg-light text-center p-4">


    <!-- TITRE -->
    <h1 class="display-4 fw-bold text-danger mb-2">Bienvenue sur PokéCoin</h1>
    <img
      src="/pokecoin.jpeg"
      alt="PokéCoin Hero"
      class="img-fluid mb-4"
      style="max-width: 120px; border-radius: 1rem; box-shadow: 0 4px 10px rgba(0,0,0,0.1);"
    />
    <p class="lead text-dark mb-4">La marketplace de cartes Pokémon virtuelles</p>

    <!-- BOUTONS -->
    <div class="d-flex gap-3 flex-wrap justify-content-center">
      <router-link to="/login" class="btn btn-danger px-4">Se connecter</router-link>
      <router-link to="/signup" class="btn btn-warning text-white px-4">S’inscrire</router-link>
    </div>
  </div>
</template>
