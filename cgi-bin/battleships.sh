#!/bin/bash
##################################################
# battleships cgi script
#
# functions 
##################################################
function init {
	if [ "$REQUEST_METHOD" == "POST" ]
	then
		read POSTstring
		extractVars $POSTstring
	fi
	extractVars $QUERY_STRING
	
	if [ ! $debug ]
	then
		debug=0
	fi
	if [ ! $QUERY_STRING ]
		then
			for i in {0..143}
        		do
		                hShipBoard[i]=w
		                cShipBoard[i]=w
		        done
		        playerBoatsCoords=( "-" "-" "-" "-" "-" )
			cCoords=( "-" "-" "-" "-" "-" )
			hShip=( "5" "4" "3" "3" "2" )
			cShip=( "5" "4" "3" "3" "2" )
			cTarget=( "-" "-" "-" "-" "-" )
			cTargetAcc=( "1" "1" "1" "1" "1" )
			cTargetDir=( "-" "-" "-" "-" "-" )
			if [ ! $orientation ]
			then
				orientation=v 
			fi
			writeFile
			gridRightInit

	else
		readFile
		message=0
		if [ ! $hTarget ]
		then
			if [ ! $placeShip ]
			then
				gridRightInit
			elif [ ${playerBoatsCoords[$ship]} == "-" ] 
			then
				if [ $ship != "0" ] 
				then
					ship2=$(( $ship - 1 ))
					if [ ${playerBoatsCoords[$ship2]} != $placeShip ]
					then
						putShip
					else
						gridRightInit
					fi
				else	
					putShip
				fi
			fi
		else
			hShot		
		
		fi
	fi		
}

function putShip {
	case $ship in
		0)	placePlayerAircraftCarrier;;
		1)	placePlayerBattleship;;
		2)	placePlayerFrigate;;
		3)	placePlayerSub;;
		4)	placePlayerPatrol;;
	esac
	writeFile
	                        
}

function placePlayerAircraftCarrier {
	bX=$(($placeShip % 12))
        bY=`expr $placeShip / 12`
	if [ $orientation == "v" ] && [ $bY -lt "8" ] 
	then
		hShipBoard[$placeShip]=q
		hShipBoard[$placeShip+12]=q
		hShipBoard[$placeShip+24]=q
		hShipBoard[$placeShip+36]=q
		hShipBoard[$placeShip+48]=q
		playerBoatsCoords[$ship]=$placeShip
		ship=$(( $ship + 1 ))
	fi
        if [ $orientation == "h" ] && [ $bX -lt "8" ]
        then
		hShipBoard[$placeShip]=q
                hShipBoard[$placeShip+1]=q
                hShipBoard[$placeShip+2]=q
                hShipBoard[$placeShip+3]=q
                hShipBoard[$placeShip+4]=q
		playerBoatsCoords[$ship]=$placeShip
		ship=$(( $ship + 1 ))
        fi
	gridRightInit
}

function placePlayerBattleship {
	bX=$(($placeShip % 12))
        if [ $orientation == "v" ]
        then
		if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+12]} == "w" ] && [ ${hShipBoard[$placeShip+24]} == "w" ] && [ ${hShipBoard[$placeShip+36]} == "w" ]
                then
			hShipBoard[$placeShip]=e
	                hShipBoard[$placeShip+12]=e
        	        hShipBoard[$placeShip+24]=e
                	hShipBoard[$placeShip+36]=e
			playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
		fi
	elif [ $orientation == "h" ]
        then
		if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+1]} == "w" ] && [ ${hShipBoard[$placeShip+2]} == "w" ] && [ ${hShipBoard[$placeShip+3]} == "w" ] && [ $bX -lt "9" ]
		then
			hShipBoard[$placeShip]=e
                	hShipBoard[$placeShip+1]=e
               		hShipBoard[$placeShip+2]=e
                	hShipBoard[$placeShip+3]=e
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
		fi
        fi
	gridRightInit
}

function placePlayerFrigate {
        bX=$(($placeShip % 12))
	if [ $orientation == "v" ]
        then
		if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+12]} == "w" ] && [ ${hShipBoard[$placeShip+24]} == "w" ]
                then
			hShipBoard[$placeShip]=r
	                hShipBoard[$placeShip+12]=r
        	        hShipBoard[$placeShip+24]=r
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
		fi
        elif [ $orientation == "h" ]
        then
                if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+1]} == "w" ] && [ ${hShipBoard[$placeShip+2]} == "w" ] && [ $bX -lt "10" ]
		then
			hShipBoard[$placeShip]=r
			hShipBoard[$placeShip+1]=r
                	hShipBoard[$placeShip+2]=r
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
		fi
        fi
        gridRightInit

}

