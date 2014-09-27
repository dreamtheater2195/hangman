require 'yaml'
class Hangman	
	def initialize
		@turn_left = 6
		@chosen_word = pick_random_line
		@word = @chosen_word.split('')
		@display = Array.new(@word.length - 1,'_') #word.length-1 because there are \n at the end
		@misses = ""
	end

	def pick_random_line #sample : random line
		chosen_line = nil.to_s
		while (chosen_line.length < 5 || chosen_line.length > 10)
			chosen_line = File.readlines("5desk.txt").sample.downcase
		end
		chosen_line
	end

	def play
		loop do
			print_board
			guess
			puts ""
			if (@display.none? {|i| i == '_'}) && (@turn_left > 0)
				print_board
				puts "Congrats! You win !"
				return
			elsif (@turn_left == 0)
				puts "Sorry, you lose, the word is #{@chosen_word}"
				return
			end
		end 
	end

	def print_board
		@display.each {|i| print "#{i} "}
		puts ""
		puts "Misses: #{@misses}"
		puts "Turns Remaining: #{@turn_left}"
	end

	def guess
		print "Enter guess:"
		guess = gets.chomp
		if guess == 'save'
			save_game
			puts "Game has been saved!"
		else
			check_guess(guess)
		end
	end

	def check_guess(g)
		if @word.include?(g)
			@word.each_with_index do |ch,index|
				if @word[index] == g
					@display[index] = g
				end
			end
		else
			@misses << " #{g}" 
			@turn_left -= 1
		end
	end
end
	
def save_game
	Dir.mkdir('games') unless Dir.exist? "games"
	filename = 'games/save.yaml'
	File.open(filename,'w') do |file|
		file.puts YAML::dump(self)
	end
end

def load_game
	content = File.open('games/save.yaml','r') do |file|
		file.read
	end
	YAML::load(content)
end

def valid_answer(q)
	input = ''
	until input == 'y' || input == 'n'
		print q
		input = gets.chomp
	end
	input
end
puts "WELCOME TO HANGMAN"
loop do
	input = valid_answer('Do you want to load previously saved game (y/n)? ')
	puts "You can save game at any time by typing 'save'."
	game = input == 'y' ? load_game : Hangman.new
	game.play
	input2 = valid_answer('Play another game (y/n)?')
	break if input2 == 'n'
end









		



