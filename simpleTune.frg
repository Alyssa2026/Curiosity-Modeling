#lang forge/bsl

option run_sterling "simpleTune.js"

----------------------------------------------------------------------------------------------------
-- Create all the necessary objects for a simple tune
----------------------------------------------------------------------------------------------------
-- This represents a note which is the building blocks of a simple tune. 
    -- Value represents the note pitch (a-g)
    -- Next is a pointer to the next note that follows the current note (ensures notes are played sequentially)
    -- Beat represents the duration a note lasts
sig Note {
    value: one Int,
    next: lone Note,
    beat: one Int
}
-- Scales are composed of 8 notes. It establishses the set of 8 notes that can be used to create a simple tune.
    -- n0-n7 are the 8 notes contained in a scale
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
    -- root-fifth are the 3 notes in a chord
    -- Next is a pointer to the next chord that follows the current note (ensures chords are played sequentially)
sig Chord{
    root: one Note, 
   	third: one Note,
    fifth: one Note,
    chordNext: lone Chord
}
-- A simple tune needs a melody
    -- m0-m9 are the 10 notes in a melody
one sig Melody{
    m0: one Note, 
   	m1: one Note,
    m2: one Note,
   	m3: one Note,
    m4: one Note,
    m5: one Note,
    m6: one Note,
    m7: one Note,
    m8: one Note,
    m9: one Note
}
-- A simple tune needs a bass whihc are made of chord progressions in this case
    -- c0-c4 are the 4 chords in a melody
one sig ChordProgression {
    c0: one Chord,
    c1: one Chord,
    c2: one Chord,
    c3: one Chord,
    c4: one Chord
}
-- A simple tune composed of a melody and bass (chord progression)
one sig SimpleTune{
    melody: one Melody, 
    bass: one ChordProgression
}
----------------------------------------------------------------------------------------------------
-- (1) Create a basic valid scale (major or minor)
----------------------------------------------------------------------------------------------------
-- Attributes necessary for a wellformed sequence of 8 notes
    -- Each note must have values between 0-11 (notes a-g)
    -- The notes in the scale should not be the same
    -- Each note points to a next note or none
