module.exports = {
  content: ["../templates/**"],
  blocklist: [
    'main-svg', // Ensure Plotly's classes are not purged
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}

