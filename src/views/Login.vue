<template>
  <div class="login_view">

    <!-- login form -->
    <form
      v-if="!logged_in"
      v-on:submit.prevent="login()">

      <div class="">
        <label>Username / email</label>
        <input type="text" v-model="input_data.identifier">
      </div>

      <div class="">
        <label>Password</label>
        <input type="password" v-model="input_data.password">
      </div>

      <input type="submit" v-bind:value="login_button_text">

      <span class="error_message">{{error_message}}</span>

    </form>

    <!-- logout form -->
    <form
      v-else
      v-on:submit.prevent="logout()">
      <div class="">Logged in as {{username}}</div>
      <!-- submit input had a bug not showing the value -->
      <input type="submit" value="logout">
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
        identifier: "",
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

      this.axios.post(`${process.env.VUE_APP_AUTHENTICATION_API_URL}/login`, {
        identifier: this.input_data.identifier,
        password: this.input_data.password
      })
      .then(response => {


        this.error_message = null;

        // save the cookie
        this.$cookies.set("jwt", response.data.jwt, '14d', null, process.env.VUE_APP_COOKIE_DOMAIN)

        // If successful login, redirect to desired app when done
        if(document.referrer) window.location.href = document.referrer

        // If no app to redirect to, simply reload (not very elegant)
        else location.reload()

      })
      .catch(error => { this.error_message = error.response.data })
      .finally(() => {this.logging_in = false})
    },
    logout(){
      //this.$cookies.remove('jwt', null, process.env.VUE_APP_COOKIE_DOMAIN)
      this.$cookies.remove('jwt')

      // Not very elegant
      location.reload()
    },
    get_username_if_logged_in(){
      if(this.$cookies.get('jwt')) {
        this.axios.post(process.env.VUE_APP_AUTHENTICATION_API_URL + "/whoami", {}, {
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
.login_view {

}

form {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  font-size: 120%;
}

form > * {
  margin: 1em 0;
}

form > div {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

form label {
  color: #666666;
  font-size: 75%;
}



.error_message {
  color: #c00000;
}

input, button {
  width: 50vw;
  max-width: 500px;
  font-size: 100%;
  padding: 0.25em;
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
