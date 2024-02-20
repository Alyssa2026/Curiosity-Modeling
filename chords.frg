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
   	n3: one Note
    // n4: one Note,
    // n5: one Note,
    // n6: one Note,
    // n7: one Note
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
    //   scale.n4.value<=11 and scale.n4.value>=0 // works with only 4 notes and this is commented out 
    //    scale.n5.value<=11 and scale.n5.value>=0
    //    scale.n6.value<=11 and scale.n6.value>=0
    //    scale.n7.value<=11 and scale.n7.value>=0

       scale.n0.next=scale.n1
       scale.n1.next=scale.n2
       scale.n2.next=scale.n3
       scale.n3.next=none

    //    scale.n4.next=scale.n5 // works with only 4 notes and this is commented out 
    //    scale.n5.next=scale.n6
    //    scale.n6.next=scale.n7
    //    scale.n7.next= none

    
 
    }
    some scale:Scale, note1, note2:Note|{
        scale.n0=note1 or 
        scale.n1=note1 or
        scale.n2=note1 or
        scale.n3=note1 or
        // scale.n4=note1 or
        // scale.n5=note1 or
        // scale.n6=note1 or 
        // scale.n7=note1

        reachable[note1, note2, next] implies{
            note1!=note2  
        } or 
        reachable[note2, note1, next] implies {
             note1!=note2
        }
    }
}
// run{
//     wellformed
// } for 5 Int
-- Basic predicate to ensure two notes are a whole step apart
pred wholeStep[firstNote, secondNote:Note]{
    add[firstNote.value,2]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote.value= subtract[add[firstNote.value,2],12] 
    }else{
        secondNote.value= add[firstNote.value,2]
    }
}
pred halfStep[firstNote, secondNote:Note]{
    add[firstNote.value,1]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote.value= subtract[add[firstNote.value,1],12] 
    }else{
        secondNote.value= add[firstNote.value,1]
    }
}
-- Scales can be major 
pred majorScale{
    --WWHWWWH
    all scale:Scale, note: Note|{
     
        scale.n0=note implies {
            wholeStep[note, scale.n1]
            wholeStep[scale.n1, scale.n2]
            halfStep[scale.n2, scale.n3]

            // wholeStep[scale.n3, scale.n4]
            // wholeStep[scale.n4, scale.n5]
            // wholeStep[scale.n5, scale.n6]
            // halfStep[scale.n6, scale.n7]
        }
    
    }
}
run{
    wellformed
    majorScale
} for 5 Int
-- Scales can be minor
// pred minorScale{
//     --WHWWWWH
//     all scale:Scale, note: Note|{
//     scale.n0=note implies {
//         wholeStep[note, scale.n1]
//         halfStep[scale.n1, scale.n2]
//         wholeStep[scale.n2, scale.n3]
//         wholeStep[scale.n3, scale.n4]
//         wholeStep[scale.n4, scale.n5]
//         wholeStep[scale.n5, scale.n6]
//         halfStep[scale.n6, scale.n7]
//     }
//     }

//  }
// ----------------------------------------------------------------------------------------------------
// -- (1) Model the chords using the scales
// ----------------------------------------------------------------------------------------------------