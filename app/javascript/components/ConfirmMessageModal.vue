<template>
  <b-modal id="modal-confirm-message" hide-header ok-only @hidden="resetModal">
    <p class="my-4">{{ confirmMessage }}</p>
  </b-modal>
</template>
<script>
import { mapState, mapMutations } from "vuex";

export default {
  computed: mapState(["confirmMessage"]),
  methods: {
    ...mapMutations(["setConfirmMessage"]),
    resetModal() {
      this.setConfirmMessage("");
    }
  }
};
</script>

<style scoped></style>