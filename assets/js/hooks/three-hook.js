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

    //set camera around z axis
    //default
    camera.up.set( 0, 0, 1 );
    camera.position.set(3, -3, 3)

    //TEST
    // camera.up.set( 0, 1, 0 );
    // camera.position.set(3, 3, 9)
    
    let controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    const center = [3, 3, 3]
    camera.lookAt(center[0], center[1], center[2])

    renderer.setSize(window.innerWidth /2 , window.innerHeight/ 2);
    this.el.appendChild(renderer.domElement);
    renderer.setClearColor(0x000000, 0)

    const geometry = new THREE.BoxGeometry();
    const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });

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
  //Ambient Light only works with low metalness
  // const ambientLight = new THREE.AmbientLight(color, 10);
  // scene.add(ambientLight);
  // ambientLight.position.set(3, -3, 3)
  //---
  
  function changeCameraPosition(){

  }

  //rendering functions
  function clearScene(){
    scene.clear()
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
  
   //Event listeners from LiveView
   this.handleEvent("setup_game", (payload) => {
    const dimensions = payload.board_dimensions
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

    //BE SURE TO UPDATE ROTATION FOR PLAYER
    
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
      return coordinates
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

  this.handleEvent("spin_left", (payload) => {
    if (arraysEqual(currentUpDirection, [0, 0, 1])){
      let newPosition = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    } 
    if (arraysEqual(currentUpDirection, [0, 0, -1])){
      let newPosition = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    } 

    if (arraysEqual(currentUpDirection, [0, 1, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }

    if (arraysEqual(currentUpDirection, [0, -1, 0])){
      let newPosition = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }

    if (arraysEqual(currentUpDirection, [-1, 0, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }

    if (arraysEqual(currentUpDirection, [1, 0, 0])){
      let newPosition = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }
    
  })

  this.handleEvent("spin_right", (payload) => {
    if (arraysEqual(currentUpDirection, [0, 0, -1])){
      let newPosition = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    } 
    if (arraysEqual(currentUpDirection, [0, 0, 1])){
      let newPosition = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    } 

    if (arraysEqual(currentUpDirection, [0, -1, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }

    if (arraysEqual(currentUpDirection, [0, 1, 0])){
      let newPosition = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }

    if (arraysEqual(currentUpDirection, [1, 0, 0])){
      let newPosition = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }

    if (arraysEqual(currentUpDirection, [-1, 0, 0])){
      let newPosition = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(currentUpDirection, newPosition)
      return 
    }
  })
  
  this.handleEvent("flip_backward", (payload) => {
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, 1]}]
      if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
        let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
        let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
        updatePositionAndUpDirection(newUpDirection, newFacingDirection)
        return 
      }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 

    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, 1]}]

    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 

    const e = [{up: [0, 1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 

    const f = [{up: [0, 1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
  })

  this.handleEvent("flip_forward", (payload) => {
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, 1]}]
      if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
        let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
        let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
        updatePositionAndUpDirection(newUpDirection, newFacingDirection)
        return 
      }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    //-----
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 

    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 0, 1]}]

    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 

    const e = [{up: [0, 1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 

    const f = [{up: [0, 1, 0], facing: [1, 0, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]

    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
  })

  let current_x_rotation = 0
  this.handleEvent("rotate_left", (payload) => {
    console.log(currentUpDirection, currentFacingDirection)
    const a = [{up: [0, 0, 1], facing: [0, 1, 0]}, {up: [1, 0, 0], facing: [0, 1, 0]}, {up: [0, 0, -1], facing: [0, 1, 0]}, {up: [-1, 0, 0], facing: [0, 1, 0]}]
    if (hasMatchingMatrix(a, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [0, 1, 0], facing: [1, 0, 0]},]
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}]
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [0, 1, 0], facing: [-1, 0, 0]}]
    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const e = [{up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 1, 0], facing: [0, 0, -1]}]
    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const f = [{up: [1, 0, 0], facing: [0, 0, 1]}, {up: [0, -1, 0], facing: [0, 0, 1]}, {up: [-1, 0, 0], facing: [0, 0, 1]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
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
      return 
    }
    const b = [{up: [0, 0, 1], facing: [1, 0, 0]}, {up: [0, -1, 0], facing: [1, 0, 0]}, {up: [0, 0, -1], facing: [1, 0, 0]}, {up: [0, 1, 0], facing: [1, 0, 0]},]
    if (hasMatchingMatrix(b, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const c = [{up: [0, 0, 1], facing: [0, -1, 0]}, {up: [1, 0, 0], facing: [0, -1, 0]}, {up: [0, 0, -1], facing: [0, -1, 0]}, {up: [-1, 0, 0], facing: [0, -1, 0]}]
    if (hasMatchingMatrix(c, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongYAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const d = [{up: [0, 0, 1], facing: [-1, 0, 0]}, {up: [0, -1, 0], facing: [-1, 0, 0]}, {up: [0, 0, -1], facing: [-1, 0, 0]}, {up: [0, 1, 0], facing: [-1, 0, 0]}]
    if (hasMatchingMatrix(d, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongXAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongXAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const e = [{up: [1, 0, 0], facing: [0, 0, -1]}, {up: [0, -1, 0], facing: [0, 0, -1]}, {up: [-1, 0, 0], facing: [0, 0, -1]}, {up: [0, 1, 0], facing: [0, 0, -1]}]
    if (hasMatchingMatrix(e, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesCounterclockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
    } 
    const f = [{up: [1, 0, 0], facing: [0, 0, 1]}, {up: [0, -1, 0], facing: [0, 0, 1]}, {up: [-1, 0, 0], facing: [0, 0, 1]}, {up: [0, 1, 0], facing: [0, 0, 1]}]
    if (hasMatchingMatrix(f, {up: currentUpDirection, facing: currentFacingDirection})){
      let newUpDirection = rotate90DegreesClockwiseAlongZAxis(currentUpDirection)
      let newFacingDirection = rotate90DegreesClockwiseAlongZAxis(currentFacingDirection)
      updatePositionAndUpDirection(newUpDirection, newFacingDirection)
      return 
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

