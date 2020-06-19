<template>
  <div class="login_view">

    <!-- login form -->
    <div class="loader_wrapper" v-if="logging_in">
      <loader class="loader">Logging in</loader>
    </div>


    <template v-else>
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

        <input type="submit" value="Login">

        <span v-if="error_message"  class="error_message">{{error_message}}</span>

        <span v-if="credentials_hint" class="hint">{{credentials_hint}}</span>

      </form>

      <!-- logout form -->
      <form
        v-else
        v-on:submit.prevent="logout()">

        <template v-if="user">
          <div class="">Logged in as {{user.properties.display_name}}</div>
        </template>


        <!-- submit input had a bug not showing the value -->
        <div class="" v-if="redirecting">
          <loader class="loader" >redirecting...</loader>
        </div>

        <input type="submit" value="logout" v-else>

      </form>
    </template>



  </div>
</template>

<script>
// @ is an alias to /src
import loader from '@moreillon/vue_loader'

export default {
  name: 'Login',
  components: {
    loader,
  },
  data(){
    return{

      input_data: {
        identifier: "",
        password: "",
      },

      credentials_hint: process.env.VUE_APP_CREDENTIALS_HINT,

      logged_in: false,
      user: null,
      logging_in: false,
      error_message: "",

      redirecting: false,

    }
  },
  mounted(){
    this.check_if_logged_in()
    //this.get_username_if_logged_in()

  },
  methods: {

    login(){
      this.logging_in = true;
      this.error_message = null;

      this.axios.post(`${process.env.VUE_APP_AUTHENTICATION_API_URL}/login`, {
        identifier: this.input_data.identifier,
        password: this.input_data.password
      })
      .then(response => {
        // save the cookie
        this.$cookies.set("jwt", response.data.jwt, '14d', null, process.env.VUE_APP_COOKIE_DOMAIN)

        // If successful login, redirect to desired app when done
        if(document.referrer) {
          this.redirecting = true;
          setTimeout(() => {window.location.href = document.referrer}, 2000)
        }

        this.logged_in = true;

        this.get_user_info();

      })
      .catch(error => { this.error_message = error.response.data })
      .finally(() => { this.logging_in = false })
    },
    logout(){
      this.$cookies.remove('jwt', null, process.env.VUE_APP_COOKIE_DOMAIN)
      this.logged_in = false
    },
    check_if_logged_in(){
      if(this.$cookies.get('jwt')) {
        this.logged_in = true;
        this.get_user_info();
      }
    },
    get_user_info(){
      this.user = null;
      this.axios.post(`${process.env.VUE_APP_AUTHENTICATION_API_URL}/whoami`, {}, {
        headers: { Authorization: "Bearer " + this.$cookies.get('jwt') }
      })
      .then(response => {this.user = response.data})
      .catch(error => { console.error(error) })
    }
  },
  computed: {
    login_button_text(){
      if(this.logging_in) return "Logging in..."
      else return "Login"
    },
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
  max-width: 300px;
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

.hint {
  font-size: 80%;
}

.loader_wrapper {
  font-size: 150%;
  display: flex;
  justify-content: center;
}

</style>
