#lang forge/bsl

option run_sterling "scales.js"

----------------------------------------------------------------------------------------------------
-- (1) Model the scales used to create chords
----------------------------------------------------------------------------------------------------
-- Scales are made up of notes
sig Note {
    value: one Int,
    next: lone Note,
    beat: one Int
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
-- Chords are composed of 3 notes from a scale
sig Chord{
    root: one Note, 
   	third: one Note,
    fifth: one Note,
    fourBeats: one Int
}
-- A 4 beat measure composed of a chord and 4 notes from scale
// TODO: figre out how to bring everything together to make measure and simple tune!
sig Measure{
    
}
-- A simple tune composed of 4 measures
one sig SimpleTune{

}
-- Attributes necessary for a wellformed sequence of 8 notes
    -- Each note must have values between 0-11 (notes a-g)
    -- The notes in the scale should not be the same
    -- Each note points to a next note or none
pred wellformed{
    all scale:Scale|{
        // Create valid note values
       scale.n0.value<=11 and scale.n0.value>=0 and scale.n0.beat=1
       scale.n1.value<=11 and scale.n1.value>=0 and scale.n1.beat=1
       scale.n2.value<=11 and scale.n2.value>=0 and scale.n2.beat=1
       scale.n3.value<=11 and scale.n3.value>=0 and scale.n3.beat=1
       scale.n4.value<=11 and scale.n4.value>=0 and scale.n4.beat=1
       scale.n5.value<=11 and scale.n5.value>=0 and scale.n5.beat=1
       scale.n6.value<=11 and scale.n6.value>=0 and scale.n6.beat=1
       scale.n7.value<=11 and scale.n7.value>=0 and scale.n7.beat=1
       // Create valid sequence
       scale.n0.next=scale.n1
       scale.n1.next=scale.n2
       scale.n2.next=scale.n3
       scale.n3.next=scale.n4
       scale.n4.next=scale.n5
       scale.n5.next=scale.n6
       scale.n6.next=scale.n7
       scale.n7.next= none
    }
    // Notes are distinct/ not themself
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
// run{
//     wellformed
// } for 5 Int, exactly 8 Note
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
            wholeStep[scale.n3, scale.n4]
            wholeStep[scale.n4, scale.n5]
            wholeStep[scale.n5, scale.n6]
            halfStep[scale.n6, scale.n7]
        }
    }
}
// run{
//     wellformed
//     majorScale
// } for 5 Int, exactly 8 Note
-- Scales can be minor
pred minorScale{
    --WHWWWWH
    all scale:Scale, note: Note|{
        scale.n0=note implies {
            wholeStep[note, scale.n1]
            halfStep[scale.n1, scale.n2]
            wholeStep[scale.n2, scale.n3]
            wholeStep[scale.n3, scale.n4]
            wholeStep[scale.n4, scale.n5]
            wholeStep[scale.n5, scale.n6]
            halfStep[scale.n6, scale.n7]
        }
    }
 }
----------------------------------------------------------------------------------------------------
-- (2) Model the chords using the scales
----------------------------------------------------------------------------------------------------
pred wellformedChord{
    all chord:Chord|{
        chord.fourBeats=4
    }
}
pred tonicChord{
    all scale:Scale|{
        some tonic:Chord|{ // unsure about quantity, one might work if we split into measures?
            tonic.root=scale.n0
            tonic.third=scale.n2
            tonic.fifth=scale.n4
        }
    }
}
// run{
//     wellformed
//     majorScale
//     wellformedChord
//     tonicChord
// } for 5 Int, exactly 8 Note
pred subdominantChord{
    all scale:Scale|{
        some subdominant:Chord|{
            subdominant.root=scale.n0
            subdominant.third=scale.n3
            subdominant.fifth=scale.n5
        }
    }
}


pred dominantChord{
    all scale:Scale|{
        one dominant:Chord|{
            dominant.root=scale.n6
            dominant.third=scale.n1
            dominant.fifth=scale.n4
        }
    }
}

run{
    wellformed
    majorScale
    wellformedChord
    tonicChord
    subdominantChord
    dominantChord
} for 5 Int, exactly 8 Note
----------------------------------------------------------------------------------------------------
-- (3) Model a simple 5 measure tune with the chords and scales
----------------------------------------------------------------------------------------------------
pred simpleTune{
    
}
