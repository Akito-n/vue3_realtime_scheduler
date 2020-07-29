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
      const cellUtilities = {
        '.cell-h-1': {
          height: '2.5rem'
        },
        '.cell-h-2': {
          height: '5rem'
        },
        '.cell-h-3': {
          height: '7.5rem'
        },
        '.cell-h-4': {
          height: '10rem'
        },
        '.cell-h-5': {
          height: '12.5rem'
        },
        '.cell-h-6': {
          height: '15rem'
        },
        '.cell-h-7': {
          height: '17.5rem'
        },
        '.cell-h-8': {
          height: '20rem'
        },
        '.cell-h-9': {
          height: '22,5rem'
        },
        '.cell-h-10': {
          height: '25rem'
        },
        '.cell-h-11': {
          height: '27.5rem'
        },
        '.cell-h-12': {
          height: '30rem'
        },
        '.cell-h-13': {
          height: '32.5rem'
        },
        '.cell-h-14': {
          height: '35rem'
        },
        '.cell-h-15': {
          height: '37.5rem'
        },
        '.cell-h-16': {
          height: '40rem'
        },
        '.cell-h-17': {
          height: '42.5rem'
        },
        '.cell-h-18': {
          height: '45rem'
        },
        '.cell-h-19': {
          height: '47.5rem'
        },
        '.cell-h-20': {
          height: '50rem'
        },
        '.cell-h-21': {
          height: '52.5rem'
        },
        '.cell-h-22': {
          height: '55rem'
        },
        '.cell-h-23': {
          height: '57.5rem'
        },
        '.cell-h-24': {
          height: '60rem'
        },
        '.cell-h-25': {
          height: '62.5rem'
        },
        '.cell-h-26': {
          height: '65rem'
        },
        '.cell-h-27': {
          height: '67.5rem'
        },
        '.cell-h-28': {
          height: '70rem'
        },
        '.cell-h-29': {
          height: '72.5rem'
        },
        '.cell-h-30': {
          height: '75rem'
        },
        '.cell-h-31': {
          height: '77.5rem'
        },
        '.cell-h-32': {
          height: '80rem'
        },
        '.cell-h-33': {
          height: '82.5rem'
        },
        '.cell-h-34': {
          height: '85rem'
        },
        '.cell-h-35': {
          height: '87.5rem'
        },
        '.cell-h-36': {
          height: '90rem'
        },
        '.cell-h-37': {
          height: '92.5rem'
        },
        '.cell-h-38': {
          height: '95rem'
        },
        '.cell-h-39': {
          height: '97.5rem'
        },
        '.cell-h-40': {
          height: '100rem'
        },
        '.cell-h-41': {
          height: '102.5rem'
        },
        '.cell-h-42': {
          height: '105rem'
        },
        '.cell-h-43': {
          height: '107.5rem'
        },
        '.cell-h-44': {
          height: '110rem'
        },
        '.cell-h-45': {
          height: '112.5rem'
        },
        '.cell-h-46': {
          height: '115rem'
        },
        '.cell-h-47': {
          height: '117.5rem'
        },
        '.cell-h-48': {
          height: '120rem'
        },
        '.text-shadow-lg': {
          textShadow: '0px 5px 3px darkgrey'
        },
        '.text-shadow-xl': {
          textShadow: '0px 7px 3px darkgrey'
        },
        '.text-shadow-2xl': {
          textShadow: '0px 10px 3px darkgrey'
        },
        '.text-shadow-none': {
          textShadow: 'none'
        }
      }

      addUtilities(cellUtilities)
    }
  ]
}
