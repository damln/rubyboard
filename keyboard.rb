class Keyboard
  # This is only used because of the GB/F# problem and EB/D# problem:
  PRE_MAPPING = {
    "C" => "C",
    "D" => "D",
    "E" => "E",
    "F" => "F",
    "G" => "G",
    "A" => "A",
    "B" => "B",

    "C#" => "C#",
    "EB" => "EB",
    "D#" => "EB", # here
    "F#" => "F#",
    "GB" => "F#", # here
    "AB" => "AB",
    "A#" => "A#",
  }

  # You map your notes to methods:
  MAPPING = {
    sublime: %w(C),
    chrome: %w(D),
    iterm: %w(E),
    finder_home: %w(F),
    finder_downloads: %w(G),

    gulp_build: %w(C#),
    deploy_test_fast: %w(EB),
    deploy_prod_fast: %w(F#),
  }

  def run(message)
    return run_command(message) if message.class.name =~ /ControlChange/
    # because it's key "off" and we have velocity:
    return nil if message.velocity == 0
    return run_note(message) if message.class.name =~ /Note/
  end

  def run_note(message)
    note = PRE_MAPPING[message.note_name.upcase]
    puts("--> run_note #{note}")

    # Looping over all the mapping
    MAPPING.each do |func, chord|
      # check if the current cord is included
      if chord.include?(note)
        begin
          puts "Orders.new.send(#{func}.to_sym)"
          # # spin up a now thread for each command
          Thread.new do
            # meta prog to execute commands on the clas "Orders"
            if ENV["RUBY_ENV"] == "debug"
              puts "Will execute: Orders.new.#{func}"
            else
              Orders.new.send(func.to_sym)
            end
          end
        rescue Exception => e
          puts "This function does not exist."
        end
      end
    end
  end

  def run_command(message)
    # TODO
  end
end
