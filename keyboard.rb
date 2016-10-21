class Keyboard
  DELAY_BETWEEN_NOTES = 0.5

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

  CHORDS = {
    "CM" => %w(C E G),
    "DM" => %w(D F# A),
    "EM" => %w(E AB B),
    "FM" => %w(F A C),
    "GM" => %w(G B D),
    "AM" => %w(A C# E),
    "BM" => %w(B EB F#),

    "Cm" => %w(C EB G),
    "Dm" => %w(D F A),
    "Em" => %w(E G B),
    "Fm" => %w(F AB C),
    "Gm" => %w(G A# D),
    "Am" => %w(A C E),
    "Bm" => %w(B D F#),
  }

  # You map your notes to methods:
  MAPPING = {
    sublime: %w(C),
    chrome: %w(D),
    iterm: %w(E),
    finder_home: %w(F),
    finder_downloads: %w(G),

    # gulp_build: %w(C#),
    # deploy_test_fast: %w(EB),
    # deploy_prod_fast: %w(F#),

    next_slide: %w(C#),
    previous_slide: %w(EB),

    # Some CHORDS:
    test_chord_1: CHORDS["CM"],
    test_chord_2: CHORDS["DM"],
    test_chord_3: CHORDS["EM"],
    test_chord_4: CHORDS["FM"],
    test_chord_5: CHORDS["GM"],
    test_chord_6: CHORDS["AM"],
    test_chord_7: CHORDS["BM"],

    test_chord_8: CHORDS["Cm"],
    test_chord_9: CHORDS["Dm"],
    test_chord_10: CHORDS["Em"],
    test_chord_11: CHORDS["Fm"],
    test_chord_12: CHORDS["Gm"],
    test_chord_13: CHORDS["Am"],
    test_chord_14: CHORDS["Bm"],
  }

  def run(message)
    return run_command(message) if message.class.name =~ /ControlChange/
    # because it's key "off" and we have velocity:
    return nil if message.velocity == 0
    return run_note(message) if message.class.name =~ /Note/
  end

  # Used to create a buffer of notes
  def chord_or_notes
    to_return = []
    three_last_notes = $global_buffer.last(3)

    three_last_notes.each do |note_data|
      # we add the note to the buffer:
      if note_data[:time].to_f > Time.now.to_f - DELAY_BETWEEN_NOTES
        to_return << note_data[:note]
      end
    end

    to_return
  end

  def run_note(message)
    note = PRE_MAPPING[message.note_name.upcase]
    puts("--> run_note #{note}")

    $global_buffer << {note: note, time: Time.now}
    buffer = self.chord_or_notes
    puts "BUFFER: #{buffer}"

    # Looping over all the mapping
    MAPPING.each do |func, chord|
      # check if the current cord is included
      mapping_matched = chord.sort == buffer.sort

      if mapping_matched
        puts "[EXECUTE] Orders.new.send(#{func}.to_sym)"

        begin
          # # spin up a now thread for each command
          Thread.new do
            # meta prog to execute commands on the clas "Orders"
            if ENV["RUBY_ENV"] != "debug"
              Orders.new.send(func.to_sym)
            end
          end
        rescue Exception => e
          puts "/!\\ This function does not exist."
        end
      end
    end
  end

  def run_command(message)
    # TODO.
    # Play with volume change and pitch_bend for example.
  end
end
