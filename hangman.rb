require 'yaml'

class Hangman
	def initialize	
		load_word("5desk.txt")
		@display_word = []
		display_word
		@counter = 0
		@hanged = "    _____\n"	+ "	|\n"
		@element = ["	o\n", "	/", "\\\n", "	|\n", "	/",  "\\\n"]
		@used_letters = []
		@input = ""
	end

   
	def play
		puts @word

		user_input = ""
		while !win && !lose && user_input != "exit"
			display
			user_input = gets.chomp.downcase
			if user_input == "save"
				save
			elsif user_input.length == 1 && !@used_letters.include?(user_input)
				@used_letters << user_input
				if update(user_input)
					@msg = "\ngreat job its there"
				else
					@msg = "\nthe word does not include #{user_input}. Try another one"
					update_hang
				end
			else
				@msg = "\ninvalid!!"
				@msg = "\nLetter already has been used" if @used_letters.include? user_input
			end
		end
		save if user_input == "exit"
		@msg = "Exited and saved" if user_input == "exit"
		@msg = "\nYou have gussed the word correctly. Congartulations" if win
		@msg = "\nYou lost. Hard luck next time. The word is #{@word}" if lose
		display
	end

	def save
		File.open("save.yaml", 'w') do |file|
			file.puts YAML::dump(self)
			file.puts ""
		end
		@msg = "\nSAVED"
	end

	def load 
		while @input != "load" && @input != "new"
			print "Load or New: "
			@input = gets.chomp
		end

		content = File.read("save.yaml") 
		if @input == "load"
			obj = YAML::load(content)
			obj.play
		elsif @input == "new"
			h = Hangman.new
			h.play
		end
	end

	def load_word(filename)
		if File.exists? filename
			words = File.read(filename).split("\r\n")
			@word = words[(rand * words.length).round - 1].downcase
		end

	end
	def display

		puts @hanged
		puts display_word_str
		puts @msg
		str = "Used letters are: "
		@used_letters.each {|i| str += " #{i},"}
		puts str.chomp
	end

	def win
		return false if @display_word.include? " "
		return true
	end

	def lose
     	return true if @counter >= @element.length
		return false
	end

	def update(letter)
		word_mod = @word.clone
		if @word.include? letter.downcase
			while word_mod.include? letter
				index = word_mod.index(letter)
				#update
				word_mod[index] = "*"
				@display_word[index] = letter
			end
			return true
		end
		return false
	end

	def update_hang
		@hanged += @element[@counter] if @counter < @element.length
	 	@counter += 1
	end
	
	def display_word
		random = rand * @word.length
		random = random.round - 1
		random = 0 if random < 0
		@word.length.times { |i| @display_word << " " }
		update(@word[random])
	end

	def display_word_str
		str = "\n"
		@display_word.length.times do |i|
			if @display_word[i] == " "
				str += "_ " 
			else
				str += @display_word[i] + " "
			end
		end
		str += "\n"
	end

end

puts "I see you"
h = Hangman.new
h.load
