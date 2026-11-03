// main.ts
// import './assets/main.css'
import './assets/styles/index.css'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import { useAuthStore } from './stores/auth'
import axios from 'axios'
import router from './router'

import { Icon } from '@iconify/vue'

axios.defaults.baseURL = import.meta.env.VITE_API_URL || 'https://kokkhopoth.com' // Set your Laravel backend URL
axios.defaults.withCredentials = true // Enable sending cookies with requests

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.component('Icon', Icon)
app.mount('#app')

// Initialize the auth store after app is mounted
const authStore = useAuthStore()
authStore.initialize()
