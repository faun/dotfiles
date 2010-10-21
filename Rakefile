require 'rake'
require 'ftools' if RUBY_VERSION < "1.9"

hostname =  `printf ${HOSTNAME%%.*}`
home = `printf $HOME`

desc "install the dot files into user's home directory"
task :install do

  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE].include? file or %r{(.*)\.pub} =~ file
    
    
    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
	
  # Handle ssh pubkey on its own
	orginal_filename = File.expand_path("#{home}/.ssh/id_dsa.pub")

	pubfile_exists = File.exist? orginal_filename
	pubfile_symlink = File.symlink? orginal_filename
	
	if pubfile_exists && !pubfile_symlink
		puts "Linking public ssh key"
		system %Q{mkdir -p "$HOME/.ssh/dotfiles_backup"}
		system %Q{cp "#{orginal_filename}" "$HOME/.ssh/dotfiles_backup/id_dsa.pub"}
		system %Q{mv "#{orginal_filename}" "$PWD/#{hostname}.pub"}
		system %Q{ln -s "$PWD/#{hostname}.pub" "#{orginal_filename}"}
	elsif !pubfile_exists
		puts "No existing ssh key. Exiting..."
	elsif pubfile_symlink
		puts "Existing linked ssh key. Skipping..."
	end

end

desc "Setup other user environment settings"
task :setup do
	
end


def replace_file(file)
	timestamp = Time.now.strftime("%Y-%m-%d")
	system %Q{mkdir -p "$HOME/dot_backups_#{timestamp}"}
  system %Q{cp -RLi "$HOME/.#{file}" "$HOME/dot_backups_#{timestamp}/#{file}"}
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
