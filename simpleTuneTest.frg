#lang forge/bsl

open "simpleTune.frg"

// pred validNotes {
//     all disj n1, n2: Note | {
//        // n1 != n2
//         n1.value >= 0 and n1.value <= 11 and n1.beat = 1
//         n2.value >= 0 and n2.value <= 11 and n2.beat = 1

//         #{Note} = 8
//     }
// }

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

   //assert validNotes is sufficient for wellformedSequence

    //  example validScale is {wellformedSequence} for {
    //         Scale = `scale
    //         Note = `n7 + `n1 + `n2 + `n3 + `n4 + `n5 + `n6 + `n0
    //         `n5.value = 0 
    //         `n6.value = 2 
    //         `n7.value = 11
    //         `n0.value = 4
    //         `n1.value = 8 
    //         `n2.value = 9
    //         `n3.value = 1
    //         `n4.value = 4

    //         `n0.beat = 1
    //         `n1.beat = 1 
    //         `n2.beat = 1
    //         `n3.beat = 1
    //         `n4.beat = 1
    //         `n5.beat = 1 
    //         `n6.beat = 1 
    //         `n7.beat = 1

    //         `scale.n0 = `n0
    //         `scale.n1 = `n1
    //         `scale.n2 = `n2
    //         `scale.n3 = `n3
    //         `scale.n4 = `n4
    //         `scale.n5 = `n5
    //         `scale.n6 = `n6
    //         `scale.n7 = `n7

    //         `n0.next = `n1
    //         `n1.next = `n2
    //         `n2.next = `n3
    //         `n3.next = `n4
    //         `n4.next = `n5
    //         `n5.next = `n6
    //         `n6.next = `n7
    //     } for 5 Int 
}

// pred largeStep {
//     some disj n1, n2: Note | {
//         subtract[n1.value, n2.value] = 5
//     }
// }

// pred notWholeStep {
//     not wholeStep
// }
test suite for wholeStep {
      // assert largeStep is sufficient for notWholeStep

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

        validWholeStep : { // when i do wholeStep and sat it produces undefined... 
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

        validHalfStep : { // when i do halfStep and sat it produces undefined... 
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

test suite for tonicChord {
    test expect {
        incorrectRoot : { // tonic root is scale n6 istead of n0
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n6
                c.third = Scale.n2
                c.fifth = Scale.n4
                tonicChord[c]
            }
        } is unsat

        incorrectThird : { // tonic third is scale n3 istead of n2
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n0
                c.third = Scale.n3
                c.fifth = Scale.n4
                tonicChord[c]
            }
        } is unsat
        incorrectFifth : { // tonic fifth is scale n5 istead of n4
            wellformedSequence
            some c: Chord | {
                c.root = Scale.n0
                c.third = Scale.n2
                c.fifth = Scale.n5
                tonicChord[c]
            }
        } is unsat
    }
}