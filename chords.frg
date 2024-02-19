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
    note0: one Note, // how would we use next here
   	note1: one Note,
    note2: one Note,
   	note3: one Note,
    note4: one Note,
    note5: one Note,
    note6: one Note,
    note7: one Note
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
