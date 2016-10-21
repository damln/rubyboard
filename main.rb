require 'stringio'
def silent_warnings
  old_stderr = $stderr
  $stderr = StringIO.new
  yield
ensure
  $stderr = old_stderr
end

# used to reload your code without restarting the script:
def dynamic_load
  silent_warnings do
    load "./orders.rb"
    load "./keyboard.rb"
  end
end
#=======================
require 'rubygems'
require 'bundler/setup'
require "midi"
dynamic_load
#===========================
#  Global variables are bad but this is a script not a production critical app...
# This array is used to map chors (multiple notes played at once)
$global_buffer = []

puts "Start MIDI"

inputs = UniMIDI::Input.all
inputs.each do |input|
  puts "INPUT: #{input}"
  puts "INPUT name:        #{input.name}"
  puts "INPUT pretty_name: #{input.pretty_name}"
  puts "INPUT type:        #{input.type}"

  # FROM the code of "micromidi"
  # case type.to_sym
  # when :aftertouch, :pressure, :aft then [MIDIMessage::ChannelAftertouch, MIDIMessage::PolyphonicAftertouch]
  # when :channel_aftertouch, :channel_pressure, :ca, :cp then MIDIMessage::ChannelAftertouch
  # when :control_change, :cc, :c then MIDIMessage::ControlChange
  # when :note, :n then [MIDIMessage::NoteOn, MIDIMessage::NoteOff]
  # when :note_on, :nn then MIDIMessage::NoteOn
  # when :note_off, :no, :off then MIDIMessage::NoteOff
  # when :pitch_bend, :pb then MIDIMessage::PitchBend
  # when :polyphonic_aftertouch, :poly_aftertouch, :poly_pressure, :polyphonic_pressure, :pa, :pp then MIDIMessage::PolyphonicAftertouch
  # when :program_change, :pc, :p then MIDIMessage::ProgramChange
  # end

  # input = UniMIDI::Input.all[0]
  MIDI.using(input) do
    receive :aftertouch do |message|
      puts("_________________________ aftertouch")
      # puts(message)
    end

    receive :channel_aftertouch do |message|
      puts("_________________________ channel_aftertouch")
      # puts(message)
    end

    receive :control_change do |message|
      puts("_________________________ control_change:")
      puts("---------> control_change, message.data:    #{message.data}")
      puts("---------> control_change, message.channel: #{message.channel}")
      puts("---------> control_change, message.name:    #{message.name}")
      dynamic_load
      Keyboard.new.run(message)
    end

    receive :note do |message|
      # Velocity 0 is when note is "off":
      if message.velocity > 0
        puts("_________________________ note:")
        puts("---------> note, message.data:      #{message.data}")
        puts("---------> note, message.channel:   #{message.channel}")
        puts("---------> note, message.note:      #{message.note}")
        puts("---------> note, message.note_name: #{message.note_name}")
        puts("---------> note, message.velocity:  #{message.velocity}")
        puts("---------> note, message.octave:    #{message.octave}")
        puts("---------> note, message.status:    #{message.status}")
        dynamic_load
        Keyboard.new.run(message)
      else
        # Reset buffer on off and big:
        # $global_buffer = [] if $global_buffer.size > 5
      end
    end

    receive :off do |message|
      puts("_________________________ off:")
      puts("---------> off, message.channel:   #{message.channel}")
      puts("---------> off, message.note:      #{message.note}")
      puts("---------> off, message.note_name: #{message.note_name}")
      puts("---------> off, message.velocity:  #{message.velocity}")
      puts("---------> off, message.octave:    #{message.octave}")
    end
    # receive :note_on do |message|
    #   puts("---------> note_on, value: #{message.note_name}")
    #   puts(message)
    # end
    # receive :note_off do |message|
    #   puts("---------> note_off, value: #{message.note_name}")
    #   puts(message)
    # end
    receive :pitch_bend do |message|
      puts("_________________________ pitch_bend:")
      puts("---------> pitch_bend, message.data:    #{message.data}")
      puts("---------> pitch_bend, message.channel: #{message.channel}")
      # puts(message)
    end

    receive :polyphonic_aftertouch do |message|
      puts("_________________________ polyphonic_aftertouch")
      # puts(message)
    end

    receive :program_change do |message|
      puts("_________________________ program_change")
      # puts(message)
    end

    join
  end
end

