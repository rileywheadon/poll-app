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
          'grad-start': '#1f1f1f',
          'grad-end': '#171717',
          'polll-grad-1': '#D9EAD3', //polll logo gradient follows these 6 colors
          'polll-green': '#B6D7A8', // this is the custom green to be used on icons
          'polll-grad-3':'#A0CFB6',
          'polll-grad-4':'#97D0BF',
          'polll-grad-5':'#92D0D0',
          'polll-blue':'#88bbd0' // this is the custom blue to be used on icons

      })
    },
    /* Custom screen breakpoints*/
    screens: {
        'xs': '520px',
        'sm': '640px',
        'md': '768px',
        'lg': '1024px',
        'xl': '1536px',
      },
  },
  plugins: [],
}

