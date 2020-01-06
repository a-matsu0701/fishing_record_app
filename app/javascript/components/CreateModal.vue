<template>
  <b-modal
    id="modal-create"
    :title="dictionaryWords.words.new_create"
    :ok-title="dictionaryWords.button.submit"
    :cancel-title="dictionaryWords.button.cancel"
    centered
    no-close-on-backdrop
    :ok-disabled="processing"
    :cancel-disabled="processing"
    @show="resetModal"
    @hidden="resetModal"
    @ok="handleSubmit"
  >
    <b-container>
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
import Vue from "vue";
import axios from "axios";
import { csrfToken } from "rails-ujs";
import VueCtkDateTimePicker from "vue-ctk-date-time-picker";
import "vue-ctk-date-time-picker/dist/vue-ctk-date-time-picker.css";

Vue.component("VueCtkDateTimePicker", VueCtkDateTimePicker);

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

export default {
  props: {
    postWords: {
      type: Object
    },
    dictionaryWords: {
      type: Object
    }
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
      errors: "",
      processing: false
    };
  },
  computed: {
    start() {
      const start = moment().add(-50, "years");
      return start.format("YYYY-MM-DDTHH:mm:ss");
    },
    end() {
      const end = moment();
      return end.format("YYYY-MM-DDTHH:mm:ss");
    }
  },
  methods: {
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
      this.errors = "";
      this.processing = false;
    },
    selectedFile: function(e) {
      e.preventDefault();
      const files = e.target.files;
      this.post.image = files.length >= 1 ? files[0] : "";
    },
    handleSubmit(bvModalEvt) {
      this.processing = true;
      bvModalEvt.preventDefault();
      this.createPost();
    },
    createPost: function() {
      const formData = new FormData();
      Object.entries(this.post).forEach(([key, value]) =>
        formData.append(`post[${key}]`, value)
      );
      axios
        .post("/api/posts", formData)
        .then(res => {
          let e = res.data;
          this.$nextTick(() => {
            this.$bvModal.hide("modal-create");
          });
          this.$emit("submit", e.id);
        })
        .catch(error => {
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
          this.processing = false;
        });
    }
  }
};
</script>

<style scoped></style>