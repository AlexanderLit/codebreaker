
module Codebreaker
  class Marker
  
    CODEBREAKER_WINS_MESSAGE = 'You won!'
	
    def initialize(secret, guess)
    @secret = secret 
	@guess = guess
    @secret = @secret.split('')
    @guess = @guess.split('')
    end

    def exact_match_count
      if !@exact_match_counter
        count = 0
        4.times do |index|
          count += (exact_match?(index) ? 1 : 0)
        end
        @exact_match_counter = count
      end
      @exact_match_counter
    end

    def number_match_count
      total_match_count - exact_match_count
    end

    def total_match_count
      if !@total_match_counter
        count = 0
        @secret_arr = @secret.dup
        @guess.map do |n|
          if @secret_arr.include?(n)
            @secret_arr.delete_at(@secret_arr.index(n))
            count += 1
          end
        end
      @total_match_counter = count
      end
      @total_match_counter
    end

    def exact_match?(index)
      @guess[index] == @secret[index]
    end

    def number_match?(index)
      @secret.include?(@guess[index]) && !exact_match?(index)
    end
	
	def full_match
	  @guess == @secret
	end
	
	def mark
		return full_match ? CODEBREAKER_WINS_MESSAGE : '-'*number_match_count + '+'*exact_match_count
	end
  end
end