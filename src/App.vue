<template>
  <div id="app">
    <AppTemplate
      noLoginControls
      applicationName="Authentication manager"/>
  </div>
</template>

<script>
// @ is an alias to /src
import AppTemplate from '@/components/vue_application_template/AppTemplate.vue'

export default {
  name: 'app',
  components: {
    AppTemplate,
  },
  data(){
    return {
    }
  }
}
</script>


<style>

</style>
