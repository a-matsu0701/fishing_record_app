import Vue from 'vue';
import axios from 'axios';
import store from '../store/store';

const http = axios;

http.interceptors.response.use(
  function (response) { return response; },
  function (error) {
    if (error.response.status === 404 || error.response.status === 500) {
      // NotFoundエラー、システムエラー発生時のメッセージ処理
      const message = error.response.status === 404
        ? store.state.dictionaryWords.messages.not_found_error
        : store.state.dictionaryWords.messages.system_error;

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