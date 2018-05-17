begin
  require 'spirit_hands'
  SpiritHands.hirb = false
rescue LoadError
  puts 'Could not load spirit_hands'
end

Pry.config.editor = 'vim'
Pry.config.theme = 'pry-classic'
#
# Hit Enter to repeat last command
Pry::Commands.command(/^$/, 'repeat last command') do
  _pry_.run_command Pry.history.to_a.last
end

if defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

Pry.config.pager = false if ENV['VIM']
