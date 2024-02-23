# Curiosity-Modeling: Simple Tune

### Click here to listen to a sample tune modeled by forge!

### Project Objective:

Overall, we are trying to model a simple tune for 10 beats.

In general, a tune is composed of a **bass** and **melody** all developed in the same **key**. We can define a certain **key** as all notes in a certain scale (there are 12 scales, thus 12 keys). Both these components are made up of **notes** that have a **value/pitch** and **beat/duration**.

- **Bass:** A bass tune can be created through **chord progressions** which are simple series of various chords. **Chords** are a series of notes played simultaneously. Usually the bass notes are longer lasting and richer, establishing the harmonic framework of the composition. It provides depth and rhythm to the tune.

- **Melody:** The melody overlays the bass, offering a distinct musical tune that is supported by the bass. This is where the movement of the tune generally exists.

Overall, we made a lot abstractions to encapulsates this complex musical framework for a simple tune which is discussed at the end of the README.

### Model Design and Visualization:

- **Model design:** 

    Structure: 
    - Notes: The building block to a tune are notes.

    - Scales: Scales are composed of 8 notes and follow various music theory rules.

    - Chords: Chords are created by combining multiple notes and playing them together. 

    - Melody: For simplicity, a melody is made by 10 random notes that exist in the the scale.

    - ChordProgression: This is composed of multiple sequences of chords structured through music theory. 

    - SimpleTune: Composed of melody and bass (chord progressions)

    Design Choices:
    - ADD MORE DESIGN STUFF
- **Visualization:** 


notes
  Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by the Sterling visualizer. How should we look at and interpret an instance created by your spec? Did you create a custom visualization, or did you use the default?

### Signatures and Predicates:

At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together.

### Testing:

What tests did you write to test your model itself? What tests did you write to verify properties about your domain area? Feel free to give a high-level overview of this.

### Documentation:

Make sure your model and test files are well-documented. This will help in understanding the structure and logic of your project.

### Abstractions and Assumptions:
