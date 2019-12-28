<template>
  <div>
    <Header />
    <b-container class="mt-5 p-5 bg-light">
      <b-row>
        <b-col lg="4" md="6" sm="12" v-for="post in posts" :key="post.id">
          <b-img
            v-b-modal.modal-show
            center
            thumbnail
            fluid
            :src="post.index_img_path"
            alt="Image 1"
            class="mousepointer-hand px-1"
            v-on:click="setPostInfo(post.id)"
          ></b-img>
          <p class="mb-0">{{ post.title }}</p>
          <p class="mb-4">{{ post.date | dateFormat }}</p>
        </b-col>
      </b-row>
    </b-container>

    <ShowModal :postInfo="postInfo" :message="message" @close="message = ''" />
    <CreateModal @create="showPost" />
  </div>
</template>

<script>
import moment from "moment";
import Vue from "vue";
import BootstrapVue from "bootstrap-vue";
import axios from "axios";
import Header from "../components/Header.vue";
import ShowModal from "../components/ShowModal.vue";
import CreateModal from "../components/CreateModal.vue";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";

Vue.use(BootstrapVue);

Vue.filter("dateFormat", function(date) {
  return moment(date).format("YYYY年M月D日 HH:mm");
});

export default {
  components: {
    Header,
    ShowModal,
    CreateModal
  },
  data: function() {
    return {
      postInfo: {},
      posts: [],
      message: ""
    };
  },
  mounted: function() {
    this.fetchPosts();
  },
  methods: {
    fetchPosts() {
      axios.get("/api/posts.json").then(res => {
        this.posts = res.data;
      });
    },
    setPostInfo(id) {
      axios.get(`/api/posts/${id}.json`).then(res => {
        this.postInfo = res.data;
      });
    },
    showPost: function(data) {
      this.fetchPosts();
      this.postInfo = data;
      this.message = "Registration has been completed.";
      this.$bvModal.show("modal-show");
    }
  }
};
</script>

<style scoped>
</style>
