<template>
  <b-modal
    id="modal-create"
    :title="dictionaryWords.words.new_create"
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
      <b-form @submit.prevent="createPost">
        <b-alert v-if="errors.length != 0" variant="danger" show>
          <ul v-for="e in errors" :key="e">
            <li>{{ e }}</li>
          </ul>
        </b-alert>

        <b-form-group id="input-group-image" :label="postWords.image" label-for="input-image">
          <b-form-file
            id="input-image"
            accept="image/*"
            :placeholder="dictionaryWords.messages.select_image"
            :browse-text="dictionaryWords.button.browse"
            @change="selectedFile"
          ></b-form-file>
        </b-form-group>

        <b-form-group id="input-group-title" :label="postWords.title" label-for="input-title">
          <b-form-input id="input-title" v-model="post.title" type="text"></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-date" :label="postWords.date">
          <VueCtkDateTimePicker
            :label="''"
            :format="'YYYY-MM-DD HH:mm'"
            :min-date="start"
            :max-date="end"
            :no-button-now="true"
            v-model="post.date"
          />
        </b-form-group>

        <b-form-group
          id="input-group-size"
          :label="dictionaryWords.form.size"
          label-for="input-size"
        >
          <b-form-input id="input-size" v-model="post.size" type="number" min="0"></b-form-input>
        </b-form-group>

        <b-form-group
          id="input-group-weight"
          :label="dictionaryWords.form.weight"
          label-for="input-weight"
        >
          <b-form-input id="input-weight" v-model="post.weight" type="number" min="0"></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-number" :label="postWords.number" label-for="input-number">
          <b-form-input id="input-number" v-model="post.number" type="number" min="0"></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-comment" :label="postWords.comment" label-for="input-comment">
          <b-form-textarea id="input-comment" v-model="post.comment"></b-form-textarea>
        </b-form-group>
      </b-form>
    </b-container>
  </b-modal>
</template>

<script>
import moment from "moment";
import { mapState, mapMutations } from "vuex";
import { datepickerRange } from "../mixins/datepickerRange";
import Loading from "../components/Loading.vue";

export default {
  mixins: [datepickerRange],
  components: {
    Loading
  },
  data: function() {
    return {
      post: {
        title: "",
        date: "",
        size: "",
        weight: "",
        number: "",
        comment: "",
        image: ""
      },
      processing: false, //登録処理中を判定するフラグ
      errors: ""
    };
  },
  computed: {
    ...mapState(["postWords", "dictionaryWords"])
  },
  methods: {
    ...mapMutations(["setLoading"]),
    resetModal() {
      this.post = {
        title: "",
        date: "",
        size: "",
        weight: "",
        number: "",
        comment: "",
        image: ""
      };
      this.processing = false;
      this.errors = "";
    },
    selectedFile: function(e) {
      e.preventDefault();
      const files = e.target.files;
      this.post.image = files.length >= 1 ? files[0] : "";
    },
    handleSubmit(bvModalEvt) {
      this.processing = true; //登録処理中はボタンを非活性にする
      this.setLoading(true);
      bvModalEvt.preventDefault();
      this.createPost();
    },
    createPost: function() {
      const formData = new FormData();
      Object.entries(this.post).forEach(([key, value]) =>
        formData.append(`post[${key}]`, value)
      );
      this.$http
        .post("/api/posts", formData)
        .then(res => {
          let e = res.data;
          this.$bvModal.hide("modal-create");
          this.$emit("submit", e.id);
          this.setLoading(false);
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
    }
  }
};
</script>

<style scoped></style>