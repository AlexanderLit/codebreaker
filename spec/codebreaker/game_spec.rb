
require 'spec_helper'

RSpec.configure do |c|
  c.alias_example_to :user
end

module Codebreaker
  describe Game do
    let(:output) { double('output').as_null_object }
    let(:game)   { Game.new(output) }

    describe "#start" do
      it "sends a welcome message" do
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.start
      end

      it "prompts for the first guess" do
        output.should_receive(:puts).with('Enter guess:')
        game.start
      end
    end
	
	describe "#game_restart" do
      before(:each) do
		@output = double('output').as_null_object
		@game = Game.new(@output)
	  end
	  user "plays again" do
		@game.should_receive(:start)
		@game.game_restart(true)
	  end
	  user "finishes playing" do
		@output.should_receive(:puts).with('Bye.')
		@game.game_restart(false)
	  end
	end
	
	describe "#save_score" do
		before(:each) do
			@output = double('output').as_null_object
			@game = Game.new(@output)
			@game.instance_eval('@guess_arr = ["1234","1234","1234","1234"]')
		end
		user "prompted to play again" do
			file = mock('file').as_null_object
			File.should_receive(:new).with("#{@game.instance_variable_get(:@dir)}/score.txt", "a").and_return(file)
			@output.should_receive(:puts).with('Another go?')
			@game.save_score("Alex")
		end
		it "saves the score" do
			file = mock('file').as_null_object
			File.should_receive(:new).with("#{@game.instance_variable_get(:@dir)}/score.txt", "a").and_yield(file)
			file.should_receive(:<<).with("Alex\n").ordered
			file.should_receive(:<<).with("1234,1234,1234,1234\n").ordered
			@game.save_score("Alex")
		end
		# it "saves the score" do
		# 	file = mock('file').as_null_object
		# 	File.should_receive(:new).with("#{@game.instance_variable_get(:@dir)}/score.txt", "a").and_return(file)
		# 	file.should_receive(:puts).with("Alex\n").ordered
		# 	file.should_receive(:puts).with("1234,1234,1234,1234\n").ordered
		# 	@game.save_score("Alex")
		# end
	end
	
	describe "#hint" do
		before(:each) do
			@output = double('output').as_null_object
			@game = Game.new(@output)
			@game.stub(:generate).and_return('5645')
			@game.start
		end
		user "asks for a hint" do
			  @output.should_receive(:puts).with('5???')
			  @output.should_receive(:puts).with('56??')
			  @output.should_receive(:puts).with('564?')
			  @output.should_receive(:puts).with('5645').exactly(2).times
			  5.times do
				@game.hint
			  end
		  end
	end
	
	describe "#guess" do
     	before(:each) do
			@output = double('output').as_null_object
			@game = Game.new(@output)
			@game.stub(:generate).and_return('5645')
			@game.start
		end
		  user "loses the game" do
			@output.should_receive(:puts).with("You've lost.").ordered
			@output.should_receive(:puts).with("Code was: 5645").ordered
			5.times do
				@game.guess('2533')
			end
		  end
		  user "wins the game" do
		    @output.should_receive(:puts).with('You won!')
			@game.guess('5645')
		  end
		  user "prompted to enter name after losing" do
			@output.should_receive(:puts).with('Please enter your name to save the score.')
			5.times do
				@game.guess('2533')
			end
		  end
		  user "prompted to enter name after winning" do
			@output.should_receive(:puts).with('Please enter your name to save the score.')
			@game.guess('5645')
		  end
      end
  end
end