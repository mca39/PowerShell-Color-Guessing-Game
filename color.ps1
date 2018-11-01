#====================================================================================
# Program Name : Color
# Author: Mariah Ashley
# I Mariah Ashley wrote this script as original work completed by me.
# Special Feature:  I am keeping track of wins and losses and I have 
#                   an on-demand menu by calling the menu function
#                   and my list of valid colors displays each in their correct color
#====================================================================================
$startRound = "true" #each game can have more than one round, the game is wrapped in a while loop for each round
$countRounds = 1     #each time the user starts a new round this is incremented
$countWins = 0       #if the user guesses the color they win the round
$countLoss = 0       #if the user gives up on a round they lose the round
$quit = "False"      #quits the game, displays the statistics, and exits the script
$times = @()         #keeps track of all the times for each round in a game

#A menu of commands that will display at start of game and when user enters "menu"
function menu{
    Write-Host "Welcome to the Color game, here's a menu of commands"
    Write-Host `n
    Write-Host "Game commands:"
    Write-Host "give - give up and start a new round"
    Write-Host "colors - displays the list of valid colors"
    Write-Host "hint - this will give you the first letter of the color"
    Write-Host "guess - will show you what colors you have already guessed"
    Write-Host "quit - quits and exits the game"
    Write-Host "hint - will give you a hint"
    Write-Host "menu - will display this menu"
    Write-Host `n
}
#display the menu at start of game
menu

