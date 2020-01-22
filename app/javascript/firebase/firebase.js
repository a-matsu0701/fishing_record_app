import firebase from 'firebase/app';
import 'firebase/auth';
import store from "../store/store";

const config = {
  apiKey: process.env.API_KEY,
  authDomain: process.env.AUTH_DOMAIN,
  databaseURL: process.env.DATABASE_URL,
  projectId: process.env.PROJECT_ID,
  storageBucket: process.env.STORAGE_BUCKET,
  messagingSenderId: process.env.MESSAGE_SENDER_ID,
  appId: process.env.APP_ID
};

export default {
  init() {
    firebase.initializeApp(config);
  },
  logout() {
    firebase.auth().signOut();
  },
  onAuth() {
    // リロード時、認証状態の変化時にユーザー情報を再取得
    firebase.auth().onAuthStateChanged(async user => {
      store.commit('setLoading', true);
      if (user) {
        const token = await user.getIdToken(true);
        store.dispatch('setLoginUser', { token: token, uid: user.uid });
      } else {
        store.dispatch('logout');
      }
      store.commit('setLoading', false);
    });
  }
};