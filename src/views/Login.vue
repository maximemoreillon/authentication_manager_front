<template>
  <div class="login_view">

    <form
      v-if="!logged_in"
      v-on:submit.prevent="login()">
      <input type="text" v-model="input_data.username" placeholder="username">
      <input type="password" v-model="input_data.password" placeholder="password">
      <input type="submit" v-bind:value="login_button_text">
      <div class="error_message">{{error_message}}</div>

    </form>

    <form
      v-else
      v-on:submit.prevent="logout()">
      <div class="">Logged in as {{username}}</div>
      <!-- submit input had a bug not showing the value -->
      <button type="button" v-on:click="logout()">Logout</button>
    </form>

  </div>
</template>

<script>
// @ is an alias to /src

export default {
  name: 'Login',
  components: {

  },
  data(){
    return{

      input_data: {
        username: "",
        password: "",
      },

      username: '',
      logging_in: false,
      error_message: "",

    }
  },
  mounted(){
    this.get_username_if_logged_in()

  },
  methods: {

    login(){
      this.logging_in = true;
      this.error_message = "";

      this.axios.post(process.env.VUE_APP_API_URL + "/login", {
        username: this.input_data.username,
        password: this.input_data.password
      })
      .then(response => {

        this.logging_in = false;
        this.error_message = null;

        // save the cookie
        this.$cookies.set("jwt", response.data.jwt, '14d', null, process.env.VUE_APP_COOKIE_DOMAIN)

        // If successful login, redirect to desired app when done
        if(document.referrer) window.location.href = document.referrer

        // If no app to redirect to, simply reload (not very elegant)
        else location.reload()

      })
      .catch(error => { this.error_message = error.response.data })
    },
    logout(){
      this.$cookies.remove('jwt', null, process.env.VUE_APP_COOKIE_DOMAIN)

      // Not very elegant
      location.reload()
    },
    get_username_if_logged_in(){
      if(this.$cookies.get('jwt')) {
        this.axios.post(process.env.VUE_APP_API_URL + "/whoami", {}, {
          headers: { Authorization: "Bearer " + this.$cookies.get('jwt') }
        })

        .then(response => {
          this.username = response.data.properties.username
        })
        .catch(error => { alert(error.response.data) })
      }
    }
  },
  computed: {
    login_button_text(){
      if(this.logging_in) return "Logging in..."
      else return "Login"
    },
    logged_in(){
      // this will not work
      if(this.$cookies.get('jwt')) return true
      else return false
    }
  }

}
</script>

<style scoped>

form {
  display: flex;
  flex-direction: column;
  align-items: center;
}

form > * {
  margin: 10px;
  padding: 10px;
  width: 250px;
  text-align: center;
}

.error_message {
  color: #c00000;
}

.button_icon{
  cursor: pointer;
}

input[type="text"],input[type="password"] {
  outline: none;
  border: none;
  border-bottom: 2px solid #444444;
  transition: border-color 0.25s;
}

input[type="text"]:focus,input[type="password"]:focus {
  border-bottom: 2px solid #c00000;
}

input[type="submit"], button {
  border: 2px solid #444444;
  background-color: white;
  color: #444444;
  transition: border-color 0.25s;
  cursor: pointer;
}

input[type="submit"]:hover, button:hover {
  border: 2px solid #c00000;
}


</style>
