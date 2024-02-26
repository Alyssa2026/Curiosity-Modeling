# Curiosity-Modeling: Simple Tune

### Click here to listen to a sample tune modeled by forge!

### Project Objective:

Overall, we are trying to model a simple tune for 10 beats.

In general, a tune is composed of a **bass** and **melody** all developed in the same **key**. We can define a certain **key** as all notes in a certain scale (there are 12 scales, thus 12 keys). Both these components are made up of **notes** that have a **value/pitch** and **beat/duration**.

- **Bass:** A bass tune can be created through **chord progressions** which are simple series of various chords. **Chords** are a series of notes played simultaneously. Usually the bass notes are longer lasting and richer, establishing the harmonic framework of the composition. It provides depth and rhythm to the tune.

- **Melody:** The melody overlays the bass, offering a distinct musical tune that is supported by the bass. This is where the movement of the tune generally exists.

Overall, we made a lot abstractions to encapulsates this complex musical framework for a simple tune which is discussed at the end of the README.

### Model Design and Visualization:

Overall we structured our model by working down up. We created small models and objects that represent building blocks of a simple melody. We start but developing notes, then scales, then eventually a melody and bass (chord progression). We use reachable to ensure notes dont point to each other and to retrieve 10 random notes in a key for our melody. Secondly, we use helper predicates like "halfstep" to build larger predicates such as major scale.

We called run statements for all the larger predicates to ensure they function correctly. First we ran "wellformed" to ensure we could retrieve valid 8 sequences of notes. Then, we ran wellformed+major (or minor) scale to ensure that we can build a valid scale and define a valid key of notes (very important when creating a simple tune). Then we testing chord progressions to make sure we can create valid chords in a given key. Then, we ran everything to ensure that we got a valid simple tune. We specifically checked for key synchronization, valid chrod progressions, and a melody where all notes existed in the scale/key. We also had to run for  5 Int, 25 Note, exactly 5 Chord to ensure we had enough samples of objects and had randomness in our melody when randomly getting 10 notes.  

- **Visualization:**

We created a custom visualizationt that is very similar to key's visualization. When you run the script, you will see three boxes.

- The first box is gives a valid 8 note scale start from any note. The first row labels note 0,1,..,7. The second row gives each note's number value from 0-11. The last row shows the number value translated to the alphabetical note value

- The second box shows the 5 chord progressions used for the melody. Row one labels the chords 0-4. Second-fourth row show the three notes in each chord.

- Finally the last box shows the melody. It has 10 notes. First row labels notes 0-9. The second row gives each note's number value from 0-11. The last row shows the number value translated to the alphabetical note value.

Overall, box one is the key, box 2 is the bass (chord progressions), and box 3 is the melody. Combined, we visually see a simply 10 beat tune!

### Signatures and Predicates:

Sigs:

- Note: The building block to a tune are notes. They contain a value describing the note and next which allows you to follow the sequence of notes that must be played.

- Scale: Scales are composed of 8 notes and follow various music theory rules. We used "one sig" so that everything will be composed off the the one scale. This allows for everything (chords, melody) to be in the same key.

- Chord: Chords are created by combining multiple notes and playing them together. There values are dependent on the scale/key. There are many valid chords in a key, so we don't use "one".

- Melody: For simplicity, a melody is made by 10 random notes that exist in the the scale.

- ChordProgression: This is composed of multiple sequences of chords structured through music theory. There only exist one chord progression since we decided to only using the basic tonic, subdominant, dominant chord sequence. Thus, there will only be one valid chrod progression for each key

- SimpleTune: Composed of melody and bass (chord progressions).

Predicates:

- wellformedSequence: describes a wellformed 8 notes sequence to develop fundamental scale

- wholeStep/halfStep: establishes how far a note is relative the the next note (either 1 or 2 notes apart). This is utilized to build scales since scales are purely built of a formula of notes whole/halg steps apart.

- major/minor scales: scales that are built by formulic whole/half step apart notes.

- tonic/sub/dom: establishes three valid chords used to create chord progressions

- chordProgression: built upon the defined three chords we made

- createRandomNote: returns a random note in the scale that can be used in the melody

- melody: built on 10 random notes derived from the createRandomNote predicate

- simpleTune: built by the chordProgression and melody predicates

### Testing:

What tests did you write to test your model itself? What tests did you write to verify properties about your domain area? Feel free to give a high-level overview of this.

We wrote a test for every predicate, and focused on testing configurations that would not satisfy 
the predicate. For all the wellformed predicates the tests focus on ensuring the correct sequence
of the notes/chords, making sure that any two notes/chords are not the same, any note does not
point to itself, and notes/chords are the right length and within the correct range of note values
(0-11). We tested the smaller predicates such as whole and half steps by creating examples that
contradicted our predicates. For predicates such as creating a valid scale or melody, we
constructed these "objects" with faults in them to ensure that they wouldn't be a valid example 
of the predicates. We used a mix of test expects as well as assert statements to ensure a wide 
variety of tests.

### Abstractions and Assumptions:
Due to the complexity of music theory and developing music, we made a lot of abstractions and assumptions for this model.
 - First, we confined our scale and key to only major and minor scales. There are dozens of unique scales we could of used to be the fundemental block of our simple tune, but we stuck to the most common and basic scales.
 - Secondly, we also only stuck to using the most basic chord progressions (tonic-sub-dom). Just like scales, there are hundreds of unique combos!
 - Third, we really simplified the development of a melody. The creation of melodies are subjective to time, period, and person, so for this, we just stuck to a simple rule of as long as a note is within the scales/key we created, it was valid
 - Forth, a large abstraction we made for our tune is that it only describs each notes raw value (a,b,c,d etc.) without consideration of pitch, octave, etc. 
Overall, as mentioned, music is complex, but we enjoyed using the musical concepts we have learned from many years to create a fun simple tune :). 

Feel free to listen to an awesome, beautiful simple tune created by our model here.