function placePlayerSub {
	bX=$(($placeShip % 12))
        if [ $orientation == "v" ]
        then
                if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+12]} == "w" ] && [ ${hShipBoard[$placeShip+24]} == "w" ]
		then
			hShipBoard[$placeShip]=t
		        hShipBoard[$placeShip+12]=t
        	        hShipBoard[$placeShip+24]=t
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
		fi
        elif [ $orientation == "h" ]
        then
                if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+1]} == "w" ] && [ ${hShipBoard[$placeShip+2]} == "w" ] && [ $bX -lt "10" ]
		then
                       	hShipBoard[$placeShip]=t
	                hShipBoard[$placeShip+1]=t
        	        hShipBoard[$placeShip+2]=t
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
		fi
        fi
        gridRightInit

}

function placePlayerPatrol {
	bX=$(($placeShip % 12))
        if [ $orientation == "v" ]
        then
                if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+12]} == "w" ]
		then
			hShipBoard[$placeShip]=y
	                hShipBoard[$placeShip+12]=y
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
			initComp
		else
			gridRightInit
		fi
        elif [ $orientation == "h" ]
        then
                if [ ${hShipBoard[$placeShip]} == "w" ] && [ ${hShipBoard[$placeShip+1]} == "w" ] && [ $bX -lt "11" ]
		then
                	hShipBoard[$placeShip]=y
	                hShipBoard[$placeShip+1]=y
		        playerBoatsCoords[$ship]=$placeShip
			ship=$(( $ship + 1 ))
			initComp
		else
			gridRightInit
		fi
     	fi

}

function cPositionRandomGenerator {
	cPosition=$(( $RANDOM%143 + 0 ))
	return $cPosition
}

function cOrientationRandomGenerator {
	cOrientation=$(( $RANDOM%2 + 0 ))
	return $cOrientation
}

function placeComAircraftCarrier {
	cOrientationRandomGenerator
	cPositionRandomGenerator
	cCoords[0]=$cPosition
	bX=$(($cPosition % 12))
        bY=`expr $cPosition / 12`

	if [ $cOrientation == "0" ] && [[ $bX -gt "7" ]]
                then
                	placeComAircraftCarrier

        elif [ $cOrientation = 1 ] && [ $bY -gt "7" ]
                then
                	placeComAircraftCarrier
        else
        	cShipBoard[$cPosition]=q
		if [ $cOrientation == "0" ]
		then
			cShipBoard[$cPosition+1]=q
			cShipBoard[$cPosition+2]=q
			cShipBoard[$cPosition+3]=q
			cShipBoard[$cPosition+4]=q
		elif [ $cOrientation == "1" ]
		then
			cShipBoard[$cPosition+12]=q
			cShipBoard[$cPosition+24]=q
			cShipBoard[$cPosition+36]=q
			cShipBoard[$cPosition+48]=q
		fi	
        	        
	fi

}

function placeComBattleship {
        cOrientationRandomGenerator
        cPositionRandomGenerator
        cCoords[1]=$cPosition
        bX=$(($cPosition % 12))
        bY=`expr $cPosition / 12`

        if [ $cOrientation == "0" ] && [[ $bX -gt "8" ]]
                then
                        placeComBattleship

        elif [ $cOrientation = 1 ] && [ $bY -gt "8" ]
                then
                        placeComBattleship
        else
                if [ $cOrientation == "0" ]
                then
			if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+1]} != "w" ] || [ ${cShipBoard[$cPosition+2]} != "w" ] || [ ${cShipBoard[$cPosition+3]} != "w" ]
			then
				placeComBattleship
			else
	                        cShipBoard[$cPosition+1]=e
        	                cShipBoard[$cPosition+2]=e
                	        cShipBoard[$cPosition+3]=e
			fi
		elif [ $cOrientation == "1" ]
		then
			 if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+12]} != "w" ] || [ ${cShipBoard[$cPosition+24]} != "w" ] || [ ${cShipBoard[$cPosition+36]} != "w" ]
	  		then
				placeComBattleship
			else
                	        cShipBoard[$cPosition+12]=e
                        	cShipBoard[$cPosition+24]=e
	                        cShipBoard[$cPosition+36]=e
               		 fi

        	fi
	fi
	cShipBoard[$cPosition]=e
}

