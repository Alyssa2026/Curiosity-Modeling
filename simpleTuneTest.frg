#lang forge/bsl

open "simpleTune.frg"

test suite for wellformedSequence {

    test expect {
        InvalidLowValues : { // a note's value is less than 0
            wellformedSequence
            some note: Note | {
                (reachable[note, Scale.n0, next] or note = Scale.n0)
                note.value = -2
            }
        } is unsat 

        InvalidHighValues : { // a note's value is greater than 11
            wellformedSequence
            some note: Note | {
                (reachable[note, Scale.n0, next] or note = Scale.n0)
                note.value = 15
            }
        } is unsat 

        nextIsSelf : { // a note is its own next
            wellformedSequence
            some note: Note | {
                (reachable[note, Scale.n0, next] or note = Scale.n0)
                note.next = note
            }
        } is unsat 

        nonDistinctNotes : { // two notes in the scale (that are not 0 and 7) are the same
            wellformedSequence
            some note: Note {
                Scale.n0 = note
                Scale.n5 = note
            }
        } is unsat

        invalidSequence : { // note's next is not the correct next
            wellformedSequence
            Scale.n0.next = Scale.n3
        } is unsat
    }
}


test suite for wholeStep {

    test expect {
        largeWholeStep : { // step that is too big (7)
            wellformedSequence
            some disj n1, n2: Note | {
                n1.value = 1
                n2.value = 8
                wholeStep[n1, n2]
            }
        } is unsat

        smallWholeStep : { // step that is too small (1)
            wellformedSequence
            some disj n1, n2: Note | {
                n1.value = 1
                n2.value = 2
                wholeStep[n1, n2]
            }
        } is unsat

        validWholeStep : { 
            wellformedSequence
            some disj n1, n2: Note | {
                n1.value = 1
                n2.value = 3
                not wholeStep[n1, n2]
            }
        } is unsat
    }
}

test suite for halfStep {
    test expect {
        largeHalfStep : { // step that is too big (2)
            wellformedSequence
            some disj n1, n2: Note | {
                n1.value = 1
                n2.value = 3
                halfStep[n1, n2]
            }
        } is unsat

        smallHalfStep : { // step that is too small (0)
            wellformedSequence
            some disj n1, n2: Note | {
                n1.value = 1
                n2.value = 1
                halfStep[n1, n2]
            }
        } is unsat

        validHalfStep : { 
            wellformedSequence
            some disj n1, n2: Note | {
                n1.value = 1
                n2.value = 2
                not halfStep[n1, n2]
            }
        } is unsat
    }
}

pred validMajScale{
    wholeStep[Scale.n0, Scale.n1]
    wholeStep[Scale.n1, Scale.n2]
    halfStep[Scale.n2, Scale.n3]
    wholeStep[Scale.n3, Scale.n4]
    wholeStep[Scale.n4, Scale.n5]
    wholeStep[Scale.n5, Scale.n6]
    halfStep[Scale.n6, Scale.n7]
}

test suite for majorScale {
    test expect {
        wrongFirstStepMaj : { // first interval is not correct (half instead of whole)
            wellformedSequence
            majorScale
            halfStep[Scale.n0, Scale.n1]
        } is unsat

        rightAndWrongStepsMaj : { // some intervals are correct but some are incorrect
            wellformedSequence
            majorScale
            wholeStep[Scale.n0, Scale.n1]
            wholeStep[Scale.n1, Scale.n2]
            wholeStep[Scale.n2, Scale.n3]
        } is unsat
    } 

    assert validMajScale is sufficient for majorScale
}

pred validMinScale{
    wholeStep[Scale.n0, Scale.n1]
    halfStep[Scale.n1, Scale.n2]
    wholeStep[Scale.n2, Scale.n3]
    wholeStep[Scale.n3, Scale.n4]
    wholeStep[Scale.n4, Scale.n5]
    wholeStep[Scale.n5, Scale.n6]
    halfStep[Scale.n6, Scale.n7]
}

