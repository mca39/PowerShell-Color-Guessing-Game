$startRound = "true"
$countRounds = 1
$countWins = 0
$countLoss = 0
$quit = "False" #quit the game

while($startRound = "true"){
    $giveUp = "False" #give up on a round

    Write-Host "Here's a list of colors, let me choose one and you can guess which:"
    $SystemColors = [System.Enum]::getvalues([System.ConsoleColor])  #Returns an array of the system colors
    write-host $SystemColors #display valid colors

    $randColor = [System.Enum]::getvalues([System.ConsoleColor])|Get-Random #gets a random system color
    Write-Host `n
    Write-Host "For Debugging, the random color is $randColor" #for debugging
    Write-Host `n
    $guessColor = Read-Host "Okay I have it, Guess what color I'm thinking of" #the user's input
    Write-Host "To give up and start a new round, enter give, Enter q to quit the game"
    Write-Host `n
   # Write-Host "For debugging, the color you guessed is $guessColor" #for debugging

    while($randColor -ne $guessColor -and $giveUp -ne "true" -and $quit -ne "true"){
        if($guessColor -eq "give")
        {
            Write-Host "Sorry you lost that round, the color was $randColor, let's try again"
            $countRounds += 1
            $countLoss += 1
            $giveUp = "true"
        }elseif($guessColor -eq 'quit'){
            Write-Host "Sorry you lost that round, the color was $randColor"
            $countLoss += 1
            $startRound = "false"
            $quit = "true"
        }else{
            $guessColor = Read-Host "Sorry guess again"
        }
    }
    if($quit -eq "true")
    {
        break
    }
    if($giveUp -ne "true" -and $quit -eq 'false'){
        $countWins += 1

        #play again?
        $again = Read-Host "Congratulations you got it! play again? Y for yes or N to exit"
        if($again -eq 'y'){
            $countRounds += 1
            $startRound="true"
        }elseif($again -eq 'n'){
            $startRound = "false"
            break
        }else{
        $again = Read-Host "sorry, that is not a valid entry, please enter Y for yes or N to exit"
        }
    }
}
#the user has ended the game, display the stats
Write-Host "Stats"
Write-Host "Rounds Played: $countRounds"
Write-Host "Rounds won: $countWins"