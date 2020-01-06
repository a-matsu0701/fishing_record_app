<template>
  <div>
    <b-navbar fixed="top" toggleable="lg" type="dark" variant="info">
      <b-navbar-brand>{{ dictionaryWords.words.app_title }}</b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-navbar-nav>
            <b-button v-b-modal.modal-create size="sm">{{ dictionaryWords.button.create }}</b-button>
          </b-navbar-nav>

          <!-- TODO: ユーザ認証機能実装 -->
          <!-- <b-navbar-nav>
            <b-nav-item href="#">Sign In</b-nav-item>
          </b-navbar-nav>

          <b-nav-item-dropdown right>
            <template v-slot:button-content>
              <em>User</em>
            </template>
            <b-dropdown-item href="#">Profile</b-dropdown-item>
            <b-dropdown-item href="#">Sign Out</b-dropdown-item>
          </b-nav-item-dropdown>-->
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<script>
export default {
  props: {
    dictionaryWords: {
      type: Object
    }
  }
};
</script>
<style scoped></style>