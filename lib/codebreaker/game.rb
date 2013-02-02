
module Codebreaker
  class Game
    def initialize(output)
      @output = output
	  @dir = File.dirname(__FILE__)
    end

    def start
	# interact_with_user method variables initialization
	  @number_o_tries = 0
	# hint method variables initialization
	  @character_to_reveal = 0
	  @hint = "????"
	  
      @secret = generate
      @output.puts 'Welcome to Codebreaker!'
      @output.puts 'Enter guess:'
    end

    def guess(guess)
	  @guess_arr = []
      @marker = Marker.new(@secret, guess)
	  interact_with_user
	  @guess_arr << guess
    end
	
	def game_restart(ans)
	  ans ? start : (@output.puts 'Bye.')
	end
	
	def hint
	  @hint[@character_to_reveal] = @secret[@character_to_reveal]
	  @output.puts @hint
	  if @character_to_reveal < 3
		@character_to_reveal += 1
	  end
	end
	
	# def save_score(name)
 #      @outFile = File.new("#{@dir}/score.txt", "a")
 #      @outFile.puts("#{name}\n")
	#   @outFile.puts("#{@guess_arr.join(",")}\n")
	#   @outFile.close
	#   @output.puts 'Another go?'
	# end
	
	def save_score(name)
      File.new("#{@dir}/score.txt", "a") do |file|
		file << ("#{name}\n")
		file << ("#{@guess_arr.join(",")}\n")
	  end
	  @output.puts 'Another go?'
	end
	
	private
	
	def interact_with_user
	  @number_o_tries += 1
	  if @number_o_tries == 5 && !(@marker.mark == 'You won!')
		@output.puts "You've lost."
		@output.puts "Code was: " + @secret
		@output.puts "Please enter your name to save the score."
	  else
	    @output.puts @marker.mark
		if @marker.mark == 'You won!'
		@output.puts "Please enter your name to save the score."
		end
	  end
	end
	
    def generate
      secret_code = ''
      4.times do
        secret_code << rand(6)
      end
      secret_code
    end
  end
end