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
      <input type="submit" value="Logout">
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
      logged_in: false,

      input_data: {
        username: "",
        password: "",
      },

      logging_in: false,
      error_message: "",

    }
  },
  mounted(){
    // Check login status
    this.axios.post("https://authentication.maximemoreillon.com/status")
    .then( response => this.logged_in = response.data.logged_in )
    .catch(error => console.log(error))
  },
  methods: {
    login(){
      this.logging_in = true;
      this.error_message = "";

      this.axios.post("https://authentication.maximemoreillon.com/login", {
        username: this.input_data.username,
        password: this.input_data.password
      })
      .then(response => {

        this.logging_in = false;

        console.log(response.data)

        this.logged_in = response.data.logged_in

        this.error_message = response.data.error;

        // If successful login, redirect to app when done
        if(this.logged_in && document.referrer) window.location.href = document.referrer;

      })
      .catch(error => console.log(error))
    },
    logout(){
      this.axios.post("https://authentication.maximemoreillon.com/logout")
      .then(response => this.logged_in = response.data.logged_in)
      .catch(error => console.log(error))
    },
  },
  computed: {
    login_button_text(){
      if(this.logging_in) return "Logging in..."
      else return "Login"
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
}

.error_message {
  text-align: center;
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

input[type="submit"] {
  border: 2px solid #444444;
  background-color: white;
  color: #444444;
  transition: border-color 0.25s;
  cursor: pointer;

}

input[type="submit"]:hover {
  border: 2px solid #c00000;
}


</style>
