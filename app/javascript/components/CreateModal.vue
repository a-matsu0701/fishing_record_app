<template>
  <b-modal
    id="modal-create"
    title="Create"
    ok-title="Submit"
    centered
    no-close-on-backdrop
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
        <b-form-group id="input-group-title" label="Title:" label-for="input-title">
          <b-form-input id="input-title" v-model="post.title" type="text" required></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-date" label="Date:">
          <VueCtkDateTimePicker
            :label="''"
            :format="'YYYY-MM-DD HH:mm'"
            :min-date="start"
            :max-date="end"
            :no-button-now="true"
            v-model="post.date"
          />
        </b-form-group>

        <b-form-group id="input-group-size" label="Size(cm):" label-for="input-size">
          <b-form-input id="input-size" v-model="post.size" type="number" min="0"></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-weight" label="Weight(グラム):" label-for="input-weight">
          <b-form-input id="input-weight" v-model="post.weight" type="number" min="0"></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-number" label="Number(匹):" label-for="input-number">
          <b-form-input id="input-number" v-model="post.number" type="number" min="0"></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-comment" label="Comment:" label-for="input-comment">
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
  data: function() {
    return {
      post: {
        title: "",
        date: "",
        size: "",
        weight: "",
        number: "",
        comment: ""
      },
      errors: ""
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
        comment: ""
      };
      this.errors = "";
    },
    handleSubmit(bvModalEvt) {
      bvModalEvt.preventDefault();
      this.createPost();
    },
    createPost: function() {
      axios
        .post("/api/posts", this.post)
        .then(res => {
          let e = res.data;
          this.$nextTick(() => {
            this.$bvModal.hide("modal-create");
          });
          this.$emit("create", e);
        })
        .catch(error => {
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    }
  }
};
</script>

<style scoped></style>