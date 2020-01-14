<template>
  <div>
    <b-navbar fixed="top" type="dark" variant="info">
      <b-navbar-brand href="#" @click="homeReload">{{ dictionaryWords.words.app_title }}</b-navbar-brand>
      <b-navbar-nav class="ml-auto">
        <b-button v-b-modal.modal-create>{{ dictionaryWords.button.create }}</b-button>
      </b-navbar-nav>
    </b-navbar>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  computed: mapState(["dictionaryWords"]),
  methods: {
    homeReload: function() {
      location.reload();
    }
  }
};
</script>
<style scoped></style>