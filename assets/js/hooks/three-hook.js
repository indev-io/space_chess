import * as THREE from "../../vendor/three/three.module.js"
import { OrbitControls } from "../../vendor/three/OrbitControls.js"
//needed for eval
window.THREE = THREE

const ThreeHook = {
    mounted(){

        
    // For example:
    const scene = new THREE.Scene();
    let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();

    camera.up.set( 0, 0, 1 );
    camera.position.set(3, -3, 3)

    let controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    const center = [3, 3, 3]
    camera.lookAt(center[0], center[1], center[2])

    renderer.setSize(window.innerWidth /2 , window.innerHeight/ 2);
    this.el.appendChild(renderer.domElement);
    renderer.setClearColor(0x000000, 0)

    //Window resizing
    window.addEventListener( 'resize', onWindowResize, false );

function onWindowResize(){
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize( window.innerWidth * .85, window.innerHeight );
}


  //offset
  const offset = [0, -2, 3]
  //Lights
  const color = 0xFFFFFF;
  const intensity = 10;
  const light = new THREE.DirectionalLight(color, intensity);
  light.position.set(3,-3, 3);
  scene.add(light);
  //--Ambient light only affects non-metallic items, should be set at the center and not change
  const ambientLight = new THREE.AmbientLight(color, 5);
  ambientLight.position.set(3, 3, 3);
  scene.add(ambientLight);
  //---
  //GLOBAL VALUES
  let dimensions;
  let cursorPosition = center
  let cursorTransformations = {
    "up" : [0, 0, 1],
    "down": [0, 0, -1],
    "left": [-1, 0, 0],
    "right": [1, 0, 0],
    "backward": [0, -1, 0],
    "forward": [0, 1, 0] 
  }
//-----GLOBAL VALUES
  //rendering functions
  function clearScene(){
    scene.clear()
  }

  function addCursorCube(x,y,z){
    const geometry = new THREE.BoxGeometry( 1, 1, 1);
    const material = new THREE.MeshLambertMaterial( { color: 0x0000ff, transparent: true, opacity: 0.6} );
    const o = new THREE.Mesh( geometry, material );
    scene.add( o );
    o.position.set(x,y,z)
    o.name = 'cursor'   
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
                line.position.set(i + 1, k + 1, j + 1)
                gridGroup.add(line);
          }
        }
      }
      gridGroup.visible = true;
      scene.add(gridGroup)
    }

  function renderBoard(board){
      console.log("HELLO")
  }

  //primitive
  function renderBoard(payload){
    // scene.clear()
    dimensions = payload.board_dimensions
    const columns = dimensions.columns 
    const rows = dimensions.rows
    const levels = dimensions.levels
    render3Dgrid(columns, rows, levels)
    const pieces = payload.pieces
    for (const [piece, info] of Object.entries(pieces)) {

      const geometry = eval(`new THREE.${info.model}`)
      const material = new THREE.MeshStandardMaterial( { color: info.color, roughness: 0.477, metalness: 1} )
      const obj = new THREE.Mesh( geometry, material );

      scene.add(obj)
      const [x, y, z] = info.coords
      obj.position.set(x, y, z)
      obj.name = piece
    }
    
  }
  
   //Event listeners from LiveView
   this.handleEvent("setup_game", (payload) => {
    renderBoard(payload)
    addCursorCube(center[0], center[1], center[2])
   })

   this.handleEvent("toggle_grid", (payload) => {
          const gridGroup = scene.getObjectByName("gridGroup")
          if (gridGroup.visible){
              gridGroup.visible = false
          } else {
              gridGroup.visible = true
          }
          console.log("Yes Toggle", payload)
    })

    this.handleEvent("update_game", (payload) => {
      console.log(payload, "PAYLOAD")
      // renderBoard(payload)
})

//For cursor movement
 
