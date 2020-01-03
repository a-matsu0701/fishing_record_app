<template>
  <div>
    <Header />
    <b-container class="mt-5 p-5 bg-light">
      <b-form class="p-3 mb-5 border rounded">
        <b-form-row sm="10">
          <b-col sm="4">
            <b-form-group
              label-cols-sm="2"
              label="Title:"
              label-align-sm="right"
              label-for="input-title"
            >
              <b-form-input id="input-title" v-model="query.title_cont"></b-form-input>
            </b-form-group>
          </b-col>
          <b-col sm="4">
            <b-form-group
              label-cols-sm="2"
              label="Date:"
              label-align-sm="right"
              label-for="input-date-from"
            >
              <VueCtkDateTimePicker
                id="input-date-from"
                :label="''"
                :format="'YYYY-MM-DD HH:mm'"
                :no-button-now="true"
                :input-size="'sm'"
                v-model="query.date_gteq"
              />
              <span>〜</span>
              <VueCtkDateTimePicker
                id="input-date-to"
                :label="''"
                :format="'YYYY-MM-DD HH:mm'"
                :no-button-now="true"
                :input-size="'sm'"
                v-model="query.date_lteq"
              />
            </b-form-group>
          </b-col>
          <b-col sm="4">
            <b-form-group
              label-cols-sm="2"
              label="Sort:"
              label-align-sm="right"
              label-for="select-sort"
            >
              <b-form-select id="select-sort" v-model="query.sorts" :options="sortOptions"></b-form-select>
            </b-form-group>
          </b-col>
        </b-form-row>
      </b-form>
      <div class="text-right mt-3 mb-4">
        <span
          class="mr-2"
        >{{ pagerInfo.st_count }} 〜 {{ pagerInfo.end_count }} / {{ pagerInfo.total_count }} 件</span>
        <b-button @click="prePage" :disabled="firstPage" size="sm" variant="info" class="mr-1">&lt;</b-button>
        <b-button @click="nextPage" :disabled="lastPage" size="sm" variant="info">&gt;</b-button>
      </div>
      <b-row>
        <b-col lg="4" md="4" sm="4" cols="4" v-for="post in posts" :key="post.id">
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

    <ShowModal
      :postInfo="postInfo"
      :message="message"
      @close="closeReset"
      @edit="updatePost"
      @delete="deletePost"
    />
    <CreateModal @submit="showPost" />
    <UpdateModal :post="postInfo" @close="closeReset" @submit="showPost" />
  </div>
</template>

<script>
import _ from "lodash";
import moment from "moment";
import Vue from "vue";
import BootstrapVue from "bootstrap-vue";
import axios from "axios";
import Qs from "qs";
import VueCtkDateTimePicker from "vue-ctk-date-time-picker";

Vue.component("VueCtkDateTimePicker", VueCtkDateTimePicker);

import Header from "../components/Header.vue";
import ShowModal from "../components/ShowModal.vue";
import CreateModal from "../components/CreateModal.vue";
import UpdateModal from "../components/UpdateModal.vue";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import "vue-ctk-date-time-picker/dist/vue-ctk-date-time-picker.css";

Vue.use(BootstrapVue);

Vue.filter("dateFormat", function(date) {
  return moment(date).format("YYYY年M月D日 HH:mm");
});

export default {
  components: {
    Header,
    ShowModal,
    CreateModal,
    UpdateModal
  },
  data: function() {
    return {
      posts: [],
      postInfo: {},
      pagerInfo: {},
      page: 1,
      firstPage: true,
      lastPage: false,
      message: "",
      query: {
        title_cont: null,
        date_gteq: null,
        date_lteq: null,
        sorts: "created_at desc"
      },
      sortOptions: [
        { value: "created_at desc", text: "新着順" },
        { value: "date desc", text: "釣れた日順" }
      ]
    };
  },
  watch: {
    query: {
      handler: function(newValue, oldValue) {
        this.page = 1;
        this.debouncedSearch();
      },
      deep: true
    }
  },
  created: function() {
    this.debouncedSearch = _.debounce(this.search, 1000);
  },
  mounted: function() {
    this.search();
  },
  methods: {
    search: function() {
      axios
        .get("/api/posts/search.json", {
          params: {
            q: this.query,
            page: this.page
          },
          paramsSerializer: function(params) {
            return Qs.stringify(params, { arrayFormat: "brackets" });
          }
        })
        .then(res => {
          this.posts = res.data.posts;
          this.pagerInfo = res.data.pager_info;
          this.firstPage = this.page == 1 ? true : false;
          this.lastPage = this.page == this.pagerInfo.max_page ? true : false;
        })
        .catch(error => {});
    },
    prePage() {
      this.page -= 1;
      this.search();
    },
    nextPage() {
      this.page += 1;
      this.search();
    },
    setPostInfo(id) {
      axios.get(`/api/posts/${id}.json`).then(res => {
        this.postInfo = res.data;
      });
    },
    closeReset() {
      this.postInfo = {};
      this.message = "";
    },
    showPost: function(id) {
      this.search();
      this.setPostInfo(id);
      this.message = "Registration has been completed.";
      this.$bvModal.show("modal-show");
    },
    updatePost: function(id) {
      this.$bvModal.hide("modal-show");
      this.setPostInfo(id);
      this.$bvModal.show("modal-update");
    },
    deletePost: function() {
      this.search();
      this.$bvModal.msgBoxOk("削除が完了しました。", {
        size: "sm",
        buttonSize: "sm"
      });
    }
  }
};
</script>

<style scoped>
</style>