function placeComFrigate {
        cOrientationRandomGenerator
        cPositionRandomGenerator
        cCoords[2]=$cPosition
        bX=$(($cPosition % 12))
        bY=`expr $cPosition / 12`

        if [ $cOrientation == "0" ] && [[ $bX -gt "9" ]]
                then 
                        placeComFrigate

        elif [ $cOrientation = 1 ] && [ $bY -gt "9" ]
                then
                        placeComFrigate
        else
                if [ $cOrientation == "0" ]
                then
                        if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+1]} != "w" ] || [ ${cShipBoard[$cPosition+2]} != "w" ]
                        then
                                placeComFrigate
                        else
                                cShipBoard[$cPosition+1]=r
                                cShipBoard[$cPosition+2]=r
			fi
	       	elif [ $cOrientation == "1" ]
                then
        		if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+12]} != "w" ] || [ ${cShipBoard[$cPosition+24]} != "w" ]
                        then
                               	placeComFrigate
	                else
        	                cShipBoard[$cPosition+12]=r
                	        cShipBoard[$cPosition+24]=r
                        fi

               		 
	        fi
	fi
        cShipBoard[$cPosition]=r
}

function placeComSub {
        cOrientationRandomGenerator
        cPositionRandomGenerator
        cCoords[3]=$cPosition
        bX=$(($cPosition % 12))
        bY=`expr $cPosition / 12`

        if [ $cOrientation == "0" ] && [[ $bX -gt "9" ]]
                then
                        placeComSub

        elif [ $cOrientation = 1 ] && [ $bY -gt "9" ]
                then
                        placeComSub
        else
                if [ $cOrientation == "0" ]
                then
                        if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+1]} != "w" ] || [ ${cShipBoard[$cPosition+2]} != "w" ]
                        then
                                placeComSub
                        else
                                cShipBoard[$cPosition+1]=t
                                cShipBoard[$cPosition+2]=t
                        fi
                elif [ $cOrientation == "1" ]
                then
                	if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+12]} != "w" ] || [ ${cShipBoard[$cPosition+24]} != "w" ]
                        then
                               	placeComSub
                        else
                                cShipBoard[$cPosition+12]=t
                                cShipBoard[$cPosition+24]=t
                         fi

                fi
        fi
        cShipBoard[$cPosition]=t
}

function placeComPatrol {
        cOrientationRandomGenerator
        cPositionRandomGenerator
        cCoords[4]=$cPosition
        bX=$(($cPosition % 12))
        bY=`expr $cPosition / 12`

        if [ $cOrientation == "0" ] && [[ $bX -gt "10" ]]
                then
                        placeComPatrol

        elif [ $cOrientation = 1 ] && [ $bY -gt "10" ]
                then
                        placeComPatrol
        else
                if [ $cOrientation == "0" ]
                then
                        if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+1]} != "w" ]
                        then
                                placeComPatrol
                        else
                                cShipBoard[$cPosition+1]=y
                        fi
                elif [ $cOrientation == "1" ]
                then
                        if [ ${cShipBoard[$cPosition]} != "w" ] || [ ${cShipBoard[$cPosition+12]} != "w" ]
                        then
                                placeComPatrol
                        else
                                cShipBoard[$cPosition+12]=y
                        fi

                fi
        fi
        cShipBoard[$cPosition]=y
}

function initComp {
	cCoords=( "-" "-" "-" "-" "-" )
	placeComAircraftCarrier
	placeComBattleship
	placeComFrigate
	placeComSub
	placeComPatrol
	writeFile
	displayMain
}

