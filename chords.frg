#lang forge/bsl
----------------------------------------------------------------------------------------------------
-- (1) Model the scales used to create chords
----------------------------------------------------------------------------------------------------
-- Scales are composed of notes TODO: Use later
// sig Note{
//     value: one Int,
//     next: one Note // Think we should use next
// }
-- Scales are composed of 8 notes 
one sig Scale {
    // Initialize notes
    note0: one Int, 
   	note1: one Int,
    note2: one Int,
   	note3: one Int,
    note4: one Int,
    note5: one Int,
    note6: one Int,
    note7: one Int


}

-- Attributes necessary for a wellformed sequence of 8 notes
    -- Each note must have values between 0-10 (notes a-g)
pred wellformed{
    all scale:Scale, note:Int|{
        // All values must be between 0-10
       scale.note0=note implies (note<=11 and note>=0)
       scale.note1=note implies (note<=11 and note>=0)
       scale.note2=note implies (note<=11 and note>=0)
       scale.note3=note implies (note<=11 and note>=0)
       scale.note4=note implies (note<=11 and note>=0)
       scale.note5=note implies (note<=11 and note>=0)
       scale.note6=note implies (note<=11 and note>=0)
       scale.note7=note implies (note<=11 and note>=0)
    }
}
// run{
//     wellformed
// } for 5 Int
pred wholeStep[firstNote, secondNote:Int]{
    add[firstNote,2]>11 implies{
        secondNote= subtract[add[firstNote,2],12] 
    }else{
        secondNote= add[firstNote,2]
    }
}
pred halfStep[firstNote, secondNote:Int]{
    add[firstNote,1]>11 implies{
        secondNote= subtract[add[firstNote,1],12] 
    }else{
        secondNote= add[firstNote,1]
    }
}
-- Scales can be major 
pred majorScale{
    --WWHWWWH
    all scale:Scale, note: Int|{
     
        scale.note0=note implies {
            wholeStep[note, scale.note1]
            wholeStep[scale.note1, scale.note2]
            halfStep[scale.note2, scale.note3]
            wholeStep[scale.note3, scale.note4]
            wholeStep[scale.note4, scale.note5]
            wholeStep[scale.note5, scale.note6]
            halfStep[scale.note6, scale.note7]
       }
    
    }
}
run{
    wellformed
    majorScale
} for 5 Int
-- Scales can be minor
pred minorScale{
    --WHWWWWH
    scale.note0=note implies {
        wholeStep[note, scale.note1]
        halftep[scale.note1, scale.note2]
        wholeStep[scale.note2, scale.note3]
        wholeStep[scale.note3, scale.note4]
        wholeStep[scale.note4, scale.note5]
        wholeStep[scale.note5, scale.note6]
        halfStep[scale.note6, scale.note7]
    }

}
----------------------------------------------------------------------------------------------------
-- (1) Model the chords using the scales
----------------------------------------------------------------------------------------------------


