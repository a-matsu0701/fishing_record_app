<template>
  <div>
    <b-navbar fixed="top" toggleable="lg" type="dark" variant="info">
      <b-navbar-brand href="#">Anglur's Memory</b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-navbar-nav>
            <b-nav-item v-b-modal.modal-create>投稿する</b-nav-item>
          </b-navbar-nav>

          <b-navbar-nav>
            <b-nav-item href="#">Sign In</b-nav-item>
          </b-navbar-nav>

          <b-nav-item-dropdown right>
            <template v-slot:button-content>
              <em>User</em>
            </template>
            <b-dropdown-item href="#">Profile</b-dropdown-item>
            <b-dropdown-item href="#">Sign Out</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<script></script>
<style scoped></style>