<template>
  <b-modal
    id="modal-login"
    :title="dictionaryWords.words.login"
    :ok-title="dictionaryWords.words.login"
    :cancel-title="dictionaryWords.button.cancel"
    ok-only
    centered
    no-close-on-esc
    no-close-on-backdrop
    :ok-disabled="processing"
    :hide-header-close="processing"
    @hidden="resetModal"
    @ok="handleSubmit"
  >
    <b-container>
      <Loading cname="mini-loader" />
      <div class="text-secondary mb-4">
        {{ dictionaryWords.messages.sample_info }}
        <ul>
          <li>{{ dictionaryWords.messages.sample_email }}</li>
          <li>{{ dictionaryWords.messages.sample_password }}</li>
        </ul>
      </div>
      <b-form @submit.prevent="handleSubmit">
        <b-alert v-if="errors.length != 0" variant="danger" show>
          <ul v-for="e in errors" :key="e">
            <li>{{ e }}</li>
          </ul>
        </b-alert>

        <b-form-group
          id="input-group-email"
          :label="dictionaryWords.words.email"
          label-for="input-email"
        >
          <b-form-input id="input-email" v-model="email" type="email"></b-form-input>
        </b-form-group>
        <b-form-group
          id="input-group-password"
          :label="dictionaryWords.words.password"
          label-for="input-password"
        >
          <b-form-input id="input-password" v-model="password" type="password"></b-form-input>
        </b-form-group>
      </b-form>
      <div class="mt-5 mb-2">
        <b-link @click="toSignup" :disabled="processing">{{ dictionaryWords.words.first_visitor }}</b-link>
      </div>
    </b-container>
  </b-modal>
</template>
<script>
import firebase from "firebase/app";
import "firebase/auth";
import { mapState, mapMutations } from "vuex";
import Loading from "../components/Loading.vue";

export default {
  components: {
    Loading
  },
  data() {
    return {
      email: "",
      password: "",
      processing: false,
      errors: ""
    };
  },
  computed: mapState(["dictionaryWords"]),
  methods: {
    ...mapMutations(["setConfirmMessage", "setLoading"]),
    resetModal() {
      this.email = "";
      this.password = "";
      this.processing = false;
      this.errors = "";
    },
    handleSubmit(bvModalEvt) {
      bvModalEvt.preventDefault();
      this.processing = true; //ログイン処理中はボタンを非活性にする
      this.setLoading(true);
      this.login();
    },
    login() {
      firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .then(() => {
          this.setConfirmMessage(this.dictionaryWords.messages.login);
          this.$bvModal.hide("modal-login");
          this.$emit("login");
          this.setLoading(false);
        })
        .catch(error => {
          this.errors = [this.dictionaryWords.auth_errors[`${error.code}`]];
          this.processing = false;
          this.setLoading(false);
        });
    },
    toSignup() {
      this.$bvModal.hide("modal-login");
      this.$emit("toSignup");
    }
  }
};
</script>

<style scoped></style>