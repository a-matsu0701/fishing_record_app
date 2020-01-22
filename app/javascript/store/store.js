import Vue from "vue";
import Vuex from "vuex";
import Qs from "qs";
import axios from '../axios/axios';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    posts: [],
    postInfo: {},
    pagerInfo: {},
    page: 1,
    firstPage: true,
    lastPage: false,
    query: {
      title_cont: null,
      date_gteq: null,
      date_lteq: null,
      user_id_eq: null,
      sorts: "created_at desc"
    },
    message: "",
    confirmMessage: "",
    postWords: I18n.t("activerecord.attributes.post"),
    dictionaryWords: I18n.t("dictionary"),
    token: "",
    user: {},
    isSignIn: false,
    loading: false
  },
  mutations: {
    setPosts(state, data) {
      state.posts = data.posts;
      state.pagerInfo = data.pager_info;
      state.firstPage = state.page == 1 ? true : false;
      state.lastPage = state.page == state.pagerInfo.max_page ? true : false;
    },
    updateQuery(state, input) {
      state.query[input.key] = input.value;
    },
    resetQuery(state, input) {
      state.query = {
        title_cont: null,
        date_gteq: null,
        date_lteq: null,
        user_id_eq: null,
        sorts: "created_at desc"
      };
    },
    prePage(state) {
      state.page -= 1;
    },
    nextPage(state) {
      state.page += 1;
    },
    resetPage(state) {
      state.page = 1;
    },
    setPostInfo(state, post) {
      state.postInfo = post;
    },
    setMessage(state, message) {
      state.message = message;
    },
    setConfirmMessage(state, confirmMessage) {
      state.confirmMessage = confirmMessage;
    },
    setToken(state, token) {
      state.token = token;
    },
    setUser(state, user) {
      state.user = user;
    },
    setSignIn(state, isSignIn) {
      state.isSignIn = isSignIn;
    },
    setLoading(state, loading) {
      state.loading = loading;
    }
  },
  actions: {
    fetchPosts({ commit, state }) {
      axios
        .get("/api/posts.json", {
          params: {
            q: state.query,
            page: state.page
          },
          paramsSerializer: function (params) {
            return Qs.stringify(params, { arrayFormat: "brackets" });
          }
        })
        .then(res => {
          commit('setPosts', res.data);
        });
    },
    prePage({ dispatch, commit }) {
      commit('prePage');
      dispatch('fetchPosts');
    },
    nextPage({ dispatch, commit }) {
      commit('nextPage');
      dispatch('fetchPosts');
    },
    getPostInfo({ commit }, id) {
      return new Promise(resolve => {
        axios.get(`/api/posts/${id}.json`).then(res => {
          commit('setPostInfo', res.data);
          resolve();
        });
      });
    },
    setLoginUser({ commit }, payload) {
      return new Promise(resolve => {
        axios.get(`/api/users/${payload.uid}.json`).then(res => {
          commit('setToken', payload.token);
          commit('setUser', res.data);
          commit('setSignIn', true);
          resolve();
        });
      });
    },
    logout({ commit }) {
      return new Promise(resolve => {
        commit('setToken', "");
        commit('setUser', {});
        commit('setSignIn', false);
        resolve();
      });
    }
  }
})