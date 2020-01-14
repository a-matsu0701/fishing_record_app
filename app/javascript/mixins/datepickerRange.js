import moment from "moment";

export const datepickerRange = {
  computed: {
    start() {
      //日時の選択可能範囲を５０年前までに指定
      const start = moment().add(-50, "years");
      return start.format("YYYY-MM-DDTHH:mm:ss");
    },
    end() {
      //日時の選択可能範囲を現在までに指定
      const end = moment();
      return end.format("YYYY-MM-DDTHH:mm:ss");
    }
  }
}