<template>
  <b-modal
    id="modal-show"
    title="Detail"
    ok-title="close"
    ok-variant="secondary"
    ok-only
    centered
    @hidden="resetModal"
    @close="$emit('close')"
    @cancel="$emit('close')"
    @hide="$emit('close')"
  >
    <b-alert v-if="message.length != 0" variant="success" dismissible show>{{ message }}</b-alert>
    <b-alert v-if="errors.length != 0" variant="danger" show>
      <ul v-for="e in errors" :key="e">
        <li>{{ e }}</li>
      </ul>
    </b-alert>
    <b-container>
      <div>
        <b-img :src="postInfo.show_img_path" fluid></b-img>
      </div>
      <h3 class="mt-4">Data</h3>
      <b-row class="mt-3">
        <b-col cols="3">Title</b-col>
        <b-col>{{ postInfo.title }}</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Date</b-col>
        <b-col>{{ postInfo.date | dateFormat }}</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Size</b-col>
        <b-col>{{ postInfo.size }}cm</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Weight</b-col>
        <b-col>{{ postInfo.weight }}グラム</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Number</b-col>
        <b-col>{{ postInfo.number }}匹</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Comment</b-col>
        <b-col>{{ postInfo.comment }}</b-col>
      </b-row>
    </b-container>
    <div class="text-right mt-3">
      <b-button @click="editPost" size="sm" variant="success" class="mr-2">Edit</b-button>
      <b-button @click="deletePost" size="sm" variant="danger">Delete</b-button>
    </div>
  </b-modal>
</template>

<script>
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

export default {
  props: {
    postInfo: {
      type: Object
    },
    message: {
      type: String
    }
  },
  data: function() {
    return {
      errors: ""
    };
  },
  methods: {
    resetModal() {
      this.errors = "";
    },
    editPost: function() {
      this.$emit("edit", this.postInfo.id);
    },
    deletePost: function() {
      this.$bvModal
        .msgBoxConfirm("削除してよろしいですか？", {
          size: "sm",
          buttonSize: "sm",
          okVariant: "danger",
          footerClass: "p-2",
          hideHeaderClose: false,
          centered: true
        })
        .then(confirm => {
          if (confirm) {
            axios
              .delete(`/api/posts/${this.postInfo.id}`)
              .then(response => {
                this.$nextTick(() => {
                  this.$bvModal.hide("modal-show");
                });
                this.$emit("delete");
              })
              .catch(error => {
                if (error.response.data && error.response.data.errors) {
                  this.errors = error.response.data.errors;
                }
              });
          }
        })
        .catch(err => {});
    }
  }
};
</script>

<style scoped></style>