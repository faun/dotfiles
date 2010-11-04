require 'rake'
require 'ftools' if RUBY_VERSION < "1.9"

hostname =  `printf ${HOSTNAME%%.*}`
home = `printf $HOME`
timestamp = Time.now.strftime("%Y-%m-%d_%I-%M-%S")

task :install => 'install:files'

namespace :install do

  desc "install the dot files into user's home directory"
  task :files do

    replace_all = false
    Dir['*'].each do |file|
      next if %w[Rakefile README LICENSE bin].include? file or %r{(.*)\.pub} =~ file
    
      if File.exist?(File.join(ENV['HOME'], ".#{file}"))
        if replace_all
          replace_file(file, timestamp)
        else
          print "overwrite ~/.#{file}? [ynaq] "
          case $stdin.gets.chomp
          when 'a'
            replace_all = true
            replace_file(file, timestamp)
          when 'y'
            replace_file(file, timestamp)
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

    # link files in bin dir
    system %Q{mkdir -p "#{home}/bin"}
    system %Q{mkdir -p "$HOME/_dot_backups/#{timestamp}/bin/"}
  
    Dir['bin/*'].each do |file|
      filepath = File.expand_path("#{home}/#{file}")
      if !(File.exist? filepath) || (File.symlink? filepath)
        puts "linking ~/#{file}"
        system %Q{cp -RLi "#{home}/#{file}" "#{home}/_dot_backups/#{timestamp}/#{file}"}
        system %Q{rm "#{home}/#{file}"}
        system %Q{ln -s "$PWD/#{file}" "#{home}/#{file}"}
      else
        puts "Existing ~/#{file} exists. Skipping..." 
      end
    end
  
    # Handle ssh pubkey on its own
    orginal_filename = File.expand_path("#{home}/.ssh/id_dsa.pub")

    pubfile_exists = File.exist? orginal_filename
    pubfile_symlink = File.symlink? orginal_filename
  
    if pubfile_exists && !pubfile_symlink
      puts "Linking public ssh key"
      system %Q{mkdir -p "#{home}/.ssh/dotfiles_backup"}
      system %Q{cp "#{orginal_filename}" "#{home}/.ssh/dotfiles_backup/id_dsa.pub"}
      system %Q{mv "#{orginal_filename}" "$PWD/#{hostname}.pub"}
      system %Q{ln -s "$PWD/#{hostname}.pub" "#{orginal_filename}"}
    elsif !pubfile_exists
      puts "No existing ssh key. Exiting..."
    elsif pubfile_symlink
      puts "Existing linked ssh key. Skipping..."
    end

  end

  desc "Create symbolic link for kaleidoscope integration with git difftool"
  task :ksdiff do
    ksdiff = File.expand_path("/usr/local/bin/ksdiff-wrapper")
    opendiff = File.expand_path("/usr/bin/opendiff")
    if File.exist?(ksdiff)
      if !File.exist?(opendiff) && !File.symlink?(opendiff)
        puts "#{opendiff} doesn't exist, linking..."
        system %Q{sudo ln -s #{ksdiff} #{opendiff}}
      elsif File.exist?(opendiff) && !File.symlink?(opendiff)
        # file already exists. back it up
        puts "moving #{opendiff} to #{opendiff}_orig"
        system %Q{sudo mv #{opendiff} #{opendiff}_orig}
        puts "linking #{ksdiff} to #{opendiff}"
        system %Q{sudo ln -s #{ksdiff} #{opendiff}}
      else File.exist?(opendiff) && File.symlink?(opendiff)
        puts "file already linked"
      end
    else
      puts "please install ksdiff before runnning this tool"
    end
  end
end

def replace_file(file, timestamp)
  system %Q{mkdir -p "$HOME/_dot_backups/#{timestamp}"}
  system %Q{cp -RLi "$HOME/.#{file}" "$HOME/_dot_backups/#{timestamp}/#{file}"}
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
