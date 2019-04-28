let test#typescript#mocha#file_pattern = '\v?/.*\.spec\.(js|jsx|coffee|ts)$'
let test#typescript#mocha#executable = './node_modules/.bin/mocha -r ts-node/register'
let g:test#custom_transformations = {'typescript': function('TypeScriptTransform')}
let g:test#transformation = 'typescript'