//rotation hard calculate real positions based on grid size
  let currentUpDirection = [0, 0, 1]
  let currentFacingDirection = [0, 1, 0]

  const rotationInfo = [
    {up: [1, 0, 0], facing: [0, 1, 0], position: [3, -3, 3]},
    {up: [1, 0, 0], facing: [0, -1, 0],  position: [3, 9, 3]},
    {up: [1, 0, 0], facing: [0, 0, 1], position: [3, 3, -3]},
    {up: [1, 0, 0], facing: [0, 0, -1], position: [3, 3, 9]},
    {up: [-1, 0, 0], facing: [0, 1, 0], position: [3, -3, 3]},
    {up: [-1, 0, 0], facing: [0, -1, 0], position: [3, 9, 3]},
    {up: [-1, 0, 0], facing: [0, 0, 1], position: [3, 3, -3]},
    {up: [-1, 0, 0], facing: [0, 0, -1], position: [3, 3, 9]},
    {up: [0, 1, 0], facing: [1, 0, 0], position: [-3, 3, 3] },
    {up: [0, 1, 0], facing: [-1, 0, 0], position: [9, 3, 3]},
    {up: [0, 1, 0], facing: [0, 0, 1], position: [3, 3, -3]},
    {up: [0, 1, 0], facing: [0, 0, -1], position: [3, 3, 9]},
    {up: [0, -1, 0], facing: [1, 0, 0], position: [-3, 3, 3] },
    {up: [0, -1, 0], facing: [-1, 0, 0], position: [9, 3, 3]},
    {up: [0, -1, 0], facing: [0, 0, 1], position: [3, 3, -3]},
    {up: [0, -1, 0], facing: [0, 0, -1], position: [3, 3, 9]},
    {up: [0, 0, 1], facing: [1, 0, 0], position: [-3, 3, 3] },
    {up: [0, 0, 1], facing: [-1, 0, 0], position: [9, 3, 3]},
    {up: [0, 0, 1], facing: [0, 1, 0], position: [3, -3, 3]},
    {up: [0, 0, 1], facing: [0, -1, 0], position: [3, 9, 3]},
    {up: [0, 0, -1], facing: [1, 0, 0], position: [-3, 3, 3]},
    {up: [0, 0, -1], facing: [-1, 0, 0], position: [9, 3, 3]},
    {up: [0, 0, -1], facing: [0, 1, 0], position: [3, -3, 3]},
    {up: [0, 0, -1], facing: [0, -1, 0], position: [3, 9, 3]},
  ]

  function getPositionFromRotationInfo(up, facing){
    for (let i = 0; i < rotationInfo.length; i++){
      if (arraysEqual(rotationInfo[i]["up"], up) && arraysEqual(rotationInfo[i]["facing"], facing)){
        console.log(i, "LOOKUP")
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
    const newPosition = [newX + a, newY + b, newZ + c]
    cursorPosition = newPosition
    const [posX, posY, posZ] = newPosition
    const cursor = scene.getObjectByName('cursor')
    cursor.position.set(posX, posY, posZ)
  }

  function putPositionInBounds(){

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

  function updatePositionAndUpDirection(upDirection, facingDirection){
      currentUpDirection = upDirection
      currentFacingDirection = facingDirection
      const currentPosition = getPositionFromRotationInfo(upDirection, facingDirection)
      camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
      camera.position.set(currentPosition[0], currentPosition[1], currentPosition[2])
      light.position.set(currentPosition[0], currentPosition[1], currentPosition[2]);
      camera.up.set( upDirection[0], upDirection[1], upDirection[2]);
      controls = new OrbitControls(camera, renderer.domElement)
      controls.target = new THREE.Vector3(center[0], center[1], center[2])
      camera.lookAt(center[0], center[1], center[2])
  }

  //HANDLE EVENTS
  this.handleEvent("spin_left", (payload) => {
    if (arraysEqual(currentUpDirection, [0, 0, 1])){
      let newPosition = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
    if (arraysEqual(currentUpDirection, [0, 0, -1])){
      let newPosition = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesClockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 

    if (arraysEqual(currentUpDirection, [0, 1, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [0, -1, 0])){
      let newPosition = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesClockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [-1, 0, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [1, 0, 0])){
      let newPosition = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesClockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongXAxis)
      return 
    }
    
  })

  this.handleEvent("spin_right", (payload) => {
    if (arraysEqual(currentUpDirection, [0, 0, -1])){
      let newPosition = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
    if (arraysEqual(currentUpDirection, [0, 0, 1])){
      let newPosition = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesClockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 

    if (arraysEqual(currentUpDirection, [0, -1, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [0, 1, 0])){
      let newPosition = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesClockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongYAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [1, 0, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    }

    if (arraysEqual(currentUpDirection, [-1, 0, 0])){
      let newPosition = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      updateCursorTransformation(rotate90DegreesClockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongXAxis)
      return 
    }
  })
  
  this.handleEvent("flip_backward", (payload) => {
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, 1]}]
      if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
        let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
        let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
        updatePositionAndUpDirection(newUpDirection, newFacingDirection)
        updateCursorTransformation(rotate90DegreesCounterclockwiseAlongXAxis)
        updateCursorPosition(rotate90DegreesCounterclockwiseAlongXAxis)
        return 
      }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongXAxis)
      return 
    } 

    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, 1]}]

    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongYAxis)
      return 
    } 

    const e = [{up: [0, 1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 

    const f = [{up: [0, 1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 
  })

  this.handleEvent("flip_forward", (payload) => {
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, 1]}]
      if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
        let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
        let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
        updatePositionAndUpDirection(newUpDirection, newFacingDirection)
        updateCursorTransformation(rotate90DegreesClockwiseAlongXAxis)
        updateCursorPosition(rotate90DegreesClockwiseAlongXAxis)
        return 
      }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongYAxis)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    } 

    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, 1]}]

    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    } 

    const e = [{up: [0, 1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 

    const f = [{up: [0, 1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
  })

  this.handleEvent("rotate_left", (payload) => {
    console.log(currentUpDirection, currentFacingDirection)
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [0, 1, 0], facing: [1, 0, 0]},]
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongXAxis)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}]
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongYAxis)
      return 
    } 
    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [0, 1, 0], facing: [-1, 0, 0]}]
    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    } 
    const e = [{up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 1, 0], facing: [0, 0, -1]}]
    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 
    const f = [{up: [1, 0, 0], facing: [0, 0, 1]}, {up: [0, -1, 0], facing: [0, 0, 1]}, {up: [-1, 0, 0], facing: [0, 0, 1]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
  })

  this.handleEvent("rotate_right", (payload) => {
    console.log(currentUpDirection, currentFacingDirection)
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongYAxis)
      return 
    }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [0, 1, 0], facing: [1, 0, 0]},]
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongXAxis)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}]
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongYAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongYAxis)
      return 
    } 
    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [0, 1, 0], facing: [-1, 0, 0]}]
    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongXAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongXAxis)
      return 
    } 
    const e = [{up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 1, 0], facing: [0, 0, -1]}]
    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesCounterclockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesCounterclockwiseAlongZAxis)
      return 
    } 
    const f = [{up: [1, 0, 0], facing: [0, 0, 1]}, {up: [0, -1, 0], facing: [0, 0, 1]}, {up: [-1, 0, 0], facing: [0, 0, 1]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      updateCursorTransformation(rotate90DegreesClockwiseAlongZAxis)
      updateCursorPosition(rotate90DegreesClockwiseAlongZAxis)
      return 
    } 
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

