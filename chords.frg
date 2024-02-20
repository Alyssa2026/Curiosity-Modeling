#lang forge/bsl

//option run_sterling "chords.js"

----------------------------------------------------------------------------------------------------
-- (1) Model the scales used to create chords
----------------------------------------------------------------------------------------------------
-- Scales are composed of notes TODO: Use later
sig Note {
    value: one Int
    //next: one Note // Think we should use next
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
    -- Each note must have values between 0-10 (notes a-g)
pred wellformed{
    all scale:Scale|{
       // some note0, note1, note2, note3, note4, note5, note6, note7: Note |{
        // All values must be between 0-10
        scale.n0 != scale.n1
        scale.n1 != scale.n2
        scale.n0 != scale.n2
        scale.n0 != scale.n3
        scale.n1 != scale.n3
        scale.n2 != scale.n3
        


       scale.n0.value = 0
       scale.n1.value<=11 and scale.n1.value>=0
       scale.n2.value<=11 and scale.n2.value>=0
       scale.n3.value<=11 and scale.n3.value>=0
    //    scale.n4=note4 implies (note4.value<=11 and note4.value>=0)
    //    scale.n5=note5 implies (note5.value<=11 and note5.value>=0)
    //    scale.n6=note6 implies (note6.value<=11 and note6.value>=0)
    //    scale.n7=note7 implies (note7.value<=11 and note7.value>=0)
    }
    }
//}
// run{
//     wellformed
// }
// for 5 Int
pred wholeStep[firstNote, secondNote:Int]{
    add[firstNote,2]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote= subtract[add[firstNote,2],12] 
    }else{
        secondNote= add[firstNote,2]
    }
}
pred halfStep[firstNote, secondNote:Int]{
    add[firstNote,1]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote= subtract[add[firstNote,1],12] 
    }else{
        secondNote= add[firstNote,1]
    }
}
-- Scales can be major 
pred majorScale{
    --WWHWWWH
    all scale:Scale, note: Int|{
     
        scale.n0.value=note implies {
            wholeStep[note, scale.n1.value]
            wholeStep[scale.n1.value, scale.n2.value]
            halfStep[scale.n2.value, scale.n3.value]
    //         wholeStep[scale.n3.value, scale.n4.value]
    //         wholeStep[scale.n4.value, scale.n5.value]
    //         wholeStep[scale.n5.value, scale.n6.value]
    //         halfStep[scale.n6.value, scale.n7.value]
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