class MAIN

create {ANY}
  make

feature {ANY}

  make
    local
      program: ARRAY[INSTRUCTION]
      state: STATE
    do
      program := parse_input
      from
        create state.initial(program)
      until
        state.is_done
      loop
        state.get_next_instruction.execute(state)
      end
      print(state.get_last_sound_frequency.to_string + "%N")
    end

feature {}

  parse_input: ARRAY[INSTRUCTION]
    local
      program: ARRAY[INSTRUCTION]
    do
      create program.make(0, -1)
      from
        std_input.read_line
      until std_input.end_of_input
      loop
        program.add_last(parse_instruction(std_input.last_string))
        std_input.read_line
      end
      Result := program
    ensure
      no_void_instructions: not Result.fast_has(Void)
    end

  parse_instruction(str: STRING): INSTRUCTION
    local
      parts: ARRAY[STRING]
    do
      parts := str.split
      inspect parts @ 1
      when "snd" then
        create {SND_INSTRUCTION} Result.make(parse_value(parts @ 2))
      when "set" then
        create {SET_INSTRUCTION} Result.make(parts @ 2, parse_value(parts @ 3))
      when "add" then
        create {ADD_INSTRUCTION} Result.make(parts @ 2, parse_value(parts @ 3))
      when "mul" then
        create {MUL_INSTRUCTION} Result.make(parts @ 2, parse_value(parts @ 3))
      when "mod" then
        create {MOD_INSTRUCTION} Result.make(parts @ 2, parse_value(parts @ 3))
      when "rcv" then
        create {RCV_INSTRUCTION} Result.make(parts @ 2)
      when "jgz" then
        create {JGZ_INSTRUCTION} Result.make(parse_value(parts @ 2), parse_value(parts @ 3))
      end
    ensure
      instruction_parsed: Result /= Void
    end

  parse_value(str: STRING): VALUE
    do
      if str.is_integer then
        create {CONSTANT_VALUE} Result.make(str.to_integer)
      else
        create {REGISTER_VALUE} Result.make(str)
      end
    ensure
      value_parsed: Result /= Void
    end

end

-- class SND
-- inherit INSTRUCTION
-- end
-- 
-- class SET
-- inherit INSTRUCTION
-- end
-- 
-- class ADD
-- inherit INSTRUCTION
-- end
-- 
-- class MUL
-- inherit INSTRUCTION
-- end
-- 
-- class MOD
-- inherit INSTRUCTION
-- end
-- 
-- class RCV
-- inherit INSTRUCTION
-- end
-- 
-- class JGZ
-- inherit INSTRUCTION
-- end