function hShot {
	case ${cShipBoard[$hTarget]} in
		w)	cShipBoard[$hTarget]="m"
			writeFile
			cTarget	
			;;
		x)	displayMain;;
		m)	displayMain;;
		q)	cShip[0]=$(( ${cShip[0]} - 1 ))
			cShipBoard[$hTarget]="x"
			message=5
			if [ ${cShip[0]} == "0" ]
			then
				message=3
			fi
			writeFile
			endGameCheck
			displayMain
			;;
		e)	cShip[1]=$(( ${cShip[1]} - 1 ))
                        cShipBoard[$hTarget]="x"
			message=5
			if [ ${cShip[1]} == "0" ]
                        then
                                message=3
                        fi
			writeFile
			endGameCheck
			displayMain
			;;
		r)	cShip[2]=$(( ${cShip[2]} - 1 ))
                        cShipBoard[$hTarget]="x"
			message=5
			if [ ${cShip[2]} == "0" ]
                        then
                                message=3
                        fi
			writeFile
			endGameCheck
			displayMain
			;;
		t)	cShip[3]=$(( ${cShip[3]} - 1 ))
                        cShipBoard[$hTarget]="x"
			message=5
			if [ ${cShip[3]} == "0" ]
                        then
                                message=3
                        fi
			writeFile
			endGameCheck
			displayMain
			;;
		y)	cShip[4]=$(( ${cShip[4]} - 1 ))
                        cShipBoard[$hTarget]="x"
			message=5
			if [ ${cShip[4]} == "0" ]
                        then
                                message=3
                        fi
			writeFile
			endGameCheck
			displayMain
			;;
	esac
}

function cRandGen {
	cRand=$(( $RANDOM%4 + 0 ))
	return $cRand
}

function cPositionRand {
	target=$(( $RANDOM%143 + 0 ))
	return $target
}

function cTarget {
	if [ ${cTarget[0]} != "-" ]
	then
		shipNo=0
		if [ ${cTargetAcc[0]} == "1" ]
		then
			cPickRandomPos
		else
			cPickDir
		fi
	elif [ ${cTarget[1]} != "-" ]
	then
		shipNo=1
		if [ ${cTargetAcc[1]} == "1" ]
		then
			cPickRandomPos
		else
			cPickDir
		fi
	elif [ ${cTarget[2]} != "-" ]
	then
		shipNo=2
		if [ ${cTargetAcc[2]} == "1" ]
		then
			cPickRandomPos	
		else
			cPickDir
		fi
	elif [ ${cTarget[3]} != "-" ]
	then
		shipNo=3
		if [ ${cTargetAcc[3]} == "1" ]
                then
                        cPickRandomPos
                else
                        cPickDir
                fi
	elif [ ${cTarget[4]} != "-" ]
	then
		shipNo=4
		if [ ${cTargetAcc[4]} == "1" ]
                then
                        cPickRandomPos
                else
                        cPickDir
                fi
	else
		cPositionRand
		cShot
	fi
}

# function for picking position around current hit
function cPickRandomPos {
	cRandGen
	case $cRand in
		0)	target=$(( ${cTarget[$shipNo]} - 12 ))			# look at the space 1 up
			if [ $target -lt "0" ]					# out of range
			then
				cPickRandomPos
			else
				prevHit=1
				cShot
			fi
			;;
		1)	target=$(( ${cTarget[$shipNo]} + 1 ))			# look at the space 1 to the right
			if [ $target%12 == "0" ] || [ $target -gt "143" ]	# out of range
			then
				cPickRandomPos
			else
				prevHit=1
				cShot
			fi
			;;
		2)	target=$(( ${cTarget[$shipNo]} + 12 ))			# look at the spacce 1 down
			if [ $target -gt "143" ]				# out of range
			then
				cPickRandomPos
			else
				prevHit=1
				cShot
			fi
			;;
		3)	target=$(( ${cTarget[$shipNo]} - 1 ))			# look at the space 1 to the left
			if [ $target%12 == "11" ] || [ $target -lt "0" ]	# out of range
			then
				cPickRandomPos
			else
				prevHit=1
				cShot
			fi
			;;
	esac
}

# function if accumulator is greater than 1
function cPickDir {
	case ${cTargetDir[$shipNo]} in
		0)	i=$(( 12 * ${cTargetAcc[$shipNo]} ))
			target=$(( ${cTarget[$shipNo]} - $i ))
			if [ $target -lt "0" ]
			then
				cTargetAcc[$shipNo]="1"
				cTargetDir[$shipNo]="-"
			else
				prevHit="1"
				cShot
			fi
			;;
		1)	target=$(( ${cTarget[$shipNo]} + ${cTargetAcc[$shipNo]} ))
			if [ $target%12 == "0" || [ $target -gt "143" ]
			then
				cTargetAcc[$shipNo]="1"
				cTargetDir[$shipNo]="-"
			else
				prevHit="1"
				cShot
			fi
			;;
		2)	i=$(( 12 * ${cTargetAcc[$shipNo]} ))
			target=$(( ${cTarget[$shipNo]} + $i ))
			if [ $target -gt "143" ]
			then
                                cTargetAcc[$shipNo]="1"
                                cTargetDir[$shipNo]="-"
                        else
                                prevHit="1"
                                cShot
                        fi
                        ;;
		3)	target=$(( ${cTarget[$shipNo]} - ${cTargetAcc[$shipNo]} ))
			if [ $target%12 == "11" ] || [ $target =lt "0" ]
			then
                                cTargetAcc[$shipNo]="1"
                                cTargetDir[$shipNo]="-"
                        else
                                prevHit="1"
                                cShot
                        fi
                        ;;
	esac
}


