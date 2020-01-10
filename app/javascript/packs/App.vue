<template>
  <div>
    <Header :dictionaryWords="dictionaryWords" />
    <b-container class="mt-5 p-5 bg-light">
      <b-form class="p-3 mb-5 border rounded">
        <b-form-row sm="10">
          <b-col sm="4">
            <b-form-group
              label-cols-sm="3"
              :label="postWords.title"
              label-align-sm="right"
              label-for="input-title"
            >
              <b-form-input id="input-title" v-model="query.title_cont"></b-form-input>
            </b-form-group>
          </b-col>
          <b-col sm="4">
            <b-form-group
              label-cols-sm="3"
              :label="postWords.date"
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
              label-cols-sm="3"
              :label="dictionaryWords.form.sort"
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
        >{{ pagerInfo.st_count }} 〜 {{ pagerInfo.end_count }} / {{ pagerInfo.total_count }} {{ dictionaryWords.words.count }}</span>
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
            @click="setPostInfo(post.id)"
          ></b-img>
          <p
            v-b-modal.modal-show
            class="mousepointer-hand mb-0 overflow-auto"
            @click="setPostInfo(post.id)"
          >{{ post.title }}</p>
          <p class="mb-4">{{ post.date | dateFormat }}</p>
        </b-col>
      </b-row>
    </b-container>

    <ShowModal
      :postInfo="postInfo"
      :message="message"
      :postWords="postWords"
      :dictionaryWords="dictionaryWords"
      @close="closeReset"
      @edit="updatePost"
      @delete="deletePost"
    />
    <CreateModal :postWords="postWords" :dictionaryWords="dictionaryWords" @submit="showPost" />
    <UpdateModal
      :post="postInfo"
      :postWords="postWords"
      :dictionaryWords="dictionaryWords"
      @close="closeReset"
      @submit="showPost"
    />
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

import { i18n } from "../mixins/i18n";

Vue.use(BootstrapVue);

Vue.filter("dateFormat", function(date) {
  return moment(date).format(I18n.t("dictionary.format.date"));
});

export default {
  mixins: [i18n],
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
        {
          value: "created_at desc",
          text: I18n.t("dictionary.form.select_option.sort.new")
        },
        {
          value: "date desc",
          text: I18n.t("dictionary.form.select_option.sort.date")
        }
      ],
      postWords: I18n.t("activerecord.attributes.post"),
      dictionaryWords: I18n.t("dictionary")
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
      this.message = this.dictionaryWords.messages.registration;
      this.$bvModal.show("modal-show");
    },
    updatePost: function(id) {
      this.$bvModal.hide("modal-show");
      this.setPostInfo(id);
      this.$bvModal.show("modal-update");
    },
    deletePost: function() {
      this.search();
      this.$bvModal.msgBoxOk(this.dictionaryWords.messages.delete_complete, {
        size: "sm",
        buttonSize: "sm"
      });
    }
  }
};
</script>

<style scoped>
</style>
