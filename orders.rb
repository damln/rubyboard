class Orders
  def sublime
    cmd = "tell application \"sublime text\" to activate"
    system "osascript -e '#{cmd}'"
  end

  def chrome
    cmd = "tell application \"chrome\" to activate"
    system "osascript -e '#{cmd}'"
  end

  def iterm
    cmd = "tell application \"iTerm\" to activate"
    system "osascript -e '#{cmd}'"
  end

  def finder_home
    cmd = "tell application \"Finder\"\n open home\n activate\n end tell"
    system "osascript -e '#{cmd}'"
  end

  def finder_downloads
    cmd = "tell application \"Finder\"\n open folder \"Downloads\" of home\n activate\nend tell"
    system "osascript -e '#{cmd}'"
  end

  def deploy_prod_fast
    dir = self.working_directory_by_program("rails")
    cmd = "bundle exec rake deploy:prod:fast"
    ouput = self.command_in_directory!(cmd, dir)
    puts ouput
    puts "............. deploy_prod_fast: DONE."
  end

  def deploy_test_fast
  #   cmd = "bundle exec rake deploy:test:fast"
  #   system cmd
  #   puts "............. deploy_test_fast: DONE."
  end

  def gulp_build
    dir = self.working_directory_by_program("gulp")
    cmd = "gulp build"
    ouput = self.command_in_directory!(cmd, dir)
    puts ouput
    puts "............. gulp_build: DONE."
  end

  protected

  def pid_by_name(name)
    cmd = "ps aux | grep #{name} | grep -v grep | awk '{print $2}'"
    `#{cmd}`.strip.split("\n").first
  end

  def working_directory_by_pid(pid)
    cmd = "lsof -p #{pid} | grep cwd  | awk '{print $9}'"
    `#{cmd}`.strip.split("\n").first
  end

  def working_directory_by_program(name)
    pid = pid_by_name(name)
    self.working_directory_by_pid(pid)
  end

  def kill_process_by_pid!(pid)
    `kill -9 #{pid}`
  end

  def command_in_directory!(cmd, directory)
    `source "$HOME/.rvm/scripts/rvm" && cd #{directory} && #{cmd}`.strip
  end
end
