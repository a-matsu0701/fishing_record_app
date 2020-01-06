export const i18n = {
  methods: {
    t: (...args) => I18n.t(...args),
    currentLocale: () => I18n.currentLocale()
  }
};