# fuction for taking in target and shooting at it	
function cShot {
	readFile
	case ${hShipBoard[$target]} in
		w)	hShipBoard[$target]="m"
			if [ $prevHit == "1" ]
			then
				cTargetAcc[$shipNo]="1"
				cTargetDir[$shipNo]="-"
			fi
			writeFile
			displayMain
			;;
		x)	if [ $prevHit == "1" ]
                        then
                                cTargetAcc[$shipNo]="1"
                        fi
			cTarget
			;;
		m)	if [ $prevHit == "1" ]
			then
				cTargetAcc[$shipNo]="1"
			fi
			cTarget
			;;
		q)	hShip[0]=$(( ${hShip[0]} - 1 ))	#ship health
			hShipBoard[$target]="x"		#change to hit
			message=6
			if [ ${cTarget[0]} == "-" ]
			then
				cTarget[0]=$target
			fi
			if [ $prevHit == "1" ]
			then
				cTargetAcc[0]=$(( ${cTargetAcc[0]} + 1 ))
				cTargetDir[0]=$cRand
			fi
			if [ ${hShip[0]} == "0" ]
			then
				cTargetAcc[0]="1"
				cTargetDir[0]="-"
				cTarget[0]="-"
				message=4
			fi
			endGameCheck
			writeFile			#write the cache
			cTarget				#take another shot
			;;
		e)      hShip[1]=$(( ${hShip[1]} - 1 ))  #ship health
                        hShipBoard[$target]="x"         #change to hit
			message=6
			if [ ${cTarget[1]} == "-" ]
                        then
                                cTarget[1]=$target
                        fi
			if [ $prevHit == "1" ]
                        then
                                cTargetAcc[1]=$(( ${cTargetAcc[1]} + 1 ))
                                cTargetDir[1]=$cRand
                        fi
			if [ ${hShip[1]} == "0" ]
                        then
                                cTargetAcc[1]="1"
                                cTargetDir[1]="-"
                                cTarget[1]="-"
				message=4
                        fi
			endGameCheck
                        writeFile                       #write the cache
                        cTarget                         #take another shot
                        ;;
		r)      hShip[2]=$(( ${hShip[2]} - 1 ))  #ship health
                        hShipBoard[$target]="x"         #change to hit
			message=6
                        if [ ${cTarget[2]} == "-" ]
                        then
                                cTarget[2]=$target
                        fi
			if [ $prevHit == "1" ]
			then
				cTargetAcc[2]=$(( ${cTargetAcc[2]} + 1 ))
				cTargetDir[2]=$cRand
			fi
			if [ ${hShip[2]} == "0" ]
                        then
                                cTargetAcc[2]="1"
                                cTargetDir[2]="-"
                                cTarget[2]="-"
				message=4
                        fi
			endGameCheck
                        writeFile                       #write the cache
                        cTarget                         #take another shot
                        ;;
		t)      hShip[3]=$(( ${hShip[3]} - 1 ))  #ship health
                        hShipBoard[$target]="x"         #change to hit
			message=6
			if [ ${cTarget[3]} == "-" ]
                        then
                                cTarget[3]=$target
                        fi
			if [ $prevHit == "1" ]
                        then
                                cTargetAcc[3]=$(( ${cTargetAcc[3]} + 1 ))
                                cTargetDir[3]=$cRand
                        fi
			if [ ${hShip[3]} == "0" ]
                        then
                                cTargetAcc[3]="1"
                                cTargetDir[3]="-"
                                cTarget[3]="-"
				message=4
                        fi
			endGameCheck
                        writeFile                       #write the cache
                        cTarget                         #take another shot
                        ;;
		y)      hShip[4]=$(( ${hShip[4]} - 1 ))  #ship health
                        hShipBoard[$target]="x"         #change to hit
			message=6
			if [ ${cTarget[4]} == "-" ]
                        then
                                cTarget[4]=$target
                        fi
			if [ $prevHit == "1" ]
                        then
                                cTargetAcc[4]=$(( ${cTargetAcc[4]} + 1 ))
                                cTargetDir[4]=$cRand
                        fi
			if [ ${hShip[4]} == "0" ]
                        then
                                cTargetAcc[4]="1"
                                cTargetDir[4]="-"
                                cTarget[4]="-"
				message=4
                        fi
			endGameCheck
                        writeFile                       #write the cache
                        cTarget                         #take another shot
                        ;;
	esac
}

