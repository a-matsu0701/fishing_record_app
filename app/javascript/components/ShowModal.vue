<template>
  <b-modal id="modal-show" centered title="Detail">
    <b-container>
      <div>
        <b-carousel
          id="carousel-fade"
          style="text-shadow: 0px 0px 2px #000"
          fade
          indicators
          img-width="1024"
          img-height="480"
        >
          <b-carousel-slide
            caption="First slide"
            img-src="https://picsum.photos/1024/480/?image=10"
          ></b-carousel-slide>
          <b-carousel-slide
            caption="Second Slide"
            img-src="https://picsum.photos/1024/480/?image=12"
          ></b-carousel-slide>
          <b-carousel-slide
            caption="Third Slide"
            img-src="https://picsum.photos/1024/480/?image=22"
          ></b-carousel-slide>
        </b-carousel>
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
  </b-modal>
</template>

<script>
import moment from "moment";
import Vue from "vue";

export default {
  name: "BookShow",
  props: {
    postInfo: {
      type: Object
    }
  }
};
</script>

<style scoped></style>