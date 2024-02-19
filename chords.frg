----------------------------------------------------------------------------------------------------
-- (1) Model the scales used to create chords
----------------------------------------------------------------------------------------------------
-- Scales are composed of notes
sig Note{
    value = one Int
    next = one Note // Think we should use next
}
-- Scales are composed of 8 notes 
one sig Scale {
    // Initialize notes
    note0: one Note, 
   	note1: one Note,
    note2: one Note,
   	note3: one Note,
    note4: one Note,
    note5: one Note,
    note6: one Note,
    note7: one Note
    // Initiale notes' next (maybe put into wellformed????)
    note0.next: note1,
    note1.next: note2,
    note2.next: note3,
    note3.next: note4,
    note4.next: note5,
    note5.next: note6,
    note6.next: note7,
    note0.next: none

}

-- Attributes necessary for a wellformed scale 
    -- Must have 8 notes (Already established in sig)
    -- Each note must have values between 0-10
    -- No note should be more than 2 steps away from each other 
pred wellformed{
    all scale:Scale, note:Int|{
        // All values must be between 0-10
       scale.note0=note implies (note0<11 and not0>0)
       // No note should be more than 2 steps away from each other 
        // using next will be helpful!
    }
}
-- Scales can be major 
pred majorScale{

}
-- Scales can be minor
pred minorScale{

}
----------------------------------------------------------------------------------------------------
-- (1) Model the chords using the scales
----------------------------------------------------------------------------------------------------


