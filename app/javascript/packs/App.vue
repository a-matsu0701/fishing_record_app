<template>
  <div>
    <Header />
    <b-container fluid class="mt-5 p-4 bg-light">
      <b-row>
        <b-col lg="3" md="4" sm="6" v-for="post in posts" :key="post.id">
          <b-img
            v-b-modal.modal-show
            center
            thumbnail
            fluid
            src="https://picsum.photos/250/250/?image=54"
            alt="Image 1"
            class="mb-3 mousepointer-hand"
            v-on:click="setPostInfo(post.id)"
          ></b-img>
        </b-col>
      </b-row>
    </b-container>

    <ShowModal :postInfo="postInfo" />
  </div>
</template>

<script>
import moment from "moment";
import Vue from "vue";
import BootstrapVue from "bootstrap-vue";
import axios from "axios";
import Header from "../components/Header.vue";
import ShowModal from "../components/ShowModal.vue";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";

Vue.use(BootstrapVue);

Vue.filter("dateFormat", function(date) {
  return moment(date).format("YYYY年M月D日 HH:mm");
});

export default {
  name: "PostHome",
  components: {
    Header,
    ShowModal
  },
  data: function() {
    return {
      postInfo: {},
      posts: []
    };
  },
  mounted: function() {
    this.fetchPosts();
  },
  methods: {
    fetchPosts() {
      axios.get("/api/posts.json").then(
        res => {
          this.posts = res.data;
        },
        error => {
          console.log(error);
        }
      );
    },
    setPostInfo(id) {
      axios.get(`/api/posts/${id}.json`).then(res => {
        this.postInfo = res.data;
      });
    }
  }
};
</script>

<style scoped>
</style>
