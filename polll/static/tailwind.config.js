module.exports = {
  darkMode: 'selector',
  content: ["../templates/**", "./scripts/*.js"],
  blocklist: [
    /* Ensure Plotly's classes are not purged */
    'main-svg', 
  ],
  theme: {
    extend: {
      colors: theme => ({
          /* Tailwind-like Nord color names */
          'nord-0': '#2E3440',
          'nord-1': '#3B4252',
          'nord-2': '#434C5E',
          'nord-3': '#4C566A',
          'nord-4': '#D8DEE9',
          'nord-5': '#E5E9F0',
          'nord-6': '#ECEFF4',
          'nord-7': '#8FBCBB',
          'nord-8': '#88C0D0',
          'nord-9': '#81A1C1',
          'nord-10': '#5E81AC',
          'nord-11': '#BF616A',
          'nord-12': '#D08770',
          'nord-13': '#EBCB8B',
          'nord-14': '#A3BE8C',
          'nord-15': '#B48EAD',

          // background is neutral 900
          // text is neutral-200
          'polll-white':'#f3f3f3ff',
          'polll-dgreen':'#6aa84f',

          'polll-grad-1': '#D9EAD3', //polll logo gradient follows these 6 colors
          'polll-grad-3':'#A0CFB6',
          'polll-grad-4':'#97D0BF',
          'polll-grad-5':'#92D0D0',
          'polll-green': '#B6D7A8', // this is the custom green to be used on icons
          'polll-blue':'#88bbd0', // this is the custom blue to be used on icons
          'polll-red': '#f27171', // this is the custom red to be used on icons

          'tier-S': '#ef8683',
          'tier-A': '#f5c288',
          'tier-B': '#fae08d',
          'tier-C': '#ffff91',
          'tier-D': '#ccfd8f',
          'tier-F': '#a0fc8e',
          'tier-S-lm': '#e6706d',
          'tier-A-lm': '#fabb72',
          'tier-B-lm': '#f1d16a',
          'tier-C-lm': '#e8e845',
          'tier-D-lm': '#9dd854',
          'tier-F-lm': '#66cd52'
      })
    },
    /* Custom screen breakpoints*/
    screens: {
        'xs': '520px',
        'sm': '640px',
        'md': '768px',
        'lg': '960px',
        'xl': '1536px',
      },
  },
  plugins: [],
}