function endGameCheck {
	hVictory=0
	cVictory=0
	for i in {0..4}
	do
		if [ ${cShip[$i]} == 0 ]
		then
			hVictory=$(( $hVictory + 1 ))
		fi
		if [ ${hShip[$i]} == 0 ]
		then
			cVictory=$(( $cVictory + 1 ))
		fi
	done
	
	if [ $hVictory = "5" ] || [ $cVictory = "5" ]
	then
		endGame
	fi
}  

function endGame {
	if [ $hVictory = "5" ]
	then
		message="1"
	else
		message="2"
	fi
	writeFile
}

function extractVars {
instring=$1

while [ ${#instring} -gt 0 ]
do
	pair=${instring%%[\&\;]*} 
	parm=${pair%=*}
	val="${pair#*=}"
	val="${val//+/\ }"
	val="${val//\%24/\$}" 
	val="${val//\%26/\&}"
	val="${val//\%2B/\+}"
	val="${val//\%2C/\,}"
	val="${val//\%2F/\/}"
	val="${val//\%3A/\:}"
	val="${val//\%3B/\;}"
	val="${val//\%3D/\=}"
	val="${val//\%3F/\?}"
	val="${val//\%40/\@}"
	val="${val//\%20/\ }"
	val="${val//\%22/\"}"
	val="${val//\%3C/\<}"
	val="${val//\%3E/\>}"
	val="${val//\%23/\#}"
	val="${val//\%25/\%}"
	val="${val//\%7B/\{}"
	val="${val//\%7D/\}}"
	val="${val//\%7C/\|}"
	val="${val//\%5C/\\}"
	val="${val//\%5E/\^}"
	val="${val//\%7E/\~}"
	val="${val//\%5B/\[}"
	val="${val//\%5D/\]}"
	val="${val//\%60/\`}"
	rest=${instring#*[\&\;]}  
	eval $parm=$val 

	if [ $rest == $instring ] 
	then
		break
	else
		instring=$rest  
	fi 
done
}


function displayHeader {
	echo "Content-type: text/html; charset=iso-8859-1"
	echo
	cat ../battleships-top.html
	if [ ! $ship ]
	then
		ship=0
	fi
	echo "<script type='text/javascript'>shipNo=$ship; orientation='$orientation';</script>"
	cat ../hoverJS.html
	if [ $debug = 1 ]
	then
        	echo	"<div id='console'>"
		if [ $placeShip ]
		then
			echo	"Place Ship Variables:<br>" 
			echo    "Ship Orientation:"
	        	echo    $orientation "<br>"
			echo	"Ship Number:"
        		echo    $ship "<br>"
        		echo    "Place Ship:"
        		echo    $placeShip "<br>"
		else
			cho	"Game Arrays:<br>"
        		echo    "Player Initial Ship Co-ordinates:"
        		echo    ${playerBoatsCoords[@]} "<br>" 
        		echo    "Computer Initial Ship Co-ordinates:"
        		echo    ${cCoords[@]} "<br>"
			echo	"Computer Ships' Health:"
			echo	${cShip[@]} "<br>"
			echo	"Player Ships' Health:"
			echo	${hShip[@]} "<br>"
			echo	"Computer Initial Targets:"
			echo	${cTarget[@]} "<br>"
			echo	"Player Board:"
        		echo    ${hShipBoard[@]} "<br>"
			echo	"Computer Board:"
			echo	${cShipBoard[@]} "<br>"
		fi
		echo 	"</div>"
	fi
	echo	"<div id='header'>"
	echo	"<div id='logo'><img src='../images/logo.jpg' alt='battleships'></div></div>"
	echo	"<div id='key'></div><div id='menu'><ul>"
	echo	"<li><a href='$SCRIPT_URI'><img src='../images/menu/new-game.png' alt='new game'></a></li>"
	echo	"<li><a href='../how-to-play.html'><img src='../images/menu/how-to-play.png' alt='how to play'></a></li>"
	echo	"<li>"
	if [ $orientation ]
        then
                if [ $debug == "0" ]
                then
                        echo "<a href='$SCRIPT_URI?orientation=$orientation&amp;ship=$ship&amp;debug=1'><img src='../images/menu/debug.png' alt='debug on/off'></a>"
                else
                        echo "<a href='$SCRIPT_URI?orientation=$orientation&amp;ship=$ship&amp;debug=0'><img src='../images/menu/debug.png' alt='debug on/off'></a>"
                fi
        else
                if [ $debug == "0" ]
                then
                        echo "<a href='$SCRIPT_URI?hTarget=$hTarget&amp;debug=1'><img src='../images/menu/debug.png' alt='debug on/off'></a>"
                else
                        echo "<a href='$SCRIPT_URI?hTarget=$hTarget&amp;debug=0'><img src='../images/menu/debug.png' alt='debug on/off'></a>"
                fi
        fi
	echo	"</li>"
	echo	"</ul></div><div id='main'><div id='container'>"
}

function displayFooter {
echo	"</div>"
echo 	"<div id='footer'><div id='shipsHealth'>"
echo 	"<ul id='compShips'>"
for i in {0..4}
do
        echo "<li><img src='../images/boats/$i-${cShip[$i]}.png' alt='computer ship health'></li>"
done
echo 	"</ul>"
echo 	"<ul id='userShips'>"
for i in {0..4}
do
        echo "<li><img src='../images/boats/$i-${hShip[$i]}.png' alt='ship health'></li>"
done
echo 	"</ul>"
echo 	"</div>"
echo	"<p>"
if [ ! $hTarget ] && [ $ship -lt "5" ]
then
        if [ $orientation == "v" ]
        then
                echo "<a href='$SCRIPT_URI?orientation=h&amp;ship=$ship&amp;debug=$debug'>switch to horizontal</a>"
        else
        	echo "<a href='$SCRIPT_URI?orientation=v&amp;ship=$ship&amp;debug=$debug'>switch to vertical</a>"
	fi
fi

if [[ $message -gt "0" ]]
then	
	echo    "<p>"
        case $message in
                1)      echo "Nice! You Won! <a href='$SCRIPT_URI'>Play Again?</a>"
                        ;;
                2)      echo "Poor Show! You Lost! <a href='$SCRIPT_URI'>Play Again?</a>"
                        ;;
		3)	echo "Nice! You sunk a ship!"
			;;
		4)	echo "Ahhh! The computer sunk your ship!"
			;;
		5)	echo "Nice hit!"
			;;
		6)	echo "Ahhh! The computer hit your ship!"
			;;
        esac
	echo 	"</p>"