test suite for minorScale {
    test expect {
        wrongFirstStepMin : { // first interval is not correct (half instead of whole)
            wellformedSequence
            minorScale
            halfStep[Scale.n0, Scale.n1]
        } is unsat

        rightAndWrongStepsMin : { // some intervals are correct but some are incorrect
            wellformedSequence
            minorScale
            wholeStep[Scale.n0, Scale.n1]
            halfStep[Scale.n1, Scale.n2]
            halfStep[Scale.n2, Scale.n3]
        } is unsat
    } 

    assert validMinScale is sufficient for minorScale
}

test suite for wellformedChord {
    test expect {
        smallBeatDuration : { // chord durations are too short
            some chord: Chord | {
                chord.root.beat = 1
                chord.third.beat = 1
                chord.fifth.beat = 1
            }
            wellformedChord
        } is unsat

        largeBeatDuration : { // chord durations are too long
            some chord: Chord | {
                chord.root.beat = 5
                chord.third.beat = 2
                chord.fifth.beat = 3
            }
            wellformedChord
        } is unsat

        validBeatDurations : { // chord durations are just right!
            some chord: Chord | {
                chord.root.beat = 2
                chord.third.beat = 2
                chord.fifth.beat = 2
            }
            wellformedChord
        } is sat
    }

}


test suite for tonicChord {
    test expect {
        incorrectTonicRoot : { // tonic root is scale n6 istead of n0
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n6
                c.third = Scale.n2
                c.fifth = Scale.n4
                tonicChord[c]
            }
        } is unsat

        incorrectTonicThird : { // tonic third is scale n3 istead of n2
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n0
                c.third = Scale.n3
                c.fifth = Scale.n4
                tonicChord[c]
            }
        } is unsat

        incorrectTonicFifth : { // tonic fifth is scale n5 istead of n4
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n0
                c.third = Scale.n2
                c.fifth = Scale.n5
                tonicChord[c]
            }
        } is unsat

        validTonic : { // valid tonic chord
            wellformedSequence
            some c: Chord {
                c.root.value = Scale.n0.value
                c.third.value = Scale.n2.value
                c.fifth.value = Scale.n4.value
                not tonicChord[c] 
            }
        } is unsat
    }
}

test suite for subdominantChord {
    test expect {
        incorrectSubdomRoot : { // subdom root is scale n6 istead of n0
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n6
                c.third = Scale.n2
                c.fifth = Scale.n4
                subdominantChord[c]
            }
        } is unsat

        incorrectSubdomThird : { // subdom third is scale n6 istead of n3
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n0
                c.third = Scale.n3
                c.fifth = Scale.n4
                subdominantChord[c]
            }
        } is unsat

        incorrectSubdomFifth : { // subdom fifth is scale n2 istead of n5
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n0
                c.third = Scale.n2
                c.fifth = Scale.n5
                subdominantChord[c]
            }
        } is unsat

        validSubdom : { // valid subdominant chord
            wellformedSequence
            some c: Chord {
                c.root.value = Scale.n0.value
                c.third.value = Scale.n3.value
                c.fifth.value = Scale.n5.value
                not subdominantChord[c] 
            }
        } is unsat
    }
}

test suite for dominantChord {
    test expect {
        incorrectDomRoot : { // subdom root is scale n5 istead of n0
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n5
                c.third = Scale.n1
                c.fifth = Scale.n4
                dominantChord[c]
            }
        } is unsat

        incorrectDomThird : { // subdom third is scale n6 istead of n1
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n6
                c.third = Scale.n6
                c.fifth = Scale.n4
                dominantChord[c]
            }
        } is unsat

        incorrectDomFifth : { // subdom fifth is scale n2 istead of n4
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n6
                c.third = Scale.n1
                c.fifth = Scale.n5
                dominantChord[c]
            }
        } is unsat

        validDom : { // valid subdominant chord
            wellformedSequence
            some c: Chord {
                c.root.value = Scale.n6.value
                c.third.value = Scale.n1.value
                c.fifth.value = Scale.n4.value
                not dominantChord[c] 
            }
        } is unsat
    }
}

