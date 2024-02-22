/** Helper to extract the atom from a singleton
 *  Note: this does not convert to the atom's id(); may get wrapping [] */
function firstAtomOf(expr) {
  if (!expr.empty()) return expr.tuples()[0].atoms()[0];
  return "none";
}
const fam = firstAtomOf; // shorthand
/** Helper that returns a filter-function that filters for a specific set of atom IDs */
function atomIdIn(idArr) {
  return (atomObj) => atomObj.id() in idArr;
}

const numberToLetterMap = {
  0: "A",
  1: "A#/Bb",
  2: "B",
  3: "C",
  4: "C#/Db",
  5: "D",
  6: "D#/Eb",
  7: "E",
  8: "F",
  9: "F#/Gb",
  10: "G",
  11: "G#/Ab",
};

function numberToNote(number) {
  return numberToLetterMap[number];
}

// Model a scale
const scale = [
  Scale.n0,
  Scale.n1,
  Scale.n2,
  Scale.n3,
  Scale.n4,
  Scale.n5,
  Scale.n6,
  Scale.n7,
];

const chordProg = [
  ChordProgression.c0,
  ChordProgression.c1,
  ChordProgression.c2,
  ChordProgression.c3,
  ChordProgression.c4
];

const tuneMelody = [
  Melody.m0,
  Melody.m1,
  Melody.m2,
  Melody.m3,
  Melody.m4,
  Melody.m5,
  Melody.m6,
  Melody.m7,
  Melody.m8,
  Melody.m9,
];

// Configuration of the grid
const scaleGridConfig = {
  // Absolute location in parent (here, of the stage itself)
  grid_location: { x: 20, y: 40 },
  // How large is each cell?
  cell_size: { x_size: 70, y_size: 55 },
  // How many rows and columns?
  grid_dimensions: { y_size: 3, x_size: 8 },
};

const scaleGrid = new Grid(scaleGridConfig);

// Populate solution numbers
scale.forEach((note, idx) => {
  scaleGrid.add({ x: idx, y: 0 }, new TextBox({ text: `Note ${idx}` }));
  scaleGrid.add({ x: idx, y: 1 }, new TextBox({ text: `${note.value}` }));
  scaleGrid.add(
    { x: idx, y: 2 },
    new TextBox({
      text: `${numberToNote(parseInt(Object.values(note.value)))}`,
    })
  );
});


const chordProgGridConfig = {
  // Absolute location in parent (here, of the stage itself)
  grid_location: { x: 20, y: 250 },
  // How large is each cell?
  cell_size: { x_size: 70, y_size: 40 },
  // How many rows and columns?
  grid_dimensions: { y_size: 4, x_size: 5 },
};

const chordProgGrid = new Grid(chordProgGridConfig);

// Populate solution numbers
chordProg.forEach((chord, idx) => {
  chordProgGrid.add({ x: idx, y: 0 }, new TextBox({ text: `Chord ${idx}` }));
  chordProgGrid.add({ x: idx, y: 1 }, new TextBox({
      text: `${numberToNote(parseInt(Object.values(chord.root.value)))}`,
    })
  );
  chordProgGrid.add(
    { x: idx, y: 2 },
    new TextBox({
      text: `${numberToNote(parseInt(Object.values(chord.third.value)))}`,
    })
  );
  chordProgGrid.add(
    { x: idx, y: 3 },
    new TextBox({
      text: `${numberToNote(parseInt(Object.values(chord.fifth.value)))}`,
    })
  );
});



const melodyGridConfig = {
  // Absolute location in parent (here, of the stage itself)
  grid_location: { x: 20, y: 450 },
  // How large is each cell?
  cell_size: { x_size: 60, y_size: 40 },
  // How many rows and columns?
  grid_dimensions: { y_size: 3, x_size: 10 },
};

const melodyGrid = new Grid(melodyGridConfig);

// Populate solution numbers
tuneMelody.forEach((note, idx) => {
    melodyGrid.add({ x: idx, y: 0 }, new TextBox({ text: `Note ${idx}` }));
    melodyGrid.add({ x: idx, y: 1 }, new TextBox({ text: `${note.value}` }));
    melodyGrid.add(
      { x: idx, y: 2 },
      new TextBox({
        text: `${numberToNote(parseInt(Object.values(note.value)))}`,
      })
    );
});

// Finally, render everything
const stage = new Stage();
stage.add(scaleGrid);
stage.add(chordProgGrid);
stage.add(melodyGrid);
stage.render(svg);
