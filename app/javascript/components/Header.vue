<template>
  <div>
    <b-navbar fixed="top" type="dark" variant="info">
      <b-navbar-brand href="#" @click="homeReload">{{ dictionaryWords.words.app_title }}</b-navbar-brand>

      <b-navbar-nav class="ml-auto">
        <b-button
          v-if="!isSignIn"
          @click="$emit('login')"
          class="mr-2"
        >{{ dictionaryWords.words.login }}</b-button>
        <b-button
          v-if="isSignIn"
          @click="$emit('create')"
          class="mr-2"
        >{{ dictionaryWords.button.create }}</b-button>

        <b-nav-item-dropdown right v-if="isSignIn">
          <template v-slot:button-content>
            <em v-if="user">{{ user.name }}</em>
          </template>
          <b-dropdown-item @click="$emit('profile')">{{ dictionaryWords.words.profile }}</b-dropdown-item>
          <b-dropdown-item @click="logout">{{ dictionaryWords.words.logout }}</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>
    </b-navbar>
  </div>
</template>

<script>
import firebase from "firebase/app";
import "firebase/auth";
import { mapState, mapMutations } from "vuex";

export default {
  computed: mapState(["user", "isSignIn", "dictionaryWords"]),
  methods: {
    ...mapMutations(["setConfirmMessage"]),
    homeReload: function() {
      location.reload();
    },
    logout() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.setConfirmMessage(this.dictionaryWords.messages.logout);
          this.$emit("logout");
        });
    }
  }
};
</script>
<style scoped></style>