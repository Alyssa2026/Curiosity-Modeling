/*
  Script for physical keys assignment in 1710. BASIC version.

    - assumes sig, field names from stencil 
    - assumes 5 chambers per lock 

    - Reminder: visual objects take a props object now, not arbitrary args
    - Note: this requires the Jan 20, 2024 Sterling patch to work.
*/

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

// Lock will be something like [[Lock$0], [Lock$1], ...]
const locks = Lock.tuples().map((ltup) => fam(ltup));

// The raw numbers allowed for chambers and cut lengths
const CHAMBER_OPTIONS_RAW = [0, 1, 2, 3, 4];
const CUT_OPTIONS_RAW = [1, 2, 3, 4, 5];
// The atoms corresponding to those numbers, used in the instance
// breaks: Lock -> Int -> Int -> Boolean
// Lock.join(breaks): Int -> Int -> Boolean
const CHAMBER_OPTIONS = Lock.join(breaks)
  .join(Boolean)
  .join(Int)
  .tuples()
  .map(fam)
  .filter(atomIdIn(CHAMBER_OPTIONS_RAW));
const CUT_OPTIONS = Int.join(Lock.join(breaks).join(Boolean))
  .tuples()
  .map(fam)
  .filter(atomIdIn(CUT_OPTIONS_RAW));

// NOTE: IGNORE THIS IF WE AREN'T AT THAT POINT IN THE PROBLEM
const solution = [
  fam(Key.join(cut0)),
  fam(Key.join(cut1)),
  fam(Key.join(cut2)),
  fam(Key.join(cut3)),
  fam(Key.join(cut4)),
];

const lockGridConfig = {
  // Absolute location in parent (here, of the stage itself)
  grid_location: { x: 10, y: 150 },
  // How large is each cell?
  cell_size: { x_size: 80, y_size: 50 },
  // How many rows and columns?
  grid_dimensions: {
    // One row for every lock
    y_size: locks.length,
    // One column for every chamber, plus name
    x_size: 5 + 1,
  },
};

const solutionGridConfig = {
  // Absolute location in parent (here, of the stage itself)
  grid_location: { x: 10, y: 10 },
  // How large is each cell?
  cell_size: { x_size: 50, y_size: 50 },
  // How many rows and columns?
  grid_dimensions: { y_size: 1, x_size: 5 },
};

//    const label = new TextBox(processState2String(inst, p),{x:0,y:0},'black',16)
//   traceGrid.add({x:i+1, y:0}, new TextBox(`t=${i}`,{x:0,y:0},color,16))
const lockGrid = new Grid(lockGridConfig);
const solutionGrid = new Grid(solutionGridConfig);

// Populate solution numbers
solution.forEach((val, idx) => {
  solutionGrid.add({ x: idx, y: 0 }, new TextBox({ text: `${val}` }));
});

// Populate a row in the lock info table for each lock
locks.forEach((lockVal, lockIdx) => {
  // Populate label
  lockGrid.add({ x: 0, y: lockIdx }, new TextBox({ text: `${lockVal.id()}` }));
  // Populate cut numbers for each chamber
  CHAMBER_OPTIONS.forEach((chamberVal, chamberIdx) => {
    lockGrid.add(
      { x: chamberIdx + 1, y: lockIdx },
      new TextBox({ text: `${cutsAt(lockVal, chamberVal)}` })
    );
  });
});

/** Extract a string containing the cut lengths for this lock and this chamber */
function cutsAt(l, c) {
  // Avoid joining vs. JS numbers; instead do this:
  const l_cuts_true = l.join(breaks).join(True);
  const depths = c.join(l_cuts_true);
  return depths;
}

// Finally, render everything
const stage = new Stage();
stage.add(lockGrid);
stage.add(solutionGrid);
stage.render(svg);
