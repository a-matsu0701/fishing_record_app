<template>
  <div>
    <Header />
    <Index @show="showPost" />
    <ShowModal @edit="updatePost" @delete="deleted" />
    <CreateModal @submit="registrated" />
    <UpdateModal @submit="registrated" />
  </div>
</template>

<script>
import _ from "lodash";
import moment from "moment";
import Vue from "vue";
import BootstrapVue from "bootstrap-vue";
import { mapState, mapMutations, mapActions } from "vuex";

// DateTimePickerのインポート
import VueCtkDateTimePicker from "vue-ctk-date-time-picker";
Vue.component("VueCtkDateTimePicker", VueCtkDateTimePicker);
import "vue-ctk-date-time-picker/dist/vue-ctk-date-time-picker.css";

import Header from "../components/Header.vue";
import Index from "../components/Index.vue";
import ShowModal from "../components/ShowModal.vue";
import CreateModal from "../components/CreateModal.vue";
import UpdateModal from "../components/UpdateModal.vue";

import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";

import { i18n } from "../mixins/i18n";

Vue.use(BootstrapVue);

// 日時表示フォーマット
Vue.filter("dateFormat", function(date) {
  return moment(date).format(I18n.t("dictionary.format.date"));
});

export default {
  mixins: [i18n],
  components: {
    Header,
    Index,
    ShowModal,
    CreateModal,
    UpdateModal
  },
  computed: mapState(["postInfo", "dictionaryWords"]),
  methods: {
    ...mapMutations(["setMessage"]),
    ...mapActions(["fetchPosts", "getPostInfo"]),
    showPost: function(id) {
      this.getPostInfo(id).then(() => {
        if (this.postInfo.id != null) {
          this.$bvModal.show("modal-show");
        }
      });
    },
    updatePost: function(id) {
      this.getPostInfo(id).then(() => {
        if (this.postInfo.id != null) {
          this.$bvModal.show("modal-update");
        }
      });
    },
    registrated: function(id) {
      this.fetchPosts();
      this.getPostInfo(id).then(() => {
        if (this.postInfo.id != null) {
          this.setMessage(this.dictionaryWords.messages.registration);
          this.$bvModal.show("modal-show");
        }
      });
    },
    deleted: function() {
      this.fetchPosts();

      // 削除完了メッセージモーダル生成
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
