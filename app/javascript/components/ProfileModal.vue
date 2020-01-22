<template>
  <b-modal
    id="modal-profile"
    :title="dictionaryWords.words.profile"
    :ok-title="dictionaryWords.button.close"
    ok-variant="secondary"
    ok-only
    centered
  >
    <b-container>
      <b-row class="mt-3">
        <b-col cols="4">{{ dictionaryWords.words.name }}</b-col>
        <b-col class="overflow-auto" v-if="user">{{ user.name }}</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="4">{{ dictionaryWords.words.email }}</b-col>
        <b-col v-if="user">{{ user.email }}</b-col>
      </b-row>
    </b-container>
    <div class="text-right mt-5">
      <b-button
        @click="toDeleteAccount"
        size="sm"
        variant="danger"
      >{{ dictionaryWords.button.account_delete }}</b-button>
    </div>
  </b-modal>
</template>

<script>
import firebase from "firebase/app";
import "firebase/auth";
import { mapState } from "vuex";

export default {
  computed: mapState(["user", "dictionaryWords"]),
  methods: {
    toDeleteAccount: function() {
      this.$bvModal.hide("modal-profile");
      this.$emit("toDeleteAccount");
    }
  }
};
</script>

<style scoped></style>