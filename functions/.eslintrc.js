module.exports = {
  parser: "babel-eslint",
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    quotes: ["error", "double"],
    "indent": 0,
    "no-var": 0,
    "spaced-comment": 0,
    "no-trailing-spaces": 0,
    "quote-props": 0,
    "no-multi-spaces": 0,
  },
};
