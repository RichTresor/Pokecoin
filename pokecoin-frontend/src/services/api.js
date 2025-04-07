import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:3000', // L’URL de ton backend Rails
  headers: {
    'Content-Type': 'application/json',
  },
})

export default api
