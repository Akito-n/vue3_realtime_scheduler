module.exports = {
  purge: [],
  theme: {
    extend: {
      maxWidth: {
        '3/4': '75%'
      }
    }
  },
  variants: {},
  plugins: [
    function ({ addUtilities }) {
      const cellUtilities = {}
      for (let i = 1; i <= 48; i++) {
        cellUtilities[`.cell-h-${i}`] = {
          height: 2.5 * i + 'rem'
        }
      }

      addUtilities(cellUtilities)
    }
  ]
}
