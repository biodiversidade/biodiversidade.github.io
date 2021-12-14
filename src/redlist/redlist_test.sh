#!/bin/zsh


while read
do
	line=($=REPLY)
	from=${line[-4]}
	to=${line[-3]}
	reason=${line[-2]}  #N, G or hybrid
	year=${line[-1]}
	spp="${line[1]} ${line[2]}"

	[[ $from =~ ^[A-Z][A-Z].{0,3} || ${#from} -gt 5 ]] || continue
	[[ $spp =~ IUCN ]] && continue
	[[ $spp$from$reason =~ (FERNS|FUNGI|BIRDS|FISH|TREES|Scientific name|Reason|Red List|mistakes|Updated|updated|CRUSTACEANS|PEW|Scientific|status|Status|Published|help|etc\.|Table|information|species) ]] && continue 
	[[ $reason =~ ^(G|N|hybrid)$ ]] || continue

	case $from in
		#extinct
		EX) 	from_val=10  ;;
		#extinct in the wild
		EW) 	from_val=10  ;;
		#critically endangered
		CR) 	from_val=9  ;;
		#endangered
		EN) 	from_val=8  ;;
		#vulnerable
		VU|VY) 	from_val=7  ;;
		#Lower risk/conservation dependent
		LR/cd) 	from_val=6  ;;
		#near threatened, includes LR/nt (lower risk/near threatened)
		NT|LR/nt) 	from_val=5  ;;
		#least concern, includes LR/lc (lower risk, least concern)
		LC|LR/lc) 	from_val=4  ;;
		#data deficient
		DD) 	from_val=1  ;;
		#removed from list, may be synonyms
		NR) 	from_val=0  ;;
	esac
	case $to in
		#extinct
		EX) 	to_val=10  ;;
		#extinct in the wild
		EW) 	to_val=10  ;;
		#critically endangered
		CR) 	to_val=9  ;;
		#endangered
		EN) 	to_val=8  ;;
		#vulnerable
		VU|VY) 	to_val=7  ;;
		#Lower risk/conservation dependent
		LR/cd) 	to_val=6  ;;
		#near threatened, includes LR/nt (lower risk/near threatened)
		NT|LR/nt) 	to_val=5  ;;
		#least concern, includes LR/lc (lower risk, least concern)
		LC|LR/lc) 	to_val=4  ;;
		#data deficient
		DD) 	to_val=1  ;;
		#removed from list, may be synonyms
		NR) 	to_val=0  ;;
	esac
	case ${reason:l} in
		#genuine
		g) 	reason_val=2  ;;
		hybrid) 	reason_val=1  ;;
		n) 	reason_val=0
	esac

	stat=same
	((from_val > to_val)) && stat=improved
	((from_val < to_val)) && stat=worsened
	print "$spp\t$stat\t$from,$to\t$reason"

done


