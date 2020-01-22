<template>
  <b-modal
    id="modal-signup"
    :title="dictionaryWords.words.new_account"
    :ok-title="dictionaryWords.button.submit"
    :cancel-title="dictionaryWords.button.cancel"
    centered
    no-close-on-esc
    no-close-on-backdrop
    :ok-disabled="processing"
    :cancel-disabled="processing"
    :hide-header-close="processing"
    @hidden="resetModal"
    @ok="handleSubmit"
  >
    <b-container>
      <Loading cname="mini-loader" />
      <b-form @submit.prevent="handleSubmit">
        <b-alert v-if="errors.length != 0" variant="danger" show>
          <ul v-for="e in errors" :key="e">
            <li>{{ e }}</li>
          </ul>
        </b-alert>

        <b-form-group
          id="input-group-name"
          :label="dictionaryWords.words.name"
          label-for="input-name"
        >
          <b-form-input id="input-name" v-model="name" type="text"></b-form-input>
        </b-form-group>
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
        <b-form-group
          id="input-group-password-confirm"
          :label="dictionaryWords.words.password_confirm"
          label-for="input-password-confirm"
        >
          <b-form-input id="input-password-confirm" v-model="passwordConfirm" type="password"></b-form-input>
        </b-form-group>
      </b-form>
    </b-container>
  </b-modal>
</template>
<script>
import firebase from "firebase/app";
import "firebase/auth";
import { mapState, mapMutations, mapActions } from "vuex";
import Loading from "../components/Loading.vue";

export default {
  components: {
    Loading
  },
  data() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirm: "",
      processing: false,
      errors: ""
    };
  },
  computed: mapState(["dictionaryWords"]),
  methods: {
    ...mapMutations([
      "setToken",
      "setUser",
      "setSignIn",
      "setConfirmMessage",
      "setLoading"
    ]),
    ...mapActions(["setLoginUser"]),
    resetModal() {
      this.name = "";
      this.email = "";
      this.password = "";
      this.passwordConfirm = "";
      this.processing = false;
      this.errors = "";
    },
    handleSubmit(bvModalEvt) {
      bvModalEvt.preventDefault();
      if (this.password !== this.passwordConfirm) {
        this.errors = [this.dictionaryWords.auth_errors.password_confirm];
      } else if (!this.name || this.name.length > 25) {
        this.errors = [this.dictionaryWords.auth_errors.name];
      } else {
        this.processing = true; //登録処理中はボタンを非活性にする
        this.setLoading(true);
        this.signup();
      }
    },
    signup() {
      firebase
        .auth()
        .createUserWithEmailAndPassword(this.email, this.password)
        .then(res => {
          res.user.getIdToken(true).then(idToken => {
            // サーバー側でFirebase認証を行うため、httpヘッダーにIDトークンをセット
            this.$http.defaults.headers.Authorization = idToken;
            const user = {
              name: this.name,
              email: res.user.email
            };
            this.$http.post("/api/users", { user }).then(() => {
              this.setLoginUser({ token: idToken, uid: res.user.uid }).then(
                () => {
                  this.setConfirmMessage(
                    this.dictionaryWords.messages.account_created
                  );
                  this.$bvModal.hide("modal-signup");
                  this.$emit("signup");
                  this.setLoading(false);
                }
              );
            });
          });
        })
        .catch(error => {
          this.errors = [this.dictionaryWords.auth_errors[`${error.code}`]];
          this.processing = false;
          this.setLoading(false);
        });
    }
  }
};
</script>

<style scoped></style>