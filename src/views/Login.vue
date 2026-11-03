<template>
  <div class="min-h-screen flex items-stretch bg-gray-100">
    <!-- Left Side: Welcome Section -->
    <div
      class="hidden md:flex flex-col items-center justify-center bg-gradient-to-b from-blue-500 to-green-400 w-1/2 p-10 text-white"
    >
      <h1 class="text-5xl font-bold mb-6">Welcome to Kokkhopoth</h1>
      <p class="text-xl mb-10 text-center">
        Embark on your coding journey with our engaging and comprehensive programming courses
        tailored just for students!
      </p>
      <img
        src="../assets/img/login-banner.png"
        class="w-96 h-96 object-cover rounded-lg shadow-lg"
      />
    </div>

    <!-- Right Side: Login Form -->
    <div class="flex flex-col items-center justify-center p-16 bg-white w-full md:w-1/2">
      <h2 class="text-4xl font-semibold mb-10 text-gray-800">Login to Your Account</h2>
      <form @submit.prevent="login" class="w-full max-w-md">
        <div class="flex flex-col mb-6">
          <label for="email" class="mb-2 text-sm font-semibold text-gray-700">Email</label>
          <input
            id="email"
            class="border border-gray-300 py-3 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
            v-model="email"
            type="email"
            placeholder="Enter your email"
            required
          />
        </div>
        <div class="flex flex-col mb-8">
          <label for="password" class="mb-2 text-sm font-semibold text-gray-700">Password</label>
          <input
            id="password"
            class="border border-gray-300 py-3 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
            v-model="password"
            type="password"
            placeholder="Enter your password"
            required
          />
        </div>
        <button
          class="w-full py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition duration-300 ease-in-out transform hover:scale-105 flex items-center justify-center"
          type="submit"
          :disabled="isLoading"
        >
          <span
            v-if="isLoading"
            class="animate-spin h-5 w-5 border-2 border-t-2 border-t-transparent border-white rounded-full mr-2"
          ></span>
          <span v-if="!isLoading">Login</span>
          <span v-if="isLoading">Loading...</span>
        </button>
      </form>
      <p v-if="errorMessage" class="mt-6 text-center text-red-500">{{ errorMessage }}</p>
      <div class="mt-8 text-center">
        <a href="#" class="text-sm text-blue-500 hover:underline">Forgot your password?</a>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const email = ref<string>('')
const password = ref<string>('')
const errorMessage = ref<string>('')
const isLoading = ref<boolean>(false)

const login = async () => {
  isLoading.value = true
  errorMessage.value = '' // Clear previous errors
  try {
    await authStore.login(email.value, password.value)
    // Redirect or perform additional actions after successful login
  } catch (error) {
    errorMessage.value = 'Failed to login. Please check your credentials.'
  } finally {
    isLoading.value = false // Stop loading regardless of success or failure
  }
}
</script>