pred wellformedSequence{
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
    // Ensure notes are distinct and dont equal and point to themself
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
-- Basic predicate to create two notes a whole step apart
pred wholeStep[firstNote, secondNote:Note]{
    add[firstNote.value,2]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote.value= subtract[add[firstNote.value,2],12] 
    }else{
        secondNote.value= add[firstNote.value,2]
    }
}
-- Basic predicate to create two notes a half step apart
pred halfStep[firstNote, secondNote:Note]{
    add[firstNote.value,1]>11 implies{ // wrap around so that we stay within nums 0-11
        secondNote.value= subtract[add[firstNote.value,1],12] 
    }else{
        secondNote.value= add[firstNote.value,1]
    }
}
-- Predicate to create a major scale
pred majorScale{
    -- major scale follows WWHWWWH
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

-- Predicate to create a minor scale
pred minorScale{
    -- minor scale follows WHWWWWH
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
 // run{
//     wellformed
//     majorScale
// } for 5 Int, exactly 8 Note
----------------------------------------------------------------------------------------------------
-- (2) Model the chords using the scales
----------------------------------------------------------------------------------------------------
-- Create a well formed chord
    -- For this tune, it must be 2 beats long
pred wellformedChord{
    all chord:Chord|{
        chord.root.beat=2 
        chord.third.beat=2
        chord.fifth.beat=2
    }
}
-- Creating a tonic chord
pred tonicChord[tonic: Chord] {
    all scale:Scale|{
        // Set correct values of chord
        tonic.root.value=scale.n0.value
        tonic.third.value=scale.n2.value
        tonic.fifth.value=scale.n4.value

        // All notes next points to nothing because they get played at the same time
        tonic.root.next=none
        tonic.third.next=none
        tonic.fifth.next=none
    }
}
-- Creating a subdominant chord
pred subdominantChord[subdominant: Chord]{
    all scale:Scale|{
        // Set correct values of chord
        subdominant.root.value=scale.n0.value
        subdominant.third.value=scale.n3.value
        subdominant.fifth.value=scale.n5.value

        // All notes next points to nothing because they get played at the same time
        subdominant.root.next=none
        subdominant.third.next=none
        subdominant.fifth.next=none
    }
}
-- creating a dominant chord
pred dominantChord[dominant: Chord]{
    all scale:Scale| {
        // Set correct values of chord
        dominant.root.value=scale.n6.value
        dominant.third.value=scale.n1.value
        dominant.fifth.value=scale.n4.value

        // All notes next points to nothing because they get played at the same time
        dominant.root.next=none
        dominant.third.next=none
        dominant.fifth.next=none
    }
}
// run{
//     wellformed
//     majorScale
//     wellformedChord
//     tonicChord
//     subdominantChord
//     dominantChord
// } for 5 Int, exactly 8 Note
----------------------------------------------------------------------------------------------------
-- (3) Model a simple 5 measure tune with the chords and scales
----------------------------------------------------------------------------------------------------
-- Helper to set a note in melody to a random note within the scale
pred createRandomNote[melodyNote: Note] {
   // all scale: Scale | {
 
        some note1: Note | {
            (reachable[note1, Scale.n0, next] or note1 = Scale.n0)
            melodyNote.value = note1.value
        }
 //  }
}
-- Creates teh melody by assigning each note to a random note within the scale
    -- Ensures the notes point to next correctly
pred createMelody{
    all scale:Scale|{
        one mel: Melody | {
            // Assign random note within scale
            createRandomNote[mel.m0] and mel.m0.beat = 1
            createRandomNote[mel.m1] and mel.m1.beat = 1
            createRandomNote[mel.m2] and mel.m2.beat = 1
            createRandomNote[mel.m3] and mel.m3.beat = 1
            createRandomNote[mel.m4] and mel.m4.beat = 1
            createRandomNote[mel.m5] and mel.m5.beat = 1
            createRandomNote[mel.m6] and mel.m6.beat = 1
            createRandomNote[mel.m7] and mel.m7.beat = 1
            createRandomNote[mel.m8] and mel.m8.beat = 1
            createRandomNote[mel.m9] and mel.m9.beat = 1
            // Create valid sequence
            mel.m0.next=mel.m1
            mel.m1.next=mel.m2
            mel.m2.next=mel.m3
            mel.m3.next=mel.m4
            mel.m4.next=mel.m5
            mel.m5.next=mel.m6
            mel.m6.next=mel.m7
            mel.m7.next=mel.m8
            mel.m8.next=mel.m9
            mel.m9.next= none
        }
    }
    // Notes are distinct/not themself
    some mel:Melody, note1, note2:Note|{
        mel.m0=note1 or 
        mel.m1=note1 or
        mel.m2=note1 or
        mel.m3=note1 or
        mel.m4=note1 or
        mel.m5=note1 or
        mel.m6=note1 or 
        mel.m7=note1 or
        mel.m8=note1 or
        mel.m9=note1

        reachable[note1, note2, next] implies{
            note1!=note2  
        } or 
        reachable[note2, note1, next] implies {
            note1!=note2
        }
    }
}
-- Creating a well formed chord progression that will be the bass
pred wellformedChordProg {
    one scale: Scale | {
        // Create the correct sequance of chords to act as bass
        one chordProg: ChordProgression | {
            tonicChord[chordProg.c0]
            subdominantChord[chordProg.c1]
            tonicChord[chordProg.c2]
            dominantChord[chordProg.c3]
            tonicChord[chordProg.c4]
            // Create sequence of chords
            chordProg.c0.chordNext = chordProg.c1
            chordProg.c1.chordNext = chordProg.c2
            chordProg.c2.chordNext = chordProg.c3
            chordProg.c3.chordNext = chordProg.c4
            chordProg.c4.chordNext = none
        }
        // Ensure chords dont equal each other 
        some chordProg:ChordProgression, chord1, chord2:Chord|{
            chordProg.c0=chord1 or 
            chordProg.c1=chord1 or 
            chordProg.c2=chord1 or 
            chordProg.c3=chord1 or 
            chordProg.c4=chord1

            reachable[chord1, chord2, chordNext] implies{
                chord1!=chord2  
            } or 
            reachable[chord2, chord1, chordNext] implies {
                chord1!=chord2
            }
        }
    }
}
-- Putting everything together to create a simple 5 measure simple tune!
pred simpleTune{
    one scale:Scale|{
        one chordProg:ChordProgression|{
            one mel: Melody|{
                one simpleTune:SimpleTune|{
                    simpleTune.melody=mel // melody 
                    simpleTune.bass= chordProg // bass
                }
            }
            
        }
    }
}
run{
    wellformedSequence
    majorScale
    wellformedChord
    wellformedChordProg
    createMelody
    simpleTune
} for 5 Int, 25 Note, exactly 5 Chord