fi
echo    "</div>"
echo	"</body>
        </html>"
}

function displayMain {
	readFile
	displayHeader	
	echo 	"<div id='grid-right'>"
	gridRight        
	echo	"<h1><img src='../images/player-board.png' alt='player board'></h1>"
	echo	"</div>"
	echo	"<div id='grid-left'>"
	gridLeft
	echo	"<h1><img src='../images/computer-board.png' alt='computer board'></h1>"
	echo	"</div>"
	echo 	"</div>"
	displayFooter
}

function gridLeft {
	echo "<table>"
	for i in {0..11}
	do
	echo "<tr>"
		for j in {0..11}
		do
		k=$(($i * 12 + $j))
		echo "<td>"
		if [ $debug = 1 ]
		then
	                case ${cShipBoard[$k]} in
			x)	echo "<img src='../images/red-dot.png' alt='hit'>"	;;
			m)	echo "<img src='../images/blue-dot.png' alt='miss'>"	;;
                        q)      echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/squares/0.png' alt='q'></a>"        ;;
                        e)      echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/squares/1.png' alt='e'></a>"        ;;
                        r)      echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/squares/2.png' alt='r'></a>"        ;;
                        t)      echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/squares/3.png' alt='t'></a>"        ;;
                        y)      echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/squares/4.png' alt='y'></a>"        ;;
                        w)      echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/blank.png' alt='w'></a>"          ;;
			esac
		else
			if [[ ${cShipBoard[$k]} == "x" ]]
			then
				echo "<img src='../images/red-dot.png' alt='hit'>"
			elif [[ ${cShipBoard[$k]} == "m" ]]
			then
				echo "<img src='../images/blue-dot.png' alt='miss'>"
			else
				echo "<a href='$SCRIPT_URI?hTarget=$k&amp;debug=$debug'><img src='../images/blank.png' alt='fire'></a>"
			fi
		fi
		echo "</td>"
		done
	echo "</tr>"
	done
	echo "</table>"
}

