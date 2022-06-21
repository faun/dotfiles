" Define av/iv to select a bash variable:
call textobj#user#plugin('bash', {
        \  'avar': {
        \   'pattern': '\$\w\+\>',
        \   'select': [ 'av'],
        \  },
        \  'ivar': {
        \   'pattern': '\$\zs\w\+\>',
        \   'select': [ 'iv'],
        \  },
        \  'var': {
        \   'pattern': ['\${', '}'],
        \   'select-i': [ 'iV'],
        \   'select-a': [ 'aV'],
        \  },
        \ })
