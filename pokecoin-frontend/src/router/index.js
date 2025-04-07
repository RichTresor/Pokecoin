import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import MeView from '../views/MeView.vue'
import MyCardsView from '../views/MyCardsView.vue'
import PurchaseView from '../views/PurchaseView.vue' 

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/LoginView.vue')
  },
  {
    path: '/signup',
    name: 'signup',
    component: () => import('../views/SignupView.vue')
  },
  { path: '/me', name: 'me', component: MeView },
  {
    path: '/my-cards',
    name: 'my-cards',
    component: MyCardsView
  },
  {
    path: '/purchase',  // Définir la route pour la page "Faire des achats"
    name: 'purchase',
    component: PurchaseView  // Associe la vue PurchaseView à cette route
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
