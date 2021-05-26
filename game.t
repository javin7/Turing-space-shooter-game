%Javin Liu
%Space game v2.3

%Window set
View.Set ("graphics:1900,900,offscreenonly,nobuttonbar,position:middle;middle")

%Vars
var chars1 : string (1)
var chars : array char of boolean
var font1, font2 : int
var shipX : int := 150
var shipY : int := 200
var laserX, laserY : int := 0
var health : int
var points : int := 0
var shooting : int := 0
var starX, starY : array 1 .. 20 of int
var enemyX, enemyY : int := 500
var pillarX, pillarY, gap : int := -10
var mouseX, mouseY, mouseDown : int
var alienX, alienY, alienDead : int := -10
var asteroidX, asteroidY, asteroidXDir : int
var asteroidX2, asteroidY2, asteroidXDir2 : int
var asteroidX3, asteroidY3, asteroidXDir3 : int
var asteroidX4, asteroidY4, asteroidXDir4 : int
var alienLaserX, alienLaserY : int
var coolDown : int := 4
var coolDown2 : int
var switch : int := 1
var speed : int
var concatenate, concatenate2 : string

%I/O
var stream : int
var bestScore : int
open : stream, "personalBest.txt", get

%Bitmaps
var shipBMP : int := Pic.FileNew ("ship.bmp")
var shipHurtBMP : int := Pic.FileNew ("shipHurt.bmp")
var alienBMP : int := Pic.FileNew ("alien.bmp")
var deadAlienBMP : int := Pic.FileNew ("deadAlien.bmp")
var spaceBackgroundJPG : int := Pic.FileNew ("spaceBackground.jpg")
var asteroidJPG : int := Pic.FileNew ("asteroid.jpg")

%Font
font1 := Font.New ("Apple ][:12")
font2 := Font.New ("Apple ][:30")


procedure start
    View.Update
    %Play start menu music
    Music.PlayFileLoop ("titleScreen.mp3")

    %Title
    for decreasing i : 900 .. 450
	Pic.Draw (spaceBackgroundJPG, 0, 0, picCopy)
	Font.Draw ("WELCOME TO SPACE GAME!", 440, i, font2, white)
	View.Update
    end for
    %Press space to start
    Pic.Draw (spaceBackgroundJPG, 0, 0, picCopy)
    Font.Draw ("WELCOME TO SPACE GAME!", 440, 450, font2, white)
    Font.Draw ("Press space to start...", 440, 380, font2, white)
    Font.Draw ("Up Arrow to move up", 1400, 800, font1, brightred)
    Font.Draw ("Down Arrow to move Down", 1400, 750, font1, brightred)
    Font.Draw ("X key to shoot laser", 1400, 700, font1, brightred)

    Font.Draw ("Avoid hitting pillars", 100, 800, font1, brightred)
    Font.Draw ("Shooting the alien will disable them temporarily", 100, 770, font1, brightred)
    Font.Draw ("The alien will teleport all around", 100, 740, font1, brightred)
    Font.Draw ("Avoid hitting the alien unless they are disabled", 100, 710, font1, brightred)
    Font.Draw ("Shooting laser will take away score, use wisely", 100, 680, font1, brightred)
    Font.Draw ("Rocks will launch towards you every round", 100, 650, font1, brightred)
    Font.Draw ("Hitting a rock will reduce your score", 100, 620, font1, brightred)
    View.Update

    %Get if user enters spacebar
    loop
	getch (chars1)
	exit when chars1 = " "
	View.Update
    end loop
    cls

    %Select difficulty (W.I.P)
    loop
	Pic.Draw (spaceBackgroundJPG, 0, 0, picCopy)
	Mouse.Where (mouseX, mouseY, mouseDown)
	Font.Draw ("Set your difficulty!", 510, 450, font2, white)
	if mouseX > 274 and mouseX < 548 and mouseY > 100 and mouseY < 300 and mouseDown = 1 then
	    health := 10
	    speed := 2
	elsif mouseX > 822 and mouseX < 1096 and mouseY > 100 and mouseY < 300 and mouseDown = 1 then
	    health := 5
	    speed := 4
	elsif mouseX > 1370 and mouseX < 1644 and mouseY > 100 and mouseY < 300 and mouseDown = 1 then
	    health := 1
	    speed := 6
	end if

	%Difficulty select
	exit when mouseX > 274 and mouseX < 548 and mouseY > 100 and mouseY < 300 and mouseDown = 1
	    or mouseX > 822 and mouseX < 1096 and mouseY > 100 and mouseY < 300 and mouseDown = 1
	    or mouseX > 1370 and mouseX < 1644 and mouseY > 100 and mouseY < 300 and mouseDown = 1

	%Difficulties
	drawfillbox (274, 300, 548, 100, green)
	Font.Draw ("EASY", 330, 190, font2, white)
	Font.Draw ("RECOMMENDED", 330, 250, font1, brightred)
	Font.Draw ("10 Lives", 330, 170, font1, grey)
	Font.Draw ("Slow speed", 330, 150, font1, grey)
	drawfillbox (822, 300, 1096, 100, 43)
	Font.Draw ("MEDIUM", 843, 190, font2, white)
	Font.Draw ("5 Lives", 843, 170, font1, grey)
	Font.Draw ("Medium speed", 843, 150, font1, grey)
	drawfillbox (1370, 300, 1644, 100, red)
	Font.Draw ("HARD", 1426, 190, font2, white)
	Font.Draw ("1 life", 1426, 170, font1, grey)
	Font.Draw ("Fast speed", 1426, 150, font1, grey)

	drawbox (274, 300, 548, 100, grey)
	drawbox (822, 300, 1096, 100, grey)
	drawbox (1370, 300, 1644, 100, grey)
	View.Update
    end loop
    Music.PlayFileStop
