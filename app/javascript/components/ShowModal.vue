<template>
  <b-modal
    id="modal-show"
    title="Detail"
    ok-title="close"
    ok-variant="secondary"
    ok-only
    centered
    @close="$emit('close')"
    @cancel="$emit('close')"
    @hide="$emit('close')"
  >
    <b-alert v-if="message.length != 0" variant="success" dismissible show>{{ message }}</b-alert>
    <b-container>
      <div>
        <b-img :src="postInfo.show_img_path" fluid></b-img>
      </div>
      <h3 class="mt-4">Data</h3>
      <b-row class="mt-3">
        <b-col cols="3">Title</b-col>
        <b-col>{{ postInfo.title }}</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Date</b-col>
        <b-col>{{ postInfo.date | dateFormat }}</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Size</b-col>
        <b-col>{{ postInfo.size }}cm</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Weight</b-col>
        <b-col>{{ postInfo.weight }}グラム</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Number</b-col>
        <b-col>{{ postInfo.number }}匹</b-col>
      </b-row>
      <b-row class="mt-2">
        <b-col cols="3">Comment</b-col>
        <b-col>{{ postInfo.comment }}</b-col>
      </b-row>
    </b-container>
    <div class="text-right mt-3">
      <b-button @click="editPost" size="sm" variant="success">Edit</b-button>
    </div>
  </b-modal>
</template>

<script>
export default {
  props: {
    postInfo: {
      type: Object
    },
    message: {
      type: String
    }
  },
  methods: {
    editPost: function() {
      this.$emit("edit", this.postInfo.id);
    }
  }
};
</script>

<style scoped></style>