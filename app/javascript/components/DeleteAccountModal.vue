<template>
  <b-modal
    id="modal-delete-account"
    :title="dictionaryWords.button.account_delete"
    :ok-title="dictionaryWords.button.account_delete"
    ok-variant="danger"
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
        <p class="mb-4">{{ dictionaryWords.messages.delete_account_notes }}</p>
        <b-form-group
          id="input-group-password"
          :label="dictionaryWords.words.password"
          label-for="input-password"
        >
          <b-form-input id="input-password" v-model="password" type="password"></b-form-input>
        </b-form-group>
      </b-form>
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
      password: "",
      processing: false,
      errors: ""
    };
  },
  computed: mapState(["dictionaryWords"]),
  methods: {
    ...mapMutations(["setConfirmMessage", "setLoading"]),
    resetModal() {
      this.password = "";
      this.processing = false;
      this.errors = "";
    },
    handleSubmit(bvModalEvt) {
      bvModalEvt.preventDefault();
      this.deleteAccount();
    },
    deleteAccount: function() {
      // 削除確認メッセージモーダル生成
      this.$bvModal
        .msgBoxConfirm(this.dictionaryWords.messages.delete_account_confirm, {
          size: "sm",
          buttonSize: "sm",
          okVariant: "danger",
          footerClass: "p-2",
          centered: true,
          cancelTitle: this.dictionaryWords.button.cancel
        })
        .then(async confirm => {
          if (confirm) {
            //OKボタン押下で削除処理
            this.processing = true; //削除処理中はボタンを非活性にする
            this.setLoading(true);
            const user = firebase.auth().currentUser;
            const credential = await firebase.auth.EmailAuthProvider.credential(
              user.email,
              this.password
            );
            user
              .reauthenticateWithCredential(credential) //事前にFirebaseへ再認証
              .then(() => {
                this.$http
                  .delete(`/api/users/${user.uid}`)
                  .then(() => {
                    user
                      .delete()
                      .then(() => {
                        this.setConfirmMessage(
                          this.dictionaryWords.messages.account_deleted
                        );
                        this.$bvModal.hide("modal-delete-account");
                        this.$emit("delete");
                        this.setLoading(false);
                      })
                      .catch(error => {
                        this.errors = [
                          this.dictionaryWords.auth_errors.account_delete
                        ];
                        this.processing = false;
                        this.setLoading(false);
                      });
                  })
                  .catch(error => {
                    if (
                      error.response.data &&
                      error.response.data.errors &&
                      error.response.status !== 404 &&
                      error.response.status !== 500
                    ) {
                      this.errors = error.response.data.errors;
                    }
                    this.processing = false;
                    this.setLoading(false);
                  });
              })
              .catch(error => {
                if (error.code == "auth/wrong-password") {
                  this.errors = [
                    this.dictionaryWords.auth_errors[`${error.code}`]
                  ];
                } else {
                  this.errors = [
                    this.dictionaryWords.auth_errors.account_delete
                  ];
                }
                this.processing = false;
                this.setLoading(false);
              });
          }
        });
    }
  }
};
</script>

<style scoped></style>