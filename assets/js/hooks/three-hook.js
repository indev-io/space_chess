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
  //Lights
  const color = 0xFFFFFF;
  const intensity = 10;
  const light = new THREE.DirectionalLight(color, intensity);
  light.position.set(3,-5, 6);
  scene.add(light);
  //Ambient Light
  const ambientLight = new THREE.AmbientLight(color, 5);
  scene.add(ambientLight);
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
      // const shape = "BoxGeometry(0.5, 0.5, 0.5)"
      // const geometry = new THREE.BoxGeometry(0.5, 0.5, 0.5)
      const geometry = eval(`new THREE.${info.model}`)
      const material = new THREE.MeshStandardMaterial( { color: info.color, roughness: 0.377, metalness: 1} )
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

//CREATE TWo Arrays
  let current_position = [3, -3, 3]
  let current_up_direction = [0, 0, 1]
                      //face, top, back, bottom
  const longitudinal = [[3, -3, 3], [3, 3, 9], [3, 9, 3], [3, 3, -3]]
                      //face, right, back, left
  const latitudinal = [[3, -3, 3], [9, 3, 3], [3, 9, 3], [-3, 3, 3]]
  const rotation =  0

  function arraysEqual(a, b) {
    if (a === b) return true;
    if (a == null || b == null) return false;
    if (a.length !== b.length) return false;
    for (var i = 0; i < a.length; ++i) {
      if (a[i] !== b[i]) return false;
    }
    return true;
  }

  function updatePositionAndUpDirection(position, upDirection){
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.set(position[0], position[1], position[2])
    camera.up.set( upDirection[0], upDirection[1], upDirection[2]);
    controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    camera.lookAt(3, 3, 3)
  }


  var current_z_rotation = 0
  this.handleEvent("spin_left", (payload) => {
    positions = [[3, -3, 3], [9, 3, 3], [3, 9, 3], [-3, 3, 3]]
    current_z_rotation += 1
    if (current_z_rotation > positions.length - 1){
      current_z_rotation = 0
    }
    new_position = positions[current_z_rotation] 
    camera.position.set(new_position[0], new_position[1] , new_position[2])
    camera.lookAt(center[0], center[1], center[2])

  })

  this.handleEvent("spin_right", (payload) => {
    positions = [[3, -3, 3], [9, 3, 3], [3, 9, 3], [-3, 3, 3]]
    current_z_rotation -= 1
    if (current_z_rotation < 0){
      current_z_rotation = positions.length - 1
    }
    new_position = positions[current_z_rotation] 
    camera.position.set(new_position[0], new_position[1] , new_position[2])
    camera.lookAt(center[0], center[1], center[2])

  })

  var current_y_rotation = 0
  this.handleEvent("flip_backward", (payload) => {
    positions = [[3, -3, 3], [3, 3, 9], [3, 9, 3], [3, 3, -3]]
    ups = [[0, 0, 1], [0, 1, 0], [0, 0, -1], [0, -1, 0]]
    current_y_rotation += 1
    if (current_y_rotation > positions.length - 1){
      current_y_rotation = 0
    }
    new_position = positions[current_y_rotation]
    new_up = ups[current_y_rotation]
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.set(new_position[0], new_position[1], new_position[2])
    camera.up.set( new_up[0], new_up[1], new_up[2]);
    controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    camera.lookAt(3, 3, 3)
  })

  this.handleEvent("flip_forward", (payload) => {
    positions = [[3, -3, 3], [3, 3, 9], [3, 9, 3], [3, 3, -3]]
    const ups = [[0, 0, 1], [0, 1, 0], [0, 0, -1], [0, -1, 0]]
    current_y_rotation -= 1
    if (current_y_rotation < 0){
      current_y_rotation = positions.length - 1
    }
    new_position = positions[current_y_rotation]
    const new_up = ups[current_y_rotation]
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.set(new_position[0], new_position[1], new_position[2])
    camera.up.set( new_up[0], new_up[1], new_up[2]);
    controls = new OrbitControls(camera, renderer.domElement)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    camera.lookAt(3, 3, 3)
  })

  var current_x_rotation = 0
  this.handleEvent("rotate_right", (payload) => {
    // camera.lookAt(3, 3, 3)
    current_x_rotation += 1
    if (current_x_rotation > 3){
      current_x_rotation = 0
    }

    console.log("HELLO, IS THERE ANYBODY IN THERE?!")
    // camera.rotation.z = (Math.PI/2 * current_x_rotation)
    
    
    const ups = [[0, 0, 1], [-1, 0, 0], [0, 0, -1], [1, 0, 0]]
    const new_up = ups[current_x_rotation]
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.up.set(new_up[0], new_up[1], new_up[2]);
    controls = new OrbitControls(camera, renderer.domElement)
    //set current_position
    camera.position.set(3, -3, 3,)
    controls.target = new THREE.Vector3(3 , 3 , 3)
    camera.lookAt(3, 3, 3)
    

  })

  this.handleEvent("rotate_left", (payload) => {
    camera.lookAt(3, 3, 3)
    current_x_rotation -= 1
    camera.rotation.z = (Math.PI/2 * current_x_rotation)
    
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

