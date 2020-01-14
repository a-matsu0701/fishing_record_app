<template>
  <b-container class="mt-5 p-5 bg-light">
    <!-- 検索フォーム -->
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
      <div class="text-right">
        <b-button @click="resetQuery" variant="info" class="mr-2">{{ dictionaryWords.button.reset }}</b-button>
      </div>
    </b-form>
    <!-- 検索フォームここまで -->

    <!-- ページネーション -->
    <div class="text-right mt-3 mb-4">
      <span
        class="mr-2"
      >{{ pagerInfo.st_count }} 〜 {{ pagerInfo.end_count }} / {{ pagerInfo.total_count }} {{ dictionaryWords.words.count }}</span>
      <b-button @click="prePage" :disabled="firstPage" size="sm" variant="info" class="mr-1">&lt;</b-button>
      <b-button @click="nextPage" :disabled="lastPage" size="sm" variant="info">&gt;</b-button>
    </div>
    <!-- ページネーションここまで -->

    <!-- 投稿一覧 -->
    <b-row>
      <b-col lg="4" md="4" sm="4" cols="4" v-for="post in posts" :key="post.id">
        <b-img
          center
          thumbnail
          fluid
          :src="post.index_img_path"
          alt="Image"
          class="mousepointer-hand px-1"
          @click="$emit('show', post.id)"
        ></b-img>
        <p
          class="mousepointer-hand mb-0 overflow-auto"
          @click="$emit('show', post.id)"
        >{{ post.title }}</p>
        <p class="mb-4">{{ post.date | dateFormat }}</p>
      </b-col>
    </b-row>
    <!-- 投稿一覧ここまで -->
  </b-container>
</template>

<script>
import _ from "lodash";
import { mapState, mapMutations, mapActions } from "vuex";

export default {
  data: function() {
    return {
      sortOptions: [
        {
          value: "created_at desc",
          text: I18n.t("dictionary.form.select_option.sort.new")
        },
        {
          value: "date desc",
          text: I18n.t("dictionary.form.select_option.sort.date")
        }
      ]
    };
  },
  watch: {
    // 検索フォームの変更監視
    query: {
      handler: function(newValue, oldValue) {
        this.resetPage();
        this.debouncedSearch();
      },
      deep: true
    }
  },
  created: function() {
    // 検索フォーム変更後、１秒間入力なしで検索実行
    this.debouncedSearch = _.debounce(this.fetchPosts, 1000);
  },
  computed: {
    ...mapState([
      "posts",
      "pagerInfo",
      "page",
      "firstPage",
      "lastPage",
      "query",
      "postWords",
      "dictionaryWords"
    ]),
    queryTitle: {
      get() {
        return this.query.title_cont;
      },
      set(v) {
        this.updateQuery({ key: "title_cont", value: v });
      }
    },
    queryDateFrom: {
      get() {
        return this.query.date_gteq;
      },
      set(v) {
        this.updateQuery({ key: "date_gteq", value: v });
      }
    },
    queryDateTo: {
      get() {
        return this.query.date_lteq;
      },
      set(v) {
        this.updateQuery({ key: "date_lteq", value: v });
      }
    },
    querySort: {
      get() {
        return this.query.sorts;
      },
      set(v) {
        this.updateQuery({ key: "sorts", value: v });
      }
    }
  },
  mounted: function() {
    this.fetchPosts();
  },
  methods: {
    ...mapMutations(["updateQuery", "resetQuery", "resetPage"]),
    ...mapActions(["fetchPosts", "prePage", "nextPage"])
  }
};
</script>

<style scoped>
</style>