end start

procedure gameOver
    %When you die
    Music.PlayFileLoop ("gameOver.mp3")
    concatenate := ("Your score was " + intstr (points) + "!")
    get : stream, bestScore
    close : stream

    if bestScore < points then
	bestScore := points
    else
	bestScore := bestScore
    end if

    concatenate2 := ("Your personal best was " + intstr (bestScore) + "!")

    loop
	%Game over
	Pic.Draw (spaceBackgroundJPG, 0, 0, picCopy)
	Font.Draw ("GAME OVER!", 780, 450, font2, brightred)
	Font.Draw (concatenate, 540, 400, font2, white)
	Font.Draw (concatenate2, 500, 350, font2, white)
	Font.Draw ("Press space to exit...", 530, 300, font2, white)
	View.Update
	%Space to continue
	getch (chars1)
	exit when chars1 = " "
	View.Update
    end loop
    open : stream, "personalBest.txt", put
    put : stream, bestScore
    close : stream
end gameOver

procedure main
    points += 1
    Input.KeyDown (chars)
    %Movement
    if chars (KEY_UP_ARROW) and shipY + 6 < 900 then
	shipY += 4
    end if
    /*    if chars (KEY_RIGHT_ARROW) and shipX + 6 < 1900 then
     shipX += 4
     end if
     if chars (KEY_LEFT_ARROW) and (shipX - 6) > 0 then
     shipX -= 4
     end if*/
    if chars (KEY_DOWN_ARROW) and (shipY - 12) > 0 then
	shipY -= 4
    end if


    %Shooting
    if chars (chr (120)) and shooting = 0 then
	laserY := shipY
	laserX := shipX
	loop
	    points -= 2
	    shooting := 1
	    laserX += 20
	    exit when laserX + 20 > 1900
	    %Recursion
	    main
	end loop
	shooting := 0
    end if

    cls

    %Background
    drawfillbox (0, 0, 1900, 900, black)

    %Reset positions
    if (alienX < 0) then
	alienX := Rand.Int (100, 1000)
	alienY := Rand.Int (100, 800)
    end if
    if (pillarX < 0) then
	alienDead := 0
	asteroidX := 1900
	asteroidX2 := 1900
	asteroidX3 := 1900
	asteroidX4 := 1900
	asteroidY := Rand.Int (0, 900)
	asteroidY2 := Rand.Int (0, 900)
	asteroidY3 := Rand.Int (0, 900)
	asteroidY4 := Rand.Int (0, 900)
	asteroidXDir := Rand.Int (3, 6)
	asteroidXDir2 := Rand.Int (3, 6)
	asteroidXDir3 := Rand.Int (3, 6)
	asteroidXDir4 := Rand.Int (3, 6)
	pillarX := 1900
	gap := Rand.Int (100, 800)
    end if

    %Rocks movement
    asteroidX -= asteroidXDir
    asteroidX2 -= asteroidXDir2
    asteroidX3 -= asteroidXDir3
    asteroidX4 -= asteroidXDir4

    %Draw rocks
    Pic.Draw (asteroidJPG, asteroidX, asteroidY, picCopy)
    Pic.Draw (asteroidJPG, asteroidX2, asteroidY2, picCopy)
    Pic.Draw (asteroidJPG, asteroidX3, asteroidY3, picCopy)
    Pic.Draw (asteroidJPG, asteroidX4, asteroidY4, picCopy)

    %Draw alien
    Pic.Draw (alienBMP, alienX, alienY, picMerge)

    %Move alien
    if alienY > 800 then
	switch := 1
    elsif alienY < 100 then
	switch := 0
    end if
    if switch = 0 then
	alienY += 1
    elsif switch = 1 then
	alienY -= 1
    end if

    %If laser shoots at alien
    if laserX > alienX and laserX < alienX + 101 and laserY > alienY and laserY < alienY + 101 then
	alienDead := 1
    end if

    if alienDead = 1 then
	%Draw dead alien
	Pic.Draw (deadAlienBMP, alienX, alienY, picCopy)
    end if

    %If ship hits a alien
    if shipX + 53 > alienX and shipX + 53 < alienX + 101 and shipY > alienY and shipY < alienY + 101 and alienDead = 0 then
	health -= 1
	alienX := -99999
	alienY := -99999
    end if

    %Pillars
    drawfillbox (pillarX + 10, 0, pillarX - 3, 900, 22)
    drawfillbox (pillarX + 10, gap + 100, pillarX - 3, gap - 100, black)
    drawbox (pillarX + 10, gap + 100, pillarX - 3, gap - 100, grey)

    %Move alien / pillar
    alienX -= speed
    pillarX -= speed

    %Spaceship
    Pic.Draw (shipBMP, shipX, shipY - 13, picCopy)

    %Stars
    for star : 1 .. 20
	starX (star) := Rand.Int (0, 1900)
	starY (star) := Rand.Int (0, 900)
    end for
    for star : 1 .. 20
	starY (star) := -Rand.Int (1, 5)
	if starY (star) < 0 then
	    starY (star) := 1080
	    starY (star) := Rand.Int (0, 1900)
	end if
	drawfilloval (starX (star), starY (star), 1, 1, white)
    end for

    %Laser shots
    if shooting = 1 then
	drawfillbox (laserX - 19, laserY + 26, laserX - 5, laserY + 24, 12)
	drawfillbox (laserX + 5, laserY + 26, laserX + 19, laserY + 24, 12)
	drawfillbox (laserX - 19, laserY - 11, laserX - 5, laserY - 9, 12)
	drawfillbox (laserX + 5, laserY - 11, laserX + 19, laserY - 9, 12)
    end if

    %Write health and score
    Font.Draw ("Health", 1720, 870, font1, brightred)
    Font.Draw ("Score", 1620, 870, font1, yellow)
    Font.Draw (intstr (health), 1720, 850, font1, white)
    Font.Draw (intstr (points), 1620, 850, font1, white)

    %Detect if ship hits a obstacle
    if whatdotcolor (shipX + 80, shipY) = 22 then
	if coolDown = 0 then
	    health -= 1
	    coolDown := 4
	    Pic.Draw (shipHurtBMP, shipX, shipY - 13, picCopy)
	else
	    coolDown -= 1
	end if
    end if

    %If health drops to 0
    if health < 1 then
	Music.PlayFileStop
	gameOver
    end if

    %View update
    View.Update
end main


start
Music.PlayFileLoop ("battleInTheStars.mp3")
loop
    main
end loop