function gridRight {
	echo "<table>"
        for i in {0..11}
        do
        echo "<tr>"
                for j in {0..11}
                do
                k=$(($i * 12 + $j))
                echo "<td>"
		case ${hShipBoard[$k]} in
			q)	echo "<img src='../images/squares/0.png' alt='Aircraft Carrier'>"	;;
			e)	echo "<img src='../images/squares/1.png' alt='Battleship'>"  	;;
			r)	echo "<img src='../images/squares/2.png' alt='Frigate'>"  	;;
			t)	echo "<img src='../images/squares/3.png' alt='Sub'>"  	;;
			y)	echo "<img src='../images/squares/4.png' alt='Patrol'>"  	;;
			w)	echo "<img src='../images/blank.png' alt='w'>"  	;;
			x)	echo "<img src='../images/red-dot.png' alt='hit'>"  	;;
			m)	echo "<img src='../images/blue-dot.png' alt='miss'>"  	;;
			*)	echo "<img src='../images/blank.png' alt='w'>"		;;
		esac
		echo "</td>"
		done
	echo "</tr>"
	done
	echo "</table>"
}

function gridRightInit {
        displayHeader
        echo "<div id='grid'><table>"
        for i in {0..11}
        do
        echo "<tr>"
                for j in {0..11}
                do
                k=$(($i * 12 + $j))
                echo "<td id='cell$k' class='cell'>"
                case ${hShipBoard[$k]} in
                        q)      echo "<img src='../images/squares/0.png' alt='Aircraft Carrier'>"    ;;
                        e)      echo "<img src='../images/squares/1.png' alt='Battleship'>"   ;;
                        r)      echo "<img src='../images/squares/2.png' alt='Frigate'>"         ;;
                        t)      echo "<img src='../images/squares/3.png' alt='Sub'>"          ;;
                        y)      echo "<img src='../images/squares/4.png' alt='Patrol'>"   ;;
                        *)      echo "<a href='$SCRIPT_URI?orientation=$orientation&amp;placeShip=$k&amp;ship=$ship&amp;debug=$debug'><img 
src='../images/blank.png' alt='w'></a>";;
                esac
                echo "</td>"
                done
        echo "</tr>"
        done
	echo "</table>"
        echo "<h1><img src='../images/place-your.png' alt='place your:'><img src='../images/boats/$ship.png' alt='ship' id='place-your-ship'></h1></div>"
	echo "</div>"
	displayFooter
}

function writeFile {
	echo ${playerBoatsCoords[@]} > $savedFile
	echo ${hShipBoard[@]} >> $savedFile
	echo ${cShipBoard[@]} >> $savedFile
	echo ${cShip[@]} >> $savedFile
	echo ${hShip[@]} >> $savedFile
	echo $message >> $savedFile
	echo ${cTarget[@]} >> $savedFile
	echo ${cTargetAcc[@]} >> $savedFile
	echo ${cTargetDir[@]} >> $savedFile
	echo ${cCoords[@]} >> $savedFile
}

function readFile {
	playerBoatsCoords=( $(cat $savedFile | awk '{if (NR==1) print}') )
	hShipBoard=( $(cat $savedFile | awk '{if (NR==2) print}') )
        cShipBoard=( $(cat $savedFile | awk '{if (NR==3) print}') )
	cShip=( $(cat $savedFile | awk '{if (NR==4) print}') )
	hShip=( $(cat $savedFile | awk '{if (NR==5) print}') )
	message=( $(cat $savedFile | awk '{if (NR==6) print}') )
	cTarget=( $(cat $savedFile | awk '{if (NR==7) print}') )
	cTargetAcc=( $(cat $savedFile | awk '{if (NR==8) print}') )
	cTargetDir=( $(cat $savedFile | awk '{if (NR==9) print}') )
	cCoords=( $(cat $savedFile | awk '{if (NR==10) print}') )
}

##################################################
# MAIN SCRIPT
##################################################
savedFile="cache.txt"
init
