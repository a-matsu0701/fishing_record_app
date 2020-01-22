import Vue from 'vue';
import axios from 'axios';
import { csrfToken } from "rails-ujs";
import store from '../store/store';

if (typeof csrfToken === 'function') {
  axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();
}

const http = axios;

http.interceptors.request.use(
  function (config) {
    // Firebaseの認証で取得したIDトークンがあればリクエストのヘッダーに設定する
    if (store.state.token) {
      config.headers.Authorization = store.state.token;
    }
    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
)

http.interceptors.response.use(
  function (response) { return response; },
  function (error) {
    if (error.response.status === 401 || error.response.status === 404 || error.response.status === 500) {
      // Authエラー、NotFoundエラー、システムエラー発生時のメッセージ処理
      let message = ""
      switch (error.response.status) {
        case 401:
          message = store.state.dictionaryWords.messages.auth_error;
          break;
        case 404:
          message = store.state.dictionaryWords.messages.not_found_error;
          break;
        default:
          message = store.state.dictionaryWords.messages.system_error;
      };

      Vue.toasted.clear();
      Vue.toasted.error(message, {
        position: "top-center",
        fullWidth: true,
        action: {
          text: "×",
          onClick: (e, toastObject) => {
            toastObject.goAway(0);
          }
        }
      });
    }
    return Promise.reject(error);
  }
)

export default http;