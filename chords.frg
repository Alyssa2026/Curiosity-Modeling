#lang forge/bsl

//option run_sterling "chords.js"

----------------------------------------------------------------------------------------------------
-- (1) Model the scales used to create chords
----------------------------------------------------------------------------------------------------
-- Scales are made up of notes
sig Note {
    value: one Int,
    next: lone Note 
}
-- Scales are composed of 8 notes 
one sig Scale {
    // Initialize notes
    n0: one Note, 
   	n1: one Note,
    n2: one Note,
   	n3: one Note,
    n4: one Note,
    n5: one Note,
    n6: one Note,
    n7: one Note
}

-- Attributes necessary for a wellformed sequence of 8 notes
    -- Each note must have values between 0-11 (notes a-g)
    -- The notes in the scale should not be the same
    -- Each note points to a next note or none
pred wellformed{
    all scale:Scale|{
       scale.n0.value<=11 and scale.n1.value>=0
       scale.n1.value<=11 and scale.n1.value>=0
       scale.n2.value<=11 and scale.n2.value>=0
       scale.n3.value<=11 and scale.n3.value>=0
       scale.n4.value<=11 and scale.n4.value>=0 // works with only 4 notes and this is commented out 
       scale.n5.value<=11 and scale.n5.value>=0
       scale.n6.value<=11 and scale.n6.value>=0
       scale.n7.value<=11 and scale.n7.value>=0

       scale.n0.next=scale.n1
       scale.n1.next=scale.n2
       scale.n2.next=scale.n3
       scale.n3.next=scale.n4
       scale.n4.next=scale.n5 // works with only 4 notes and this is commented out 
       scale.n5.next=scale.n6
       scale.n6.next=scale.n7
       scale.n7.next= none

    
 
    }
    some scale:Scale, note1, note2:Note|{
        scale.n0=note1 or 
        scale.n1=note1 or
        scale.n2=note1 or
        scale.n3=note1 or
        scale.n4=note1 or
        scale.n5=note1 or
        scale.n6=note1 or 
        scale.n7=note1

        reachable[note1, note2, next] implies{
            note1!=note2  
        } or 
        reachable[note2, note1, next] implies {
             note1!=note2
        }
    }
}
run{
    wellformed
} for 5 Int
-- Basic predicate to ensure two notes are a whole step apart
pred wholeStep[firstNote, secondNote:Int]{
    add[firstNote,2]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote= subtract[add[firstNote,2],12] 
    }else{
        secondNote= add[firstNote,2]
    }
}
-- Basic predicate to ensure two notes are a half step apart
pred halfStep[firstNote, secondNote:Int]{
    add[firstNote,1]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote= subtract[add[firstNote,1],12] 
    }else{
        secondNote= add[firstNote,1]
    }
}
-- Basic predicate to create a major scale from any starting note 
pred majorScale{
    --WWHWWWH
    all scale:Scale, note: Int|{
        scale.n0.value=note implies {
            wholeStep[note, scale.n1.value]
            wholeStep[scale.n1.value, scale.n2.value]
            halfStep[scale.n2.value, scale.n3.value]
            wholeStep[scale.n3.value, scale.n4.value]
            wholeStep[scale.n4.value, scale.n5.value]
            wholeStep[scale.n5.value, scale.n6.value]
            halfStep[scale.n6.value, scale.n7.value]
        }
    
    }
}
// run{
//     wellformed
//     majorScale
// } for 6 Int
-- Minor scale, can ignore for now!
// pred minorScale{
//     --WHWWWWH
//     all scale:Scale, note: Int|{
//     scale.note0=note implies {
//         wholeStep[note, scale.note1]
//         halfStep[scale.note1, scale.note2]
//         wholeStep[scale.note2, scale.note3]
//         wholeStep[scale.note3, scale.note4]
//         wholeStep[scale.note4, scale.note5]
//         wholeStep[scale.note5, scale.note6]
//         halfStep[scale.note6, scale.note7]
//     }
//     }

// }
// ----------------------------------------------------------------------------------------------------
// -- (1) Model the chords using the scales
// ----------------------------------------------------------------------------------------------------