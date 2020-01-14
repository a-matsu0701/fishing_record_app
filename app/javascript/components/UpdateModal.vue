<template>
  <b-modal
    id="modal-update"
    :title="dictionaryWords.button.edit"
    :ok-title="dictionaryWords.button.submit"
    :cancel-title="dictionaryWords.button.cancel"
    centered
    no-close-on-backdrop
    :ok-disabled="processing"
    :cancel-disabled="processing"
    @show="setPost"
    @hidden="resetModal"
    @ok="handleSubmit"
  >
    <b-container>
      <b-form @submit.prevent="updatePost">
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
        <div>
          <b-img :src="post.show_img_path" fluid class="mb-4" v-show="!newImage"></b-img>
        </div>

        <b-form-group id="input-group-title" :label="postWords.title" label-for="input-title">
          <b-form-input id="input-title" v-model="post.title" type="text" required></b-form-input>
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
import axios from "axios";
import { csrfToken } from "rails-ujs";
import { mapState } from "vuex";
import { datepickerRange } from "../mixins/datepickerRange";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

export default {
  mixins: [datepickerRange],
  data: function() {
    return {
      post: {},
      newImage: false, //画像の差し替えを判定するフラグ
      processing: false, //更新処理中を判定するフラグ
      errors: ""
    };
  },
  computed: {
    ...mapState(["postInfo", "postWords", "dictionaryWords"])
  },
  methods: {
    setPost() {
      this.post = this.postInfo;
    },
    resetModal() {
      this.post = {};
      this.newImage = false;
      this.processing = false;
      this.errors = "";
    },
    selectedFile: function(e) {
      e.preventDefault();
      const files = e.target.files;
      if (files.length >= 1) {
        //新たな画像を選択した場合
        this.newImage = true;
        this.post.image = files[0];
      } else {
        //新たな画像の選択を解除した場合
        this.newImage = false;
        delete this.post.image;
      }
    },
    handleSubmit(bvModalEvt) {
      this.processing = true; //更新処理中はボタンを非活性にする
      bvModalEvt.preventDefault();
      this.updatePost();
    },
    updatePost: function() {
      const formData = new FormData();
      for (let [key, value] of Object.entries(this.post)) {
        if (value == null) {
          value = "";
        }
        formData.append(`post[${key}]`, value);
      }
      this.$http
        .patch(`/api/posts/${this.post.id}`, formData)
        .then(res => {
          let e = res.data;
          this.$bvModal.hide("modal-update");
          this.$emit("submit", this.post.id);
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
        });
    }
  }
};
</script>

<style scoped></style>