test suite for createRandomNote {
    test expect {
        randomNoteNotInScale : { // cannot create a note that's not in the scale
            wellformedSequence
            some disj n1, n2: Note | {
                not reachable[n1, Scale.n0, next] and n1 = Scale.n0
                createRandomNote[n2]
            }
        } is unsat

        validNote : { // there will always be a random note that can be produced 
            wellformedSequence
            not createRandomNote[Scale.n0]
        } is unsat

        noteIs4: {
            wellformedSequence
            some disj n1, n2: Note | {
                n1 = Scale.n4
                not createRandomNote[n2]
            }
        } is unsat
    }
}

test suite for createMelody {
    test expect {
        incorrectBeatVals: { // all melody notes must be 1 beat
            createMelody 
            Melody.m0.beat = 3
            Melody.m1.beat = 1
            Melody.m2.beat = 3
            Melody.m3.beat = 2
            Melody.m4.beat = 3
            Melody.m5.beat = 3
            Melody.m6.beat = 3
            Melody.m7.beat = 1
            Melody.m8.beat = 3
            Melody.m9.beat = 0
        } is unsat

        incorrectNoteVals: {
            createMelody 
            Melody.m0.value = -1
            Melody.m1.value = 14
            Melody.m2.value = 2
            Melody.m3.value = 5
            Melody.m4.value = 0
            Melody.m5.value = -4
            Melody.m6.value = 2
            Melody.m7.value = 3
            Melody.m8.value = -1
            Melody.m9.value = 11
        } is unsat

        nextSelf : { // a note is its own next
            createMelody
            some note: Note | {
                (reachable[note, Melody.m0, next] or note = Melody.m0)
                note.next = note
            }
        } is unsat 

        sameNote : { // two notes are the same
            createMelody
            Melody.m1 = Melody.m2
        } is unsat 
    }
}

pred invalidBeatLength {
    some n: Note | {
        n.beat = 2
    }
}

pred invalidNotes {
    some n: Note | {
        n.value = -1
    } 
}

pred sameNotes {
    some note: Note | {
        (reachable[note, Melody.m0, next] or note = Melody.m0)
        note.next = note
    }
}

pred notCreateMelody {
    not createMelody
}

test suite for notCreateMelody { // purpose: use assert statements to test bad cases of melody
    assert invalidBeatLength is sufficient for notCreateMelody
    assert invalidNotes is sufficient for notCreateMelody
    assert sameNotes is sufficient for notCreateMelody
}


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

test suite for wellformedChordProg {
    test expect {
        incorrectChordTypes: { // all chords shifted by 1
            wellformedChordProg
            tonicChord[ChordProgression.c1]
            subdominantChord[ChordProgression.c2]
            tonicChord[ChordProgression.c3]
            dominantChord[ChordProgression.c4]
            tonicChord[ChordProgression.c0]
        } is unsat

        incorrectChordOrder: {
            wellformedChordProg
            ChordProgression.c0.chordNext = ChordProgression.c3
            ChordProgression.c1.chordNext = ChordProgression.c4
            ChordProgression.c2.chordNext = ChordProgression.c1
            ChordProgression.c3.chordNext = ChordProgression.c2
            ChordProgression.c4.chordNext = none
        } is unsat

        sameChords: { // two chords in the progression are the same
            wellformedChordProg
            ChordProgression.c1 = ChordProgression.c2
        } is unsat

        nextChordSelf : { // a chord is its own next
            wellformedChordProg
            some chord: Chord | {
                (reachable[chord, ChordProgression.c0, chordNext] or chord = ChordProgression.c0)
                chord.chordNext = chord
            }
        } is unsat 
    }
}

pred sameChords {
    some chord: Chord | {
        (reachable[chord, ChordProgression.c0, chordNext] or chord = ChordProgression.c0)
        chord.chordNext = chord
    }
}

pred notWellformedChordProg {
    not wellformedChordProg
}

test suite for notWellformedChordProg { 
    assert sameChords is sufficient for notWellformedChordProg
}