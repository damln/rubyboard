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
puts "Start MIDI"

inputs = UniMIDI::Input.all
inputs.each do |input|
  puts "INPUT: #{input}"
  puts "INPUT name: #{input.name}"
  puts "INPUT pretty_name: #{input.pretty_name}"
  puts "INPUT type: #{input.type}"

  MIDI.using(input) do
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

    receive :aftertouch do |message|
      puts("---------> aftertouch")
      puts(message)
    end

    receive :channel_aftertouch do |message|
      puts("---------> channel_aftertouch")
      puts(message)
    end

    receive :control_change do |message|
      puts("---------> control_change, value: #{message.data}")
      puts("---------> control_change, value: #{message.channel}")
      puts("---------> control_change, value: #{message.name}")
      dynamic_load
      Keyboard.new.run(message)
    end

    receive :note do |message|
      puts("---------> note, value: #{message.note_name}")
      dynamic_load
      Keyboard.new.run(message)
    end

    receive :note_on do |message|
      puts("---------> note_on, value: #{message.note_name}")
      puts(message)
    end

    receive :note_off do |message|
      puts("---------> note_off, value: #{message.note_name}")
      puts(message)
    end

    receive :pitch_bend do |message|
      puts("---------> pitch_bend, value: #{message.data}")
      puts("---------> pitch_bend, value: #{message.channel}")
      puts(message)
    end

    receive :polyphonic_aftertouch do |message|
      puts("---------> polyphonic_aftertouch")
      puts(message)
    end

    receive :program_change do |message|
      puts("---------> program_change")
      puts(message)
    end

    join
  end
end