#the game loop, rounds for the game will continue as long as startRound is true
while($startRound -eq "true" -and $quit -ne 'true'){
    #use a stop watch to keep time of the round
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()

    #make sure giveup is reset to false if necessary, give up gives up only on a round, not the game
    $giveUp = "False" 

     #An empty array to hold the user's wrong guesses for each round
    $guesses = @()   

    #An array of the system colors
    $SystemColors = [System.Enum]::getvalues([System.ConsoleColor])  
    Write-Host "Here's a list of colors, let me choose one and you can guess which:"
    #display the list of valid colors each in their correct color and on one line
    $SystemColors | %{ Write-Host "$_" -ForegroundColor $_ -nonewline ' '}

    #get a random system color
    $randColor = [System.Enum]::getvalues([System.ConsoleColor])|Get-Random 
    Write-Host `n
    
    #for debugging and to make grading easier
    Write-Host "For Debugging, the random color is " -nonewline
    #print the correct color for debugging purposes in it's correct color    
    Write-Host $randColor -ForegroundColor $randColor 

    #Get the user's guess
    $guessColor = Read-Host "Okay I have it, Guess what color I'm thinking of" 

    #Un-comment the next line for debugging the user's guess
    # Write-Host "For debugging, the color you guessed is $guessColor" 

    #The guessing loop, as long as the user guesses incorrectly 
    #or until they either give up the round or quit the game
    while($randColor -ne $guessColor -and $giveUp -ne "true" -and $quit -ne "true"){
        if($guessColor -eq "give"){ 
            #if the user gives up
            Write-Host "Sorry you lost that round, the color was " -nonewline
            #display the correct color in it's correct color
            Write-Host $randColor -ForegroundColor $randColor -nonewline
            Write-Host ", let's try again"
            Write-Host `n
            $countRounds += 1
            $countLoss += 1
            #exit the guessing loop and return to the game loop, giveup will reset to false
            #in the game loop
            $giveUp = "true"
            #stop the stopwatch, don't insert the time because the round is lost
            $stopwatch.stop()
        }elseif($guessColor -eq 'menu'){
            #the user wants to see the commmand menu, call it
            menu
            #let the user enter a guess or a command
            $guessColor = Read-Host "Please enter a command or guess another color"
        }elseif($guessColor -eq 'hint'){ 
            #The user wants a hint
            $tempColor = [string]$randcolor
            if($tempColor -like 'dark*'){ 
                #if the color is a dark color, the hint is dark and the first letter of the color
                write-host "the color starts with $($tempColor.Substring(0,5))" 
            }else{ 
                #if the color is not dark only display the first letter
                write-host "The color starts with" $tempColor[0]
            }
            #let the user enter a guess
            $guessColor = Read-Host "Can you guess it now" #allows the user to enter another guess
        }elseif($guessColor -eq 'quit'){
            #the user wants to end the round and quit the game
            Write-Host "Sorry you lost that round, the color was " -NoNewline
            #display the correct color in its correct color
            write-Host $randColor -ForegroundColor $randColor
            #increment the loss count
            $countLoss += 1
            #exit both loops, display the game results and exit the game
            $quit = "true"
        }elseif($guessColor -eq 'colors'){
            #The user wants to list the valid colors
            Write-Host "The valid colors are:"
            #list the valid colors each in it's correct color
            $SystemColors | %{ Write-Host "$_" -ForegroundColor $_ -nonewline ' '}
            #allow the user to enter a guess
            $guessColor = Write-Host "Try one of those"
        }elseif($guessColor -eq 'guess'){
            #the user wants to see what colors they have guessed so far
            `n
            write-Host "You have a short memory, The colors you've already made this round are:"
            #display each of the user's guesses for this round each in its correct color
            $guesses | %{ Write-Host "$_" -ForegroundColor $_ -nonewline ' '}
            write-host `n
            #Allow the user to guess again
            $guessColor = Read-Host "give it another try" #allows the user to enter another guess
        }else{
            #if none of the above are met see if the entry is a valid color
            if($guessColor -notin $SystemColors){
                #it is not a valid color or command
                Write-Host "Sorry, $guessColor is not a valid color, here is a list of valid colors:"
                #display the valid colors each in the correct color
                $SystemColors | %{ Write-Host "$_" -ForegroundColor $_ -nonewline ' '}
                Write-Host `n
                #allow the user to guess again
                Read-Host "Please stay within the lines and pick one of those"
            }else{
                #it was a valid color but the user guessed wrong, add the guess to the guesses array
                $guesses += $guessColor #the color was wrong, insert it into the guesses array
                #prompt the user again
                $guessColor = Read-Host "Sorry guess again" #allows the user to enter another guess
            }
        }
    }
   # if($quit -eq "true")
    #{
        
     #   break
    #}
    if($giveUp -ne "true" -and $quit -eq 'false'){
       #stop the powershell stop watch
        $stopwatch.stop()
        #Get the seconds, the stop watch is in milliseconds, 1000 ms = 1 second
        $time = $stopwatch.Elapsedmilliseconds/1000
        #insert the time into the array
        $times += $time
        #increase the number of wins
        $countWins += 1

        #Tell the user they got the guess correct and tell them how many seconds it took
        Write-Host "Congratulations you got it in $time seconds! I love " -nonewline
        #Confirm the correct color in its correct color
        write-Host $randColor -ForegroundColor $randColor
        #prompt the user to play again
        $again = Read-Host "Do you want to play another round? Y for yes or N to exit"
        if($again -eq 'y'){
            #the user wants to play another round, add one to rounds
            $countRounds += 1
            #make sure that startRound is set to true
            $startRound="true"
        }elseif($again -eq 'n'){
            #the user doesn't want to play again, set start round to false
            $startRound = "false"
            #break out of the guessing loop, startRound will end the game loop
            break
        }else{
            #the user did not enter y or n, prompt the user for a valid entry
            $again = Read-Host "sorry, that is not a valid entry, please enter Y for yes or N to exit"
        }
    }
}
#the user has ended the game, get statistics

#get the average seconds it took to guess correctly on rounds won
$avgSeconds = $times | Measure-Object -Average
#display the stats
Write-Host "Stats"
Write-Host "Rounds Played: $countRounds"
Write-Host "Rounds won: $countWins"
Write-Host "Rounds lost: $countLoss"
Write-Host "Average time per rounds won: $($avgSeconds.Average)"

