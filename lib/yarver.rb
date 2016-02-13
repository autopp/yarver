require 'yarver/version'
require 'thor'

# Module Yarver provides previewer YARV's bytecode
#
# @author autopp <autopp.inc@gmail.com>
#
class Yarver < Thor
  # declare compile options
  COMPILE_OPTIONS_MAP = RubyVM::InstructionSequence.each_with_object({}) do |vm_opt, map|
    map[vm_opt] = vm_opt.to_s.gsub('_', '-').to_sym
  end

  COMPILE_OPTIONS_MAP.delete(:debug_level)

  RubyVM::InstructionSequence.each do |vm_opt, default|
    cli_opt = COMPILE_OPTIONS_MAP[vm_opt]
    description = "Switch #{cli_option.gsub('-', ' ')} (Default: #{default ? 'on' : 'off'})"
    option cli_opt, desc: description, type: :boolean, default: default
  end

  default_debug_level = RubyVM::InstructionSequence.compile_option[:debug_level]
  option :debug,
    desc: "Set debug level (Default: #{default_debug_level})", type: :integer, default: default_debug_level

  desc 'run FILE', "show bytecode of FILE"
  def run(filename)
    compile_option = RubyVM::InstructionSequence.each_key.with_object({}) do |vm_opt, hash|
      hash[vm_opt] = options[COMPILE_OPTIONS_MAP[vm_opt]]
    end
    compile_option[:debug_level] = options[:debug_level]

    puts RubyVM::InstructionSequence.compile_file(filename, compile_option).disasm
  end
end
