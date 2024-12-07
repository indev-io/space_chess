import * as THREE from "../../vendor/three/three.module.js"
import { OrbitControls } from "../../vendor/three/OrbitControls.js"
//needed for eval
window.THREE = THREE
const screenSize = 1.5
const ThreeHook = {
    mounted(){
    const hook = this
    const scene = new THREE.Scene();
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth /screenSize , window.innerHeight/ screenSize);
    this.el.appendChild(renderer.domElement);
    renderer.setClearColor(0x000000, 0)

//GLOBAL VALUES

    let currentUpDirection = [0, 0, 1]
    let currentFacingDirection = [0, 1, 0]
    const startingOrientation = {up: [0, 0, 1], facing: [0, 1, 0]}
    let center;
    let dimensions;
    let cursorPosition;
    let rotationInfo;
    let selectedPiece = "";
    let cursorTransformations = {
    "up" : [0, 0, 1],
    "down": [0, 0, -1],
    "left": [-1, 0, 0],
    "right": [1, 0, 0],
    "backward": [0, -1, 0],
    "forward": [0, 1, 0] 
  }
  //Stores moves and location information
    let pieceInfo = []
    const color = 0xFFFFFF;
    const intensity = 10;
    let light = new THREE.DirectionalLight(color, intensity);
    let ambientLight = new THREE.AmbientLight(color, 5);
    let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.up.set(currentUpDirection[0], currentUpDirection[1], currentUpDirection[2])
    let controls = new OrbitControls(camera, renderer.domElement)

 
//-----------------



function onWindowResize(){
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize( window.innerWidth /screenSize, window.innerHeight /screenSize );
}

window.addEventListener( 'resize', onWindowResize, false );

function setupRotationalInfo(){

  const maxX = dimensions.columns
  const maxY = dimensions.rows
  const maxZ = dimensions.levels
  const minX = 1
  const minY = 1
  const minZ = 1

  const a = center[0]
  const b = center[1]
  const c = center[2]
  const offset = 5
  const newRotationalInfo = 
  [
  {up: [1, 0, 0], facing: [0, 1, 0], position: [a, minY - offset , c]},
  {up: [1, 0, 0], facing: [0, -1, 0],  position: [a, maxY + offset , c]},
  {up: [1, 0, 0], facing: [0, 0, 1], position: [a, b, minZ - offset]},
  {up: [1, 0, 0], facing: [0, 0, -1], position: [a, b, maxZ + offset]},
  {up: [-1, 0, 0], facing: [0, 1, 0], position: [a, minY - offset , c]},
  {up: [-1, 0, 0], facing: [0, -1, 0], position: [a, maxY + offset, c]},
  {up: [-1, 0, 0], facing: [0, 0, 1], position: [a, b, minZ - offset]},
  {up: [-1, 0, 0], facing: [0, 0, -1], position: [a, b, maxZ + offset]},
  {up: [0, 1, 0], facing: [1, 0, 0], position: [minX - offset, b, c] },
  {up: [0, 1, 0], facing: [-1, 0, 0], position: [maxX + offset , b, c]},
  {up: [0, 1, 0], facing: [0, 0, 1], position: [a, b, minZ - offset]},
  {up: [0, 1, 0], facing: [0, 0, -1], position: [a, b, maxZ + offset]},
  {up: [0, -1, 0], facing: [1, 0, 0], position: [minX - offset , b, c] },
  {up: [0, -1, 0], facing: [-1, 0, 0], position: [maxX + offset , b, c]},
  {up: [0, -1, 0], facing: [0, 0, 1], position: [a, b, minZ - offset]},
  {up: [0, -1, 0], facing: [0, 0, -1], position: [a, b, maxZ + offset]},
  {up: [0, 0, 1], facing: [1, 0, 0], position: [minX - offset , b, c] },
  {up: [0, 0, 1], facing: [-1, 0, 0], position: [maxX + offset , b, c]},
  {up: [0, 0, 1], facing: [0, 1, 0], position: [a, minY - offset, c]},
  {up: [0, 0, 1], facing: [0, -1, 0], position: [a, maxY + offset, c]},
  {up: [0, 0, -1], facing: [1, 0, 0], position: [minX - offset , b, c]},
  {up: [0, 0, -1], facing: [-1, 0, 0], position: [maxX + offset , b, c]},
  {up: [0, 0, -1], facing: [0, 1, 0], position: [a, minY - offset, c]},
  {up: [0, 0, -1], facing: [0, -1, 0], position: [a, maxY + offset, c]},
  ]
  rotationInfo = newRotationalInfo
}
function setupCenter(payload){
  dimensions = payload.board_dimensions
  const columns = dimensions.columns 
  const rows = dimensions.rows
  const levels = dimensions.levels
  center = calculateCenter(rows, columns, levels)
}

function setupCamera(){
  const cameraPosition = getPositionFromRotationInfo(currentUpDirection, currentFacingDirection)
  const [x, y, z] = cameraPosition
  camera.position.set(x, y, z)
  controls.target = new THREE.Vector3(center[0], center[1], center[2])
  camera.lookAt(center[0], center[1], center[2])
}

function setupLights(){
  light.position.set(center[0], center[1] - 6, center[2]);
  scene.add(light);
  ambientLight.position.set(center[0], center[1] - 6, center[2]);
  scene.add(ambientLight);
}

  function calculateCenter(rows, columns, levels){
    const rowCenter = Math.ceil(rows/2)
    const columnCenter = Math.ceil(columns/2)
    const levelCenter = Math.ceil(levels/2)
    return [rowCenter, columnCenter, levelCenter]
  }

  function addCursorCube(x,y,z){
    cursorPosition = [x, y, z]
    const geometry = new THREE.BoxGeometry( 1, 1, 1);
    const material = new THREE.MeshLambertMaterial( { color: 0x0000ff, transparent: true, opacity: 0.6} );
    const o = new THREE.Mesh( geometry, material );
    scene.add( o );
    o.position.set(x,y,z)
    o.name = 'cursor'   
}

function addSelectedCube(location){
  const [x, y, z] = location
  const geometry = new THREE.BoxGeometry( 1, 1, 1);
  const material = new THREE.MeshLambertMaterial( { color: 0x00ff00, transparent: true, opacity: 0.8} );
  const o = new THREE.Mesh( geometry, material );
  o.position.set(x,y,z)
  o.name = "selected"   
  scene.add( o );

}

function addHighlightedMoves(listOfMoves){
  const highlightedGroup = new THREE.Group()
  highlightedGroup.name = 'highlightedGroup'
  for (let i = 0; i < listOfMoves.length; i++){
    const [x, y, z] = listOfMoves[i]
    const geometry = new THREE.BoxGeometry( 1, 1, 1);
    const material = new THREE.MeshLambertMaterial( { color: 0x0000ff, transparent: true, opacity: 0.6} );
    const o = new THREE.Mesh( geometry, material );
    o.position.set(x,y,z)
    highlightedGroup.add(o)
  }
  scene.add(highlightedGroup)
}

  function render3Dgrid(rows, columns, levels){
    const gridGroup = new THREE.Group()
    gridGroup.name = 'gridGroup'
    //generate 3D arr
    for (let i = 0; i < rows; i++) {
        for (let j = 0; j < columns; j++) {
          for (let k = 0; k < levels; k++){
                const boxGeo = new THREE.BoxGeometry(1, 1, 1),
                edgeGeo = new THREE.EdgesGeometry(boxGeo),
                line = new THREE.LineSegments(
                    edgeGeo,
                    new THREE.LineBasicMaterial({
                        color: new THREE.Color('white')
                    }));
                line.position.set(i + 1, j + 1, k + 1)
                gridGroup.add(line);
          }
        }
      }
      gridGroup.visible = true;
      scene.add(gridGroup)
    }


  function clearHighlightedMoves(){
    const highlightedGroup = scene.getObjectByName("highlightedGroup")
    scene.remove(highlightedGroup)
  }

  function clearSelectedCube(){
    const selectedCube = scene.getObjectByName("selected")
    scene.remove(selectedCube)
  }

  function returnInfoIfPieceExistsOnSpace(currentPosition){
    for (let i = 0; i < pieceInfo.length; i++){
      if (arraysEqual(pieceInfo[i].position, currentPosition)){
        return pieceInfo[i]
      }
    }
  }

  function returnInfoOfPieceByName(pieceName){
    for (let i = 0; i < pieceInfo.length; i++){
      if (pieceInfo[i].name === pieceName){
        return pieceInfo[i]
      }
    }
  }

  function moveLegal(endingPosition, moves){
    for (let i = 0; i < moves.length; i++){
       if (arraysEqual(moves[i], endingPosition)){
        return true
       }
    }
    return false
  }


  function changeCursorCubeToSelectedMode(){
    const cursorCube = scene.getObjectByName("cursor")
    cursorCube.material.color.set(0x00ff00)
    cursorCube.material.opacity = 0.9
  }

  function changeCursorCubeToDefaultMode(){
    const cursorCube = scene.getObjectByName("cursor")
    cursorCube.material.color.set(0x0000ff)
    cursorCube.material.opacity = 0.6
  }

  function handleSelect(){
    //if something is in hand
    if (selectedPiece !== ""){
      clearHighlightedMoves()
      clearSelectedCube()
      changeCursorCubeToDefaultMode()
      makeMove(selectedPiece, cursorPosition)
      selectedPiece = ""
    } else {
    //if hand empty
    const pieceInfo = returnInfoIfPieceExistsOnSpace(cursorPosition)
    if (pieceInfo){
      selectedPiece = pieceInfo.name
      changeCursorCubeToSelectedMode()
      addSelectedCube(pieceInfo.position)
      addHighlightedMoves(pieceInfo.moves)
    }
    }
  }

  function movePiece(piece, endingPosition){
    const [x, y, z] = endingPosition
    const selectedPiece = scene.getObjectByName(piece)
    selectedPiece.position.set(x, y, z)
  }

  function makeMove(piece, endingPosition){
    const pieceInfo = returnInfoOfPieceByName(piece)
    if (moveLegal(endingPosition, pieceInfo.moves)){
      movePiece(piece, endingPosition)
      hook.pushEvent("makeMove", {move: endingPosition})
    } 
  }

  function animateMove(piece, endingPosition){

  }

  //handle Select
  //if piece selected is not empty, 
  // --> makes a move
  //--> deselects after making a move
  //--> move is then checked after it is made
  //if move is good, move piece
  //send data to elixir


  function handleDeSelect(){
    clearHighlightedMoves()
    clearSelectedCube()
    changeCursorCubeToDefaultMode()
    selectedPiece = ""
  }


  //primitive
  function setupBoard(payload){
    // scene.clear()
    dimensions = payload.board_dimensions
    const columns = dimensions.columns 
    const rows = dimensions.rows
    const levels = dimensions.levels
    render3Dgrid(rows, columns, levels)
    const pieces = payload.pieces
    for (const [piece, info] of Object.entries(pieces)) {
      const model = info.model
      const evalObj = { eval };
      const geometry = evalObj.eval(`new THREE.${model}`)
      const material = new THREE.MeshStandardMaterial( { color: info.color, roughness: 0.477, metalness: 1} )
      const obj = new THREE.Mesh( geometry, material );

      scene.add(obj)
      const [x, y, z] = info.position
      obj.position.set(x, y, z)
      obj.name = piece

      const new_info = {
        name: piece,
        position: info.position,
        moves: info.moves
      }
      addPieceInfo(new_info)
    }
  }

  function addPieceInfo(new_info){
    pieceInfo.push(new_info)
  }

  function setupGame(payload){
    setupBoard(payload)
    setupCenter(payload)
    setupRotationalInfo()
    setupCamera()
    setupLights()
    addCursorCube(center[0], center[1], center[2])
  }

 
   

  
  
   //Event listeners from LiveView
   this.handleEvent("setup_game", (payload) => {
    setupGame(payload)
   })

   this.handleEvent("toggle_grid", (payload) => {
          const gridGroup = scene.getObjectByName("gridGroup")
          if (gridGroup.visible){
              gridGroup.visible = false
          } else {
              gridGroup.visible = true
          }
    })

    this.handleEvent("update_game", (payload) => {
      console.log(payload, "PAYLOAD")
})

//For cursor movement
 
//rotation hard calculate real positions based on grid size


  function getPositionFromRotationInfo(up, facing){
    for (let i = 0; i < rotationInfo.length; i++){
      if (arraysEqual(rotationInfo[i]["up"], up) && arraysEqual(rotationInfo[i]["facing"], facing)){
        return rotationInfo[i]["position"]
      }
    }
  }

  function rotate90DegreesClockwiseAlongXAxis(coordinates){
    const [x, y, z] = coordinates
    return [x, -z, y]
  }

  function rotate90DegreesCounterclockwiseAlongXAxis(coordinates){
    const [x, y, z] = coordinates
    return[x, z, -y]
  }

  function rotate90DegreesClockwiseAlongYAxis(coordinates){
    const [x, y, z] = coordinates
    return [-z, y, x]
  }
  
  function rotate90DegreesCounterclockwiseAlongYAxis(coordinates){
      const [x, y, z] = coordinates
      return [z, y, -x]
  }

  function rotate90DegreesClockwiseAlongZAxis(coordinates){
    const [x, y, z] = coordinates
    return [y, -x, z]
  }
  
  function rotate90DegreesCounterclockwiseAlongZAxis(coordinates){
      const [x, y, z] = coordinates
      return [-y, x, z]
  }

  function applyTransformationToPosition(transformation, position){
    const [a, b, c] = transformation
    const [x, y, z] = position
    return [a + x, b + y, c + z]
  }

  function positionInBounds(position){
    const [x, y, z] = position
    if (x < 1){
      return false
    }
    if (y < 1){
      return false
    }
    if (z < 1){
      return false
    }
    if (x > dimensions.rows){
      return false
    }
    if (y > dimensions.columns){
      return false
    }
    if (z > dimensions.levels){
      return false
    }
    return true
  }


  function updateCursorTransformation(rotationFunction){
    let newCursorTransformations = {}
    for (const [movement, transformation] of Object.entries(cursorTransformations)) {
      newCursorTransformations[movement] = rotationFunction(transformation)
    }
    cursorTransformations = newCursorTransformations
  }

  function updateCursorPosition(rotationFunction){
    const [a, b, c] = center
    const [x, y, z] = cursorPosition
    const translatedPosition = [x - a, y - b, z - c]
    const [newX, newY, newZ] = rotationFunction(translatedPosition)
    let newPosition = [newX + a, newY + b, newZ + c]
    newPosition = putPositionInBounds(newPosition)
    cursorPosition = newPosition
    const [posX, posY, posZ] = newPosition
    const cursor = scene.getObjectByName('cursor')
    cursor.position.set(posX, posY, posZ)
  }

  function putPositionInBounds(position){
    if (positionInBounds(position)){
      return position
    }
    const a = dimensions.rows
    const b = dimensions.columns
    const c = dimensions.levels
    const [x, y, z] = position
    let newPosition = []
    if (x > a){
      newPosition.push(a)
    } else if (x < 1){
      newPosition.push(1)
    } else {
      newPosition.push(x)
    }
    if (y > b){
      newPosition.push(b)
    } else if (y < 1){
      newPosition.push(1)
    } else {
      newPosition.push(y)
    }
    if (z > c){
      newPosition.push(c)
    } else if (z < 1){
      newPosition.push(1)
    } else {
      newPosition.push(z)
    }
    return newPosition
  }


  function arraysEqual(a, b) {
    if (a === b) return true;
    if (a == null || b == null) return false;
    if (a.length !== b.length) return false;
    for (var i = 0; i < a.length; ++i) {
      if (a[i] !== b[i]) return false;
    }
    return true;
  }

  //obj {up: , face:}
  function hasMatchingMatrix(arrOfObj, obj){
    for (let i = 0; i < arrOfObj.length; i++){
      if (arraysEqual(arrOfObj[i]["up"], obj["up"]) && arraysEqual(arrOfObj[i]["facing"], obj["facing"])){
        return true
      }
    }
    return false
  }

  function rotateElements(rotatingFunction){
    updatePositionAndUpDirection(rotatingFunction)
    updateCursorPosition(rotatingFunction)
    updateCursorTransformation(rotatingFunction)
  }

  function rotateAroundOrigin(position, origin, rotatingFunction){
    const [a, b, c] = origin
    const [x, y, z] = position
    const [newX, newY, newZ] = rotatingFunction([x - a, y - b, z - c])
    return [newX + a, newY + b, newZ + c]
  }

  function updatePositionAndUpDirection(rotatingFunction){
    currentUpDirection = rotatingFunction(currentUpDirection)
    currentFacingDirection = rotatingFunction(currentFacingDirection)
    const currentPosition = getPositionFromRotationInfo(currentUpDirection, currentFacingDirection)
    const cameraPosition = camera.position
    const newCameraPosition = rotateAroundOrigin([cameraPosition.x, cameraPosition.y, cameraPosition.z], center, rotatingFunction)
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.set(newCameraPosition[0], newCameraPosition[1], newCameraPosition[2])
    light.position.set(currentPosition[0], currentPosition[1], currentPosition[2]);
    camera.up.set( currentUpDirection[0], currentUpDirection[1], currentUpDirection[2]);
    controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(center[0], center[1], center[2])
    camera.lookAt(center[0], center[1], center[2])

  }

  //Optimize one day?

  function goToOrientation(finalUpDirection, finalFacingDirection){
    let rotationCount = 0
    
    while (!arraysEqual(currentUpDirection, finalUpDirection) && rotationCount < 4) {
      rotationCount += 1
      updatePositionAndUpDirection(rotate90DegreesClockwiseAlongZAxis)
    }
    rotationCount = 0
    while (!arraysEqual(currentUpDirection, finalUpDirection) && rotationCount < 4){
      rotationCount += 1
      updatePositionAndUpDirection(rotate90DegreesClockwiseAlongYAxis)
    }
    rotationCount = 0
    while (!arraysEqual(currentUpDirection, finalUpDirection) && rotationCount < 4){
      updatePositionAndUpDirection(rotate90DegreesClockwiseAlongXAxis)
    }
    if (arraysEqual(currentUpDirection, [1, 0, 0]) || arraysEqual(currentUpDirection, [-1, 0, 0])){
      while (!arraysEqual(currentFacingDirection, finalFacingDirection) ){
        updatePositionAndUpDirection(rotate90DegreesClockwiseAlongXAxis)
      }
      return
    }
    if (arraysEqual(currentUpDirection, [0, 1, 0]) || arraysEqual(currentUpDirection, [0, -1, 0])){
      while (!arraysEqual(currentFacingDirection, finalFacingDirection)){
        updatePositionAndUpDirection(rotate90DegreesClockwiseAlongYAxis)
      }
      return
    }
    if (arraysEqual(currentUpDirection, [0, 0, 1]) || arraysEqual(currentUpDirection, [0, 0, -1])){
      while (!arraysEqual(currentFacingDirection, finalFacingDirection)){
        updatePositionAndUpDirection(rotate90DegreesClockwiseAlongZAxis)
      }
      return
    }
  }

  function resetCameraPosition(){
    camera.up.set( currentUpDirection[0], currentUpDirection[1], currentUpDirection[2]);
    const currentPosition = getPositionFromRotationInfo(currentUpDirection, currentFacingDirection)
    camera.position.set(currentPosition[0], currentPosition[1], currentPosition[2])
    camera.lookAt(center[0], center[1], center[2])
  }

  function spinLeft(){
    if (arraysEqual(currentUpDirection, [0, 0, 1])){
      rotateElements(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
    if (arraysEqual(currentUpDirection, [0, 0, -1])){
      rotateElements(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 

    if (arraysEqual(currentUpDirection, [0, 1, 0])){
      rotateElements(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [0, -1, 0])){
      rotateElements(rotate90DegreesClockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [-1, 0, 0])){
      rotateElements(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [1, 0, 0])){
      rotateElements(rotate90DegreesClockwiseAlongXAxis)
      return 
    }
  }

  //HANDLE EVENTS
  this.handleEvent("spin_left", (payload) => {
    spinLeft()
  })

  function spinRight(){
    if (arraysEqual(currentUpDirection, [0, 0, -1])){
      rotateElements(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
    if (arraysEqual(currentUpDirection, [0, 0, 1])){
      rotateElements(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 

    if (arraysEqual(currentUpDirection, [0, -1, 0])){
      rotateElements(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [0, 1, 0])){
      rotateElements(rotate90DegreesClockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [1, 0, 0])){
      rotateElements(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [-1, 0, 0])){
      rotateElements(rotate90DegreesClockwiseAlongXAxis)
      return 
    }
  }
  this.handleEvent("spin_right", (payload) => {
    spinRight()
  })
  
  function flipBackward(){
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    }
  const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, 1]}]
  //-----
  if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesCounterclockwiseAlongYAxis)
    return 
  } 
  const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
  //-----
  if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesClockwiseAlongXAxis)
    return 
  } 

  const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, 1]}]

  if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesClockwiseAlongYAxis)
    return 
  } 

  const e = [{up: [0, 1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}]

  if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesCounterclockwiseAlongZAxis)
    return 
  } 

  const f = [{up: [0, 1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]

  if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesClockwiseAlongZAxis)
    return 
  } 
  }
  this.handleEvent("flip_backward", (payload) => {
    flipBackward()
  })

  function flipForward(){
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongXAxis)
      return 
    }
  const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, 1]}]
  //-----
  if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesClockwiseAlongYAxis)
    return 
  } 
  const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
  //-----
  if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesCounterclockwiseAlongXAxis)
    return 
  } 

  const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, 1]}]

  if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesCounterclockwiseAlongYAxis)
    return 
  } 

  const e = [{up: [0, 1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}]

  if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesClockwiseAlongZAxis)
    return 
  } 

  const f = [{up: [0, 1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]

  if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
    rotateElements(rotate90DegreesCounterclockwiseAlongZAxis)
    return 
  } 
  }

  this.handleEvent("flip_forward", (payload) => {
    flipForward()
  })

  function rotateLeft(){
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [0, 1, 0], facing: [1, 0, 0]},]
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongXAxis)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}]
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongYAxis)
      return 
    } 
    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [0, 1, 0], facing: [-1, 0, 0]}]
    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    } 
    const e = [{up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 1, 0], facing: [0, 0, -1]}]
    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 
    const f = [{up: [1, 0, 0], facing: [0, 0, 1]}, {up: [0, -1, 0], facing: [0, 0, 1]}, {up: [-1, 0, 0], facing: [0, 0, 1]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
  }
  this.handleEvent("rotate_left", (payload) => {
    rotateLeft()
  })

  function rotateRight(){
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongYAxis)
      return 
    }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [0, 1, 0], facing: [1, 0, 0]},]
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}]
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    } 
    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [0, 1, 0], facing: [-1, 0, 0]}]
    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongXAxis)
      return 
    } 
    const e = [{up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 1, 0], facing: [0, 0, -1]}]
    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
    const f = [{up: [1, 0, 0], facing: [0, 0, 1]}, {up: [0, -1, 0], facing: [0, 0, 1]}, {up: [-1, 0, 0], facing: [0, 0, 1]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      rotateElements(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 
  }
  this.handleEvent("rotate_right", (payload) => {
    rotateRight()
  })


  //HANDLE KEY INPUT
  function maybeMove(possibleNewPosition){
    if (positionInBounds(possibleNewPosition)){
      const [x, y, z] = possibleNewPosition
      const cursor = scene.getObjectByName('cursor')
      cursorPosition = possibleNewPosition
      cursor.position.set(x, y, z)
  }
    
  }
  this.handleEvent("keydown", (payload) => {
  if (payload.key == "q"){
    const possibleNewPosition = applyTransformationToPosition(cursorTransformations.up, cursorPosition)
    maybeMove(possibleNewPosition)
  }
  if (payload.key == "e"){
    const possibleNewPosition = applyTransformationToPosition(cursorTransformations.down, cursorPosition)
    maybeMove(possibleNewPosition)
  }
  if (payload.key == "w"){
    const possibleNewPosition = applyTransformationToPosition(cursorTransformations.forward, cursorPosition)
    maybeMove(possibleNewPosition)
  }
  if (payload.key == "s"){
    const possibleNewPosition = applyTransformationToPosition(cursorTransformations.backward, cursorPosition)
    maybeMove(possibleNewPosition)
  }
  if (payload.key == "a"){
    const possibleNewPosition = applyTransformationToPosition(cursorTransformations.left, cursorPosition)
    maybeMove(possibleNewPosition)
  }
  if (payload.key == "d"){
    const possibleNewPosition = applyTransformationToPosition(cursorTransformations.right, cursorPosition)
    maybeMove(possibleNewPosition)
  }
  if (payload.key == "c"){
    const cameraPosition = camera.position;
    console.log(cameraPosition.x, cameraPosition.y, cameraPosition.z);  
  }

  if (payload.key == "i"){
    spinLeft()
  }
  if (payload.key == "o"){
    spinRight()
  }
  if (payload.key == "k"){
    rotateLeft()
  }
  if (payload.key == "l"){
    rotateRight()
  }
  if (payload.key == "p"){
    flipForward()
  }
  if (payload.key == ";"){
    flipBackward()
  }
  if (payload.key == "["){
    resetCameraPosition()
  }
  
  if (payload.key == "Enter"){
    handleSelect()
  }

  if (payload.key == "Backspace"){
    handleDeSelect()
  }

  })


  //---ANIMATE
    const animate = function () {
      requestAnimationFrame(animate);
      renderer.render(scene, camera);
    };

    animate(); 
    }
}

export default ThreeHook

