class Hangman
  attr_reader :word, :guesses, :correct_guesses, :guess_list, :correct_letters

  def initialize
    @word = generate_word
    @correct_letters = @word.split('')
    @correct_guesses = []
    @guess_list = []
    @guesses = 0
  end

  def generate_word
    words = []
    lines = File.readlines('5desk.txt')
    lines.each do |line|
      line = line.chomp
      words.push(line) if line.length > 5 && line.length < 13
    end
    words[rand(0..words.length)].downcase
  end

  def place_letters
    dashes = ''
    @correct_letters.each do |e|
      dashes += if @correct_guesses.include?(e)
                  "#{e} "
                else
                  '_ '
                end
    end
    dashes
  end

  def correct_guess
    if @correct_guesses.sort == @correct_letters.uniq.sort
      puts "You win! The word was: #{@word}"
      @guesses = 10
    else
      puts place_letters
    end
  end

  def play_game
    p @word
    puts place_letters
    while @guesses < 10
      puts 'Please enter your letter.'
      guess = gets.chomp
      if @guess_list.include?(guess)
        puts 'You already guessed that letter, try again.'
      elsif guess.length > 1
        puts 'Invalid entry. Try again.'
      elsif @correct_letters.include?(guess)
        puts 'Good guess!'
        @correct_guesses.push(guess)
        @guess_list.push(guess)
        correct_guess
      else
        puts 'Sorry, that letter is not in the word.'
        @guess_list.push(guess)
        puts place_letters
        @guesses += 1
        if guesses > 9
          puts "Sorry, you ran out of guesses. The word was: #{@word}"
          return
        end
      end
      return unless @guesses < 10

      puts "Your guesses so far: #{@guess_list}"
      puts "You have #{10 - @guesses} incorrect guesses left"
    end
  end
end

game = Hangman.new
game.play_game
