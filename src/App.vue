<template>
  <div id="app">
    <AppTemplate
      noLoginControls
      applicationName="Authentication manager">
      <router-view />
    </AppTemplate>
  </div>
</template>

<script>
// @ is an alias to /src
import AppTemplate from '@moreillon/vue_application_template'

export default {
  name: 'app',
  components: {
    AppTemplate,
  },
}
</script>


<style>

</style